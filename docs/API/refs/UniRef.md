## <span id="UniRef"></span> `UniRef`

the uniswap pair should be FEI and another asset

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
- [`constructor(address _core, address _pair, address _oracle, address _backupOracle)`][UniRef-constructor-address-address-address-address-]
- [`setPair(address newPair)`][UniRef-setPair-address-]
- [`getReserves()`][UniRef-getReserves--]
- [`_setupPair(address newPair)`][UniRef-_setupPair-address-]
- [`_token()`][UniRef-_token--]
- [`setOracle(address newOracle)`][OracleRef-setOracle-address-]
- [`setDoInvert(bool newDoInvert)`][OracleRef-setDoInvert-bool-]
- [`setDecimalsNormalizer(int256 newDecimalsNormalizer)`][OracleRef-setDecimalsNormalizer-int256-]
- [`setBackupOracle(address newBackupOracle)`][OracleRef-setBackupOracle-address-]
- [`invert(struct Decimal.D256 price)`][OracleRef-invert-struct-Decimal-D256-]
- [`updateOracle()`][OracleRef-updateOracle--]
- [`readOracle()`][OracleRef-readOracle--]
- [`_setOracle(address newOracle)`][OracleRef-_setOracle-address-]
- [`_setBackupOracle(address newBackupOracle)`][OracleRef-_setBackupOracle-address-]
- [`_setDoInvert(bool newDoInvert)`][OracleRef-_setDoInvert-bool-]
- [`_setDecimalsNormalizer(int256 newDecimalsNormalizer)`][OracleRef-_setDecimalsNormalizer-int256-]
- [`_setDecimalsNormalizerFromToken(address token)`][OracleRef-_setDecimalsNormalizerFromToken-address-]
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
- [`oracle()`][IOracleRef-oracle--]
- [`backupOracle()`][IOracleRef-backupOracle--]
- [`doInvert()`][IOracleRef-doInvert--]
- [`decimalsNormalizer()`][IOracleRef-decimalsNormalizer--]
- [`pair()`][IUniRef-pair--]
- [`token()`][IUniRef-token--]
- [`Paused(address account)`][Pausable-Paused-address-]
- [`Unpaused(address account)`][Pausable-Unpaused-address-]
- [`CoreUpdate(address oldCore, address newCore)`][ICoreRef-CoreUpdate-address-address-]
- [`ContractAdminRoleUpdate(bytes32 oldContractAdminRole, bytes32 newContractAdminRole)`][ICoreRef-ContractAdminRoleUpdate-bytes32-bytes32-]
- [`OracleUpdate(address oldOracle, address newOracle)`][IOracleRef-OracleUpdate-address-address-]
- [`InvertUpdate(bool oldDoInvert, bool newDoInvert)`][IOracleRef-InvertUpdate-bool-bool-]
- [`DecimalsNormalizerUpdate(int256 oldDecimalsNormalizer, int256 newDecimalsNormalizer)`][IOracleRef-DecimalsNormalizerUpdate-int256-int256-]
- [`BackupOracleUpdate(address oldBackupOracle, address newBackupOracle)`][IOracleRef-BackupOracleUpdate-address-address-]
- [`PairUpdate(address oldPair, address newPair)`][IUniRef-PairUpdate-address-address-]
### <span id="UniRef-constructor-address-address-address-address-"></span> `constructor(address _core, address _pair, address _oracle, address _backupOracle)` (internal)



### <span id="UniRef-setPair-address-"></span> `setPair(address newPair)` (external)



### <span id="UniRef-getReserves--"></span> `getReserves() → uint256 feiReserves, uint256 tokenReserves` (public)



### <span id="UniRef-_setupPair-address-"></span> `_setupPair(address newPair)` (internal)



### <span id="UniRef-_token--"></span> `_token() → address` (internal)


