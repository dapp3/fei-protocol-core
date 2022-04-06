## <span id="PCVDripController"></span> `PCVDripController`



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
- [`duringTime()`][Timed-duringTime--]
- [`afterTime()`][Timed-afterTime--]
- [`constructor(address _core, contract IPCVDeposit _source, contract IPCVDeposit _target, uint256 _frequency, uint256 _dripAmount, uint256 _incentiveAmount)`][PCVDripController-constructor-address-contract-IPCVDeposit-contract-IPCVDeposit-uint256-uint256-uint256-]
- [`drip()`][PCVDripController-drip--]
- [`setSource(contract IPCVDeposit newSource)`][PCVDripController-setSource-contract-IPCVDeposit-]
- [`setTarget(contract IPCVDeposit newTarget)`][PCVDripController-setTarget-contract-IPCVDeposit-]
- [`setDripAmount(uint256 newDripAmount)`][PCVDripController-setDripAmount-uint256-]
- [`dripEligible()`][PCVDripController-dripEligible--]
- [`_mintFei(address to, uint256 amountIn)`][PCVDripController-_mintFei-address-uint256-]
- [`setIncentiveAmount(uint256 newIncentiveAmount)`][Incentivized-setIncentiveAmount-uint256-]
- [`_incentivize()`][Incentivized-_incentivize--]
- [`setRateLimitPerSecond(uint256 newRateLimitPerSecond)`][RateLimited-setRateLimitPerSecond-uint256-]
- [`setBufferCap(uint256 newBufferCap)`][RateLimited-setBufferCap-uint256-]
- [`buffer()`][RateLimited-buffer--]
- [`_depleteBuffer(uint256 amount)`][RateLimited-_depleteBuffer-uint256-]
- [`_setRateLimitPerSecond(uint256 newRateLimitPerSecond)`][RateLimited-_setRateLimitPerSecond-uint256-]
- [`_setBufferCap(uint256 newBufferCap)`][RateLimited-_setBufferCap-uint256-]
- [`_resetBuffer()`][RateLimited-_resetBuffer--]
- [`_updateBufferStored()`][RateLimited-_updateBufferStored--]
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
- [`_setContractAdminRole(bytes32 newContractAdminRole)`][CoreRef-_setContractAdminRole-bytes32-]
- [`paused()`][Pausable-paused--]
- [`_pause()`][Pausable-_pause--]
- [`_unpause()`][Pausable-_unpause--]
- [`_msgSender()`][Context-_msgSender--]
- [`_msgData()`][Context-_msgData--]
- [`CONTRACT_ADMIN_ROLE()`][ICoreRef-CONTRACT_ADMIN_ROLE--]
- [`isTimeEnded()`][Timed-isTimeEnded--]
- [`remainingTime()`][Timed-remainingTime--]
- [`timeSinceStart()`][Timed-timeSinceStart--]
- [`isTimeStarted()`][Timed-isTimeStarted--]
- [`_initTimed()`][Timed-_initTimed--]
- [`_setDuration(uint256 newDuration)`][Timed-_setDuration-uint256-]
- [`source()`][IPCVDripController-source--]
- [`target()`][IPCVDripController-target--]
- [`dripAmount()`][IPCVDripController-dripAmount--]
- [`IncentiveUpdate(uint256 oldIncentiveAmount, uint256 newIncentiveAmount)`][Incentivized-IncentiveUpdate-uint256-uint256-]
- [`BufferUsed(uint256 amountUsed, uint256 bufferRemaining)`][RateLimited-BufferUsed-uint256-uint256-]
- [`BufferCapUpdate(uint256 oldBufferCap, uint256 newBufferCap)`][RateLimited-BufferCapUpdate-uint256-uint256-]
- [`RateLimitPerSecondUpdate(uint256 oldRateLimitPerSecond, uint256 newRateLimitPerSecond)`][RateLimited-RateLimitPerSecondUpdate-uint256-uint256-]
- [`Paused(address account)`][Pausable-Paused-address-]
- [`Unpaused(address account)`][Pausable-Unpaused-address-]
- [`CoreUpdate(address oldCore, address newCore)`][ICoreRef-CoreUpdate-address-address-]
- [`ContractAdminRoleUpdate(bytes32 oldContractAdminRole, bytes32 newContractAdminRole)`][ICoreRef-ContractAdminRoleUpdate-bytes32-bytes32-]
- [`DurationUpdate(uint256 oldDuration, uint256 newDuration)`][Timed-DurationUpdate-uint256-uint256-]
- [`TimerReset(uint256 startTime)`][Timed-TimerReset-uint256-]
- [`SourceUpdate(address oldSource, address newSource)`][IPCVDripController-SourceUpdate-address-address-]
- [`TargetUpdate(address oldTarget, address newTarget)`][IPCVDripController-TargetUpdate-address-address-]
- [`DripAmountUpdate(uint256 oldDripAmount, uint256 newDripAmount)`][IPCVDripController-DripAmountUpdate-uint256-uint256-]
- [`Dripped(address source, address target, uint256 amount)`][IPCVDripController-Dripped-address-address-uint256-]
### <span id="PCVDripController-constructor-address-contract-IPCVDeposit-contract-IPCVDeposit-uint256-uint256-uint256-"></span> `constructor(address _core, contract IPCVDeposit _source, contract IPCVDeposit _target, uint256 _frequency, uint256 _dripAmount, uint256 _incentiveAmount)` (public)



### <span id="PCVDripController-drip--"></span> `drip()` (external)



### <span id="PCVDripController-setSource-contract-IPCVDeposit-"></span> `setSource(contract IPCVDeposit newSource)` (external)



### <span id="PCVDripController-setTarget-contract-IPCVDeposit-"></span> `setTarget(contract IPCVDeposit newTarget)` (external)



### <span id="PCVDripController-setDripAmount-uint256-"></span> `setDripAmount(uint256 newDripAmount)` (external)



### <span id="PCVDripController-dripEligible--"></span> `dripEligible() → bool` (public)



### <span id="PCVDripController-_mintFei-address-uint256-"></span> `_mintFei(address to, uint256 amountIn)` (internal)


