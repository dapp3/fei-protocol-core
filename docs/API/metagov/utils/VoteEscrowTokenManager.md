## <span id="VoteEscrowTokenManager"></span> `VoteEscrowTokenManager`



- [`ifMinterSelf()`][CoreRef-ifMinterSelf--]
- [`onlyMinter()`][CoreRef-onlyMinter--]
- [`onlyBurner()`][CoreRef-onlyBurner--]
- [`onlyPCVController()`][CoreRef-onlyPCVController--]
- [`onlyGovernorOrAdmin()`][CoreRef-onlyGovernorOrAdmin--]
- [`onlyGovernor()`][CoreRef-onlyGovernor--]
- [`onlyGuardianOrGovernor()`][CoreRef-onlyGuardianOrGovernor--]
- [`isGovernorOrGuardianOrAdmin()`][CoreRef-isGovernorOrGuardianOrAdmin--]
- [`onlyTribeRole(bytes32 role)`][CoreRef-onlyTribeRole-bytes32-]
- [`hasAnyOfTwoRoles(bytes32 role1, bytes32 role2)`][CoreRef-hasAnyOfTwoRoles-bytes32-bytes32-]
- [`hasAnyOfThreeRoles(bytes32 role1, bytes32 role2, bytes32 role3)`][CoreRef-hasAnyOfThreeRoles-bytes32-bytes32-bytes32-]
- [`hasAnyOfFourRoles(bytes32 role1, bytes32 role2, bytes32 role3, bytes32 role4)`][CoreRef-hasAnyOfFourRoles-bytes32-bytes32-bytes32-bytes32-]
- [`hasAnyOfFiveRoles(bytes32 role1, bytes32 role2, bytes32 role3, bytes32 role4, bytes32 role5)`][CoreRef-hasAnyOfFiveRoles-bytes32-bytes32-bytes32-bytes32-bytes32-]
- [`onlyFei()`][CoreRef-onlyFei--]
- [`whenNotPaused()`][Pausable-whenNotPaused--]
- [`whenPaused()`][Pausable-whenPaused--]
- [`constructor(contract IERC20 _liquidToken, contract IVeToken _veToken, uint256 _lockDuration)`][VoteEscrowTokenManager-constructor-contract-IERC20-contract-IVeToken-uint256-]
- [`setLockDuration(uint256 newLockDuration)`][VoteEscrowTokenManager-setLockDuration-uint256-]
- [`lock()`][VoteEscrowTokenManager-lock--]
- [`exitLock()`][VoteEscrowTokenManager-exitLock--]
- [`_totalTokensManaged()`][VoteEscrowTokenManager-_totalTokensManaged--]
- [`_initialize(address)`][CoreRef-_initialize-address-]
- [`setContractAdminRole(bytes32 newContractAdminRole)`][CoreRef-setContractAdminRole-bytes32-]
- [`isContractAdmin(address _admin)`][CoreRef-isContractAdmin-address-]
- [`pause()`][CoreRef-pause--]
- [`unpause()`][CoreRef-unpause--]
- [`core()`][CoreRef-core--]
- [`fei()`][CoreRef-fei--]
- [`tribe()`][CoreRef-tribe--]
- [`feiBalance()`][CoreRef-feiBalance--]
- [`tribeBalance()`][CoreRef-tribeBalance--]
- [`_burnFeiHeld()`][CoreRef-_burnFeiHeld--]
- [`_mintFei(address to, uint256 amount)`][CoreRef-_mintFei-address-uint256-]
- [`_setContractAdminRole(bytes32 newContractAdminRole)`][CoreRef-_setContractAdminRole-bytes32-]
- [`paused()`][Pausable-paused--]
- [`_pause()`][Pausable-_pause--]
- [`_unpause()`][Pausable-_unpause--]
- [`_msgSender()`][Context-_msgSender--]
- [`_msgData()`][Context-_msgData--]
- [`CONTRACT_ADMIN_ROLE()`][ICoreRef-CONTRACT_ADMIN_ROLE--]
- [`Lock(uint256 cummulativeTokensLocked, uint256 lockHorizon)`][VoteEscrowTokenManager-Lock-uint256-uint256-]
- [`Unlock(uint256 tokensUnlocked)`][VoteEscrowTokenManager-Unlock-uint256-]
- [`Paused(address account)`][Pausable-Paused-address-]
- [`Unpaused(address account)`][Pausable-Unpaused-address-]
- [`CoreUpdate(address oldCore, address newCore)`][ICoreRef-CoreUpdate-address-address-]
- [`ContractAdminRoleUpdate(bytes32 oldContractAdminRole, bytes32 newContractAdminRole)`][ICoreRef-ContractAdminRoleUpdate-bytes32-bytes32-]
### <span id="VoteEscrowTokenManager-constructor-contract-IERC20-contract-IVeToken-uint256-"></span> `constructor(contract IERC20 _liquidToken, contract IVeToken _veToken, uint256 _lockDuration)` (internal)



### <span id="VoteEscrowTokenManager-setLockDuration-uint256-"></span> `setLockDuration(uint256 newLockDuration)` (external)



### <span id="VoteEscrowTokenManager-lock--"></span> `lock()` (external)



### <span id="VoteEscrowTokenManager-exitLock--"></span> `exitLock()` (external)



### <span id="VoteEscrowTokenManager-_totalTokensManaged--"></span> `_totalTokensManaged() → uint256` (internal)



### <span id="VoteEscrowTokenManager-Lock-uint256-uint256-"></span> `Lock(uint256 cummulativeTokensLocked, uint256 lockHorizon)`



### <span id="VoteEscrowTokenManager-Unlock-uint256-"></span> `Unlock(uint256 tokensUnlocked)`


