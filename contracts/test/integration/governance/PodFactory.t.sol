// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {IGnosisSafe} from "../../../pods/orcaInterfaces/IGnosisSafe.sol";
import {PodFactory} from "../../../pods/PodFactory.sol";
import {PodExecutor} from "../../../pods/PodExecutor.sol";
import {ITimelock} from "../../../dao/timelock/ITimelock.sol";
import {IControllerV1} from "../../../pods/orcaInterfaces/IControllerV1.sol";
import {IPodFactory} from "../../../pods/IPodFactory.sol";
import {Core} from "../../../core/Core.sol";
import {TribeRoles} from "../../../core/TribeRoles.sol";

import {DSTest} from "../../utils/DSTest.sol";
import {mintOrcaTokens, getPodParams} from "../fixtures/Orca.sol";
import {DummyStorage} from "../../utils/Fixtures.sol";
import {createGnosisTx} from "../fixtures/Gnosis.sol";
import {Vm} from "../../utils/Vm.sol";
import {MainnetAddresses} from "../fixtures/MainnetAddresses.sol";
import {OptimisticTimelock} from "../../../dao/timelock/OptimisticTimelock.sol";

/// @notice Validate PodFactory critical functionality such as creating pods
///  @dev PodAdmin can not also be a pod member
contract PodFactoryIntegrationTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);

    PodFactory factory;
    PodExecutor podExecutor;
    address private podAdmin = address(0x3);

    bytes32 public constant PROPOSER_ROLE = keccak256("PROPOSER_ROLE");
    bytes32 public constant EXECUTOR_ROLE = keccak256("EXECUTOR_ROLE");

    address core = MainnetAddresses.CORE;
    address memberToken = MainnetAddresses.MEMBER_TOKEN;
    address podController = MainnetAddresses.POD_CONTROLLER;
    address feiDAOTimelock = MainnetAddresses.FEI_DAO_TIMELOCK;

    function setUp() public {
        podExecutor = new PodExecutor();
        factory = new PodFactory(
            core,
            podController,
            memberToken,
            address(podExecutor)
        );
        mintOrcaTokens(address(factory), 2, vm);
    }

    /// @notice Validate that a non-authorised address fails to create a pod
    function testOnlyAuthedUsersCanCreatePod() public {
        (IPodFactory.PodConfig memory podConfig, ) = getPodParams(podAdmin);

        vm.expectRevert(bytes("UNAUTHORIZED"));
        address fraud = address(0x10);
        vm.prank(fraud);
        factory.createChildOptimisticPod(podConfig);
    }

    /// @notice Validate that a GOVERNOR role can create a pod
    function testGovernorCanCreatePod() public {
        (IPodFactory.PodConfig memory podConfig, ) = getPodParams(podAdmin);

        vm.prank(feiDAOTimelock);
        factory.createChildOptimisticPod(podConfig);
    }

    /// @notice Validate that the PodDeployerRole is able to deploy pods
    function testPodDeployerRoleCanDeploy() public {
        address dummyTribalCouncil = address(0x1);

        // Create ROLE_ADMIN, POD_DEPLOYER role and grant ROLE_ADMIN to a dummyTribalCouncil address
        vm.startPrank(feiDAOTimelock);
        Core(core).createRole(TribeRoles.ROLE_ADMIN, TribeRoles.GOVERNOR);
        Core(core).createRole(
            TribeRoles.POD_DEPLOYER_ROLE,
            TribeRoles.ROLE_ADMIN
        );
        Core(core).grantRole(TribeRoles.ROLE_ADMIN, dummyTribalCouncil);
        vm.stopPrank();

        // Grant POD_DEPLOYER_ROLE to a dummyPodDeployer
        address dummyPodDeployer = address(0x2);
        vm.prank(dummyTribalCouncil);
        Core(core).grantRole(TribeRoles.POD_DEPLOYER_ROLE, dummyPodDeployer);

        (IPodFactory.PodConfig memory podConfig, ) = getPodParams(podAdmin);
        vm.prank(dummyPodDeployer);
        factory.createChildOptimisticPod(podConfig);
    }

    function testGetNextPodId() public {
        uint256 nextPodId = factory.getNextPodId();
        assertGt(nextPodId, 10);
    }

    function testGnosisGetters() public {
        (IPodFactory.PodConfig memory podConfig, ) = getPodParams(podAdmin);

        vm.prank(feiDAOTimelock);
        (uint256 podId, address timelock, ) = factory.createChildOptimisticPod(
            podConfig
        );

        uint256 numMembers = factory.getNumMembers(podId);
        assertEq(numMembers, podConfig.members.length);

        uint256 storedThreshold = factory.getPodThreshold(podId);
        assertEq(storedThreshold, podConfig.threshold);

        address[] memory storedMembers = factory.getPodMembers(podId);
        assertEq(storedMembers[0], podConfig.members[0]);
        assertEq(storedMembers[1], podConfig.members[1]);
        assertEq(storedMembers[2], podConfig.members[2]);

        uint256 latestPodId = factory.latestPodId();
        assertEq(latestPodId, podId);
    }

    function testUpdatePodAdmin() public {
        (IPodFactory.PodConfig memory podConfig, ) = getPodParams(podAdmin);

        vm.prank(feiDAOTimelock);
        (uint256 podId, , ) = factory.createChildOptimisticPod(podConfig);

        address newAdmin = address(0x10);
        vm.prank(podAdmin);
        IControllerV1(podController).updatePodAdmin(podId, newAdmin);
        assertEq(IControllerV1(podController).podAdmin(podId), newAdmin);
        assertEq(factory.getPodAdmin(podId), newAdmin);
    }

    function testUpdatePodController() public {
        address newController = address(0x10);

        vm.prank(feiDAOTimelock);
        factory.updatePodController(newController);

        address updatedContoller = address(factory.podController());
        assertEq(updatedContoller, newController);
    }

    /// @notice Creates a child pod with an optimistic timelock attached
    function testDeployOptimisticGovernancePod() public {
        (IPodFactory.PodConfig memory podConfig, ) = getPodParams(podAdmin);

        vm.prank(feiDAOTimelock);
        (uint256 podId, address timelock, address safe) = factory
            .createChildOptimisticPod(podConfig);
        require(timelock != address(0));

        address safeAddress = factory.getPodSafe(podId);
        assertEq(safe, safeAddress);
        ITimelock timelockContract = ITimelock(timelock);

        // Gnosis safe should be the proposer
        bool hasProposerRole = timelockContract.hasRole(PROPOSER_ROLE, safe);
        assertTrue(hasProposerRole);

        bool safeAddressIsExecutor = timelockContract.hasRole(
            EXECUTOR_ROLE,
            safe
        );
        assertTrue(safeAddressIsExecutor);

        bool publicPodExecutorIsExecutor = timelockContract.hasRole(
            EXECUTOR_ROLE,
            address(podExecutor)
        );
        assertTrue(publicPodExecutorIsExecutor);
    }

    /// @notice Validate that the podId to timelock mapping is correct
    function testTimelockStorageOnDeploy() public {
        (IPodFactory.PodConfig memory podConfig, ) = getPodParams(podAdmin);

        vm.prank(feiDAOTimelock);
        (uint256 podId, address timelock, address safe) = factory
            .createChildOptimisticPod(podConfig);

        assertEq(timelock, factory.getPodTimelock(podId));
        assertEq(safe, factory.getPodSafe(podId));
        assertEq(podId, factory.getPodId(timelock));
    }

    /// @notice Validate that multiple pods can be deployed with the correct admin set
    function testDeployMultiplePods() public {
        (IPodFactory.PodConfig memory podConfig, ) = getPodParams(podAdmin);

        podConfig.label = bytes32("A");

        vm.prank(feiDAOTimelock);
        (uint256 podAId, , ) = factory.createChildOptimisticPod(podConfig);

        address podAAdmin = IControllerV1(podController).podAdmin(podAId);
        assertEq(podAAdmin, podAdmin);

        podConfig.label = bytes32("B");
        vm.prank(feiDAOTimelock);
        (uint256 podBId, , ) = factory.createChildOptimisticPod(podConfig);

        assertEq(podBId, podAId + 1);
        address podBAdmin = IControllerV1(podController).podAdmin(podBId);
        assertEq(podBAdmin, podAdmin);
    }

    function testBurnerPodDeploy() public {
        (IPodFactory.PodConfig memory podConfigA, ) = getPodParams(podAdmin);
        podConfigA.label = bytes32("A");

        (IPodFactory.PodConfig memory podConfigB, ) = getPodParams(podAdmin);
        podConfigB.label = bytes32("B");

        IPodFactory.PodConfig[] memory configs = new IPodFactory.PodConfig[](2);
        configs[0] = podConfigA;
        configs[1] = podConfigB;

        vm.prank(feiDAOTimelock);
        (uint256[] memory podIds, , ) = factory.burnerCreateChildOptimisticPods(
            configs
        );
        assertTrue(factory.burnerDeploymentUsed());

        vm.expectRevert(bytes("Burner deployment already used"));
        factory.burnerCreateChildOptimisticPods(configs);

        // Check pod admin
        address setPodAdminA = IControllerV1(podController).podAdmin(podIds[0]);
        assertEq(setPodAdminA, podAdmin);

        address setPodAdminB = IControllerV1(podController).podAdmin(podIds[0]);
        assertEq(setPodAdminB, podAdmin);
    }

    /// @notice Validate that can create a transaction in the pod and that it progresses to the timelock
    function testCreateTxInOptimisticPod() public {
        vm.warp(1);
        vm.roll(1);

        // 1. Deploy Dummy contract to perform a transaction on
        DummyStorage dummyContract = new DummyStorage();
        assertEq(dummyContract.getVariable(), 5);

        // 2. Deploy pod
        (IPodFactory.PodConfig memory podConfig, ) = getPodParams(podAdmin);
        vm.prank(feiDAOTimelock);
        (, address podTimelock, address safe) = factory
            .createChildOptimisticPod(podConfig);

        OptimisticTimelock timelockContract = OptimisticTimelock(
            payable(podTimelock)
        );

        // 3. Schedle a transaction from the Pod's safe address to timelock. Transaction sets a variable on a dummy contract
        uint256 newDummyContractVar = 10;
        bytes memory timelockExecutionTxData = abi.encodePacked(
            bytes4(keccak256(bytes("setVariable(uint256)"))),
            newDummyContractVar
        );

        uint256 timelockDelay = 500;
        vm.prank(safe);
        timelockContract.schedule(
            address(dummyContract),
            0,
            timelockExecutionTxData,
            bytes32(0),
            bytes32("1"),
            timelockDelay
        );

        // 4. Validate that transaction is in timelock
        bytes32 txHash = timelockContract.hashOperation(
            address(dummyContract),
            0,
            timelockExecutionTxData,
            bytes32(0),
            bytes32("1")
        );
        assertTrue(timelockContract.isOperationPending(txHash));

        // 5. Fast forward to execution time in timelock
        vm.warp(timelockDelay + 10);
        vm.roll(timelockDelay + 10);

        // 6. Execute transaction and validate state is updated
        podExecutor.execute(
            podTimelock,
            address(dummyContract),
            0,
            timelockExecutionTxData,
            bytes32(0),
            bytes32("1")
        );

        assertTrue(timelockContract.isOperationDone(txHash));
        assertEq(dummyContract.getVariable(), newDummyContractVar);
    }
}