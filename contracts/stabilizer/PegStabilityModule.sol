pragma solidity ^0.8.4;

import "./../token/Fei.sol";
import "./../pcv/PCVDeposit.sol";
import "./../utils/RateLimitedMinter.sol";
import "./IPegStabilityModule.sol";
import "./../refs/CoreRef.sol";
import "./../refs/OracleRef.sol";
import "../Constants.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract PegStabilityModule is RateLimitedMinter, IPegStabilityModule, ReentrancyGuard {
    using Decimal for Decimal.D256;
    using SafeCast for *;
    using SafeERC20 for IERC20;

    /// @notice the fee in basis points for selling asset into FEI
    uint256 public override mintFeeBasisPoints;

    /// @notice the fee in basis points for buying the asset for FEI
    uint256 public override redeemFeeBasisPoints;

    /// @notice the amount of reserves to be held for redemptions
    uint256 public override reservesThreshold;

    /// @notice the PCV deposit target
    IPCVDeposit public override surplusTarget;

    /// @notice the token this PSM will exchange for FEI
    /// This token will be set to WETH9 if the bonding curve accepts eth
    IERC20 public immutable override underlyingToken;

    /// @notice the max mint and redeem fee in basis points
    /// Governance can change this fee
    uint256 public override maxFee = 500;

    /// @notice constructor
    /// @param _coreAddress Fei core to reference
    /// @param _oracleAddress Price oracle to reference
    /// @param _backupOracle Backup price oracle to reference
    /// @param _mintFeeBasisPoints fee in basis points to buy Fei
    /// @param _redeemFeeBasisPoints fee in basis points to sell Fei
    /// @param _reservesThreshold amount of tokens to hold in this contract
    /// @param _feiLimitPerSecond must be less than or equal to 10,000 fei per second; the rate that the buffer grows
    /// @param _mintingBufferCap cap of buffer that can be used at once
    /// @param _decimalsNormalizer normalize decimals in oracle if tokens have different decimals
    /// @param _doInvert invert oracle price if true
    /// @param _underlyingToken token to buy and sell against Fei
    /// @param _surplusTarget pcv deposit to send surplus reserves to
    constructor(
        address _coreAddress,
        address _oracleAddress,
        address _backupOracle,
        uint256 _mintFeeBasisPoints,
        uint256 _redeemFeeBasisPoints,
        uint256 _reservesThreshold,
        uint256 _feiLimitPerSecond,
        uint256 _mintingBufferCap,
        int256 _decimalsNormalizer,
        bool _doInvert,
        IERC20 _underlyingToken,
        IPCVDeposit _surplusTarget
    )
        OracleRef(_coreAddress, _oracleAddress, _backupOracle, _decimalsNormalizer, _doInvert)
        /// rate limited minter passes false as the last param as there can be no partial mints
        RateLimitedMinter(_feiLimitPerSecond, _mintingBufferCap, false)
    {
        underlyingToken = _underlyingToken;

        _setReservesThreshold(_reservesThreshold);
        _setMintFee(_mintFeeBasisPoints);
        _setRedeemFee(_redeemFeeBasisPoints);
        _setSurplusTarget(_surplusTarget);
        _setContractAdminRole(keccak256("PSM_ADMIN_ROLE"));
    }

    // ----------- Governor or Admin Only State Changing API -----------

    /// @notice withdraw assets from PSM to an external address
    function withdraw(address to, uint256 amount) external override virtual onlyPCVController {
        _withdrawERC20(address(underlyingToken), to, amount);
    }

    /// @notice update the fee limit
    function setMaxFee(uint256 newMaxFeeBasisPoints) external onlyGovernor {
        require(newMaxFeeBasisPoints < Constants.BASIS_POINTS_GRANULARITY, "PegStabilityModule: Invalid Fee");
        uint256 oldMaxFee = maxFee;
        maxFee = newMaxFeeBasisPoints;

        emit MaxFeeUpdate(oldMaxFee, newMaxFeeBasisPoints);
    }

    /// @notice set the mint fee vs oracle price in basis point terms
    function setMintFee(uint256 newMintFeeBasisPoints) external override onlyGovernorOrAdmin {
        _setMintFee(newMintFeeBasisPoints);
    }

    /// @notice set the redemption fee vs oracle price in basis point terms
    function setRedeemFee(uint256 newRedeemFeeBasisPoints) external override onlyGovernorOrAdmin {
        _setRedeemFee(newRedeemFeeBasisPoints);
    }

    /// @notice set the ideal amount of reserves for the contract to hold for redemptions
    function setReservesThreshold(uint256 newReservesThreshold) external override onlyGovernorOrAdmin {
        _setReservesThreshold(newReservesThreshold);
    }

    /// @notice set the target for sending surplus reserves
    function setSurplusTarget(IPCVDeposit newTarget) external override onlyGovernorOrAdmin {
        _setSurplusTarget(newTarget);
    }

    /// @notice set the mint fee vs oracle price in basis point terms
    function _setMintFee(uint256 newMintFeeBasisPoints) internal {
        require(newMintFeeBasisPoints <= maxFee, "PegStabilityModule: Mint fee exceeds max fee");
        uint256 _oldMintFee = mintFeeBasisPoints;
        mintFeeBasisPoints = newMintFeeBasisPoints;

        emit MintFeeUpdate(_oldMintFee, newMintFeeBasisPoints);
    }

    /// @notice internal helper function to set the redemption fee
    function _setRedeemFee(uint256 newRedeemFeeBasisPoints) internal {
        require(newRedeemFeeBasisPoints <= maxFee, "PegStabilityModule: Redeem fee exceeds max fee");
        uint256 _oldRedeemFee = redeemFeeBasisPoints;
        redeemFeeBasisPoints = newRedeemFeeBasisPoints;

        emit RedeemFeeUpdate(_oldRedeemFee, newRedeemFeeBasisPoints);
    }

    /// @notice helper function to set reserves threshold
    function _setReservesThreshold(uint256 newReservesThreshold) internal {
        require(newReservesThreshold > 0, "PegStabilityModule: Invalid new reserves threshold");
        uint256 oldReservesThreshold = reservesThreshold;
        reservesThreshold = newReservesThreshold;

        emit ReservesThresholdUpdate(oldReservesThreshold, newReservesThreshold);
    }

    /// @notice helper function to set the surplus target
    function _setSurplusTarget(IPCVDeposit newSurplusTarget) internal {
        require(address(newSurplusTarget) != address(0), "PegStabilityModule: Invalid new surplus target");
        IPCVDeposit oldTarget = surplusTarget;
        surplusTarget = newSurplusTarget;

        emit SurplusTargetUpdate(oldTarget, newSurplusTarget);
    }

    // ----------- Public State Changing API -----------

    /// @notice send any surplus reserves to the PCV allocation
    function allocateSurplus() external override {
        int256 currentSurplus = reservesSurplus();
        require(currentSurplus > 0, "PegStabilityModule: No surplus to allocate");

        _allocate(currentSurplus.toUint256());
    }

    /// @notice function to receive ERC20 tokens from external contracts
    function deposit() external override {
        int256 currentSurplus = reservesSurplus();
        if (currentSurplus > 0 ) {
            _allocate(currentSurplus.toUint256());
        }
        emit PSMDeposit(msg.sender);
    }

    /// @notice function to redeem FEI for an underlying asset
    function redeem(
        address to,
        uint256 amountFeiIn,
        uint256 minAmountOut
    ) external virtual override nonReentrant whenNotPaused returns (uint256 amountOut) {
        updateOracle();

        amountOut = _getRedeemAmountOutAndPrice(amountFeiIn);
        require(amountOut >= minAmountOut, "PegStabilityModule: Redeem not enough out");

        fei().transferFrom(msg.sender, address(this), amountFeiIn);
        
        // We do not burn Fei; this allows the contract's balance of Fei to be used before the buffer is used
        // In practice, this helps prevent artificial cycling of mint-burn cycles and prevents a griefing vector.

        _transfer(to, amountOut);

        emit Redeem(to, amountFeiIn);
    }

    /// @notice function to buy FEI for an underlying asset
    function mint(
        address to,
        uint256 amountIn,
        uint256 minAmountOut
    ) external virtual override nonReentrant whenNotPaused returns (uint256 amountFeiOut) {
        updateOracle();

        amountFeiOut = _getMintAmountOutAndPrice(amountIn);
        require(amountFeiOut >= minAmountOut, "PegStabilityModule: Mint not enough out");

        _transferFrom(msg.sender, address(this), amountIn);

        // We first transfer any contract-owned fei, then mint the remaining if necessary
        uint256 amountFeiToTransfer = Math.min(fei().balanceOf(address(this)), amountFeiOut);
        uint256 amountFeiToMint = amountFeiOut - amountFeiToTransfer;

        _transfer(to, amountFeiToTransfer);

        if (amountFeiToMint > 0) {
            _mintFei(to, amountFeiOut);
        }
        
        emit Mint(to, amountIn);
    }

    // ----------- Public View-Only API ----------

    /// @notice calculate the amount of FEI out for a given `amountIn` of underlying
    /// First get oracle price of token
    /// Then figure out how many dollars that amount in is worth by multiplying price * amount.
    /// ensure decimals are normalized if on underlying they are not 18
    function getMintAmountOut(uint256 amountIn) public override view returns (uint256 amountFeiOut) {
        amountFeiOut = _getMintAmountOutAndPrice(amountIn);
    }

    /// @notice calculate the amount of underlying out for a given `amountFeiIn` of FEI
    /// First get oracle price of token
    /// Then figure out how many dollars that amount in is worth by multiplying price * amount.
    /// ensure decimals are normalized if on underlying they are not 18
    function getRedeemAmountOut(uint256 amountFeiIn) public override view returns (uint256 amountTokenOut) {
        amountTokenOut = _getRedeemAmountOutAndPrice(amountFeiIn);
    }

    /// @notice a flag for whether the current balance is above (true) or below (false) the reservesThreshold
    function hasSurplus() external override view returns (bool) {
        return balance() > reservesThreshold;
    }

    /// @notice an integer representing the positive surplus or negative deficit of contract balance vs reservesThreshold
    function reservesSurplus() public override view returns (int256) {
        return balance().toInt256() - reservesThreshold.toInt256();
    }

    /// @notice function from PCVDeposit that must be overriden
    function balance() public view override virtual returns(uint256) {
        return underlyingToken.balanceOf(address(this));
    }

    /// @notice returns address of token this contracts balance is reported in
    function balanceReportedIn() external view override returns (address) {
        return address(underlyingToken);
    }

    // ----------- Internal Methods -----------

    /// @notice helper function to get mint amount out based on current market prices
    /// will revert if price is outside of bounds and bounded PSM is being used
    function _getMintAmountOutAndPrice(uint256 amountIn) private view returns (uint256 amountFeiOut) {
        Decimal.D256 memory price = readOracle();
        _validatePriceRange(price);

        Decimal.D256 memory adjustedAmountIn = price.mul(amountIn);

        amountFeiOut = adjustedAmountIn
            .mul(Constants.BASIS_POINTS_GRANULARITY - mintFeeBasisPoints)
            .div(Constants.BASIS_POINTS_GRANULARITY)
            .asUint256();
    }

    /// @notice helper function to get redeem amount out based on current market prices
    /// will revert if price is outside of bounds and bounded PSM is being used
    function _getRedeemAmountOutAndPrice(uint256 amountFeiIn) private view returns (uint256 amountTokenOut) {
        Decimal.D256 memory price = readOracle();
        _validatePriceRange(price);

        /// get amount of dollars being provided
        Decimal.D256 memory adjustedAmountIn = Decimal.from(
            amountFeiIn * (Constants.BASIS_POINTS_GRANULARITY - redeemFeeBasisPoints) / Constants.BASIS_POINTS_GRANULARITY
        );

        /// now turn the dollars into the underlying token amounts
        /// dollars / price = how much token to pay out
        amountTokenOut = adjustedAmountIn.div(price).asUint256();
    }

    /// @notice Allocates a portion of escrowed PCV to a target PCV deposit
    function _allocate(uint256 amount) internal {
        _transfer(address(surplusTarget), amount);
        surplusTarget.deposit();

        emit AllocateSurplus(msg.sender, amount);
    }

    /// @notice transfer ERC20 token
    function _transfer(address to, uint256 amount) internal {
        SafeERC20.safeTransfer(underlyingToken, to, amount);
    }

    /// @notice transfer assets from user to this contract
    function _transferFrom(address from, address to, uint256 amount) internal {
        SafeERC20.safeTransferFrom(underlyingToken, from, to, amount);
    }

    /// @notice mint amount of FEI to the specified user on a rate limit
    function _mintFei(address to, uint256 amount) internal override(CoreRef, RateLimitedMinter) {
        super._mintFei(to, amount);
    }

    // ----------- Hooks -----------

    /// @notice overriden function in the bounded PSM
    function _validatePriceRange(Decimal.D256 memory price) internal view virtual {}
}