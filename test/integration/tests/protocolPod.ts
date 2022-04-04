import { PodFactory, PodAdminGateway } from '@custom-types/contracts';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import chai, { expect } from 'chai';
import CBN from 'chai-bn';
import { solidity } from 'ethereum-waffle';
import { ethers } from 'hardhat';
import { NamedAddresses, NamedContracts } from '@custom-types/types';
import { getImpersonatedSigner, resetFork } from '@test/helpers';
import proposals from '@test/integration/proposals_config';
import { TestEndtoEndCoordinator } from '../setup';
import { BigNumber } from 'ethers';
import { tribalCouncilMembers } from '@protocol/optimisticGovernance';
import { forceEth } from '@test/integration/setup/utils';

const toBN = ethers.BigNumber.from;

describe('Protocol pod', function () {
  let contracts: NamedContracts;
  let contractAddresses: NamedAddresses;
  let deployAddress: SignerWithAddress;
  let e2eCoord: TestEndtoEndCoordinator;
  let doLogging: boolean;
  let podFactory: PodFactory;
  let podId: BigNumber;
  let podAdminGateway: PodAdminGateway;
  let tribalCouncilTimelockSigner: SignerWithAddress;

  before(async () => {
    chai.use(CBN(ethers.BigNumber));
    chai.use(solidity);
    await resetFork();
  });

  before(async function () {
    // Setup test environment and get contracts
    const version = 1;
    deployAddress = (await ethers.getSigners())[0];
    if (!deployAddress) throw new Error(`No deploy address!`);

    doLogging = Boolean(process.env.LOGGING);

    const config = {
      logging: doLogging,
      deployAddress: deployAddress.address,
      version: version
    };
    e2eCoord = new TestEndtoEndCoordinator(config, proposals);

    doLogging && console.log(`Loading environment...`);
    ({ contracts, contractAddresses } = await e2eCoord.loadEnvironment());
    doLogging && console.log(`Environment loaded.`);
    podFactory = contracts.podFactory as PodFactory;
    podAdminGateway = contracts.podAdminGateway as PodAdminGateway;
    podId = await podFactory.getPodId(contractAddresses.protocolPodTimelock);

    await forceEth(contractAddresses.tribalCouncilTimelock);
    tribalCouncilTimelockSigner = await getImpersonatedSigner(contractAddresses.tribalCouncilTimelock);
  });

  it('should allow Tribal council to add members to protocol pod', async () => {
    const initialNumPodMembers = await podFactory.getNumMembers(podId);
    const newMember = '0x0000000000000000000000000000000000000030';
    await podAdminGateway.connect(tribalCouncilTimelockSigner).addPodMember(podId, newMember);

    const numPodMembers = await podFactory.getNumMembers(podId);
    await expect(numPodMembers).to.equal(initialNumPodMembers.add(toBN(1)));

    const podMembers = await podFactory.getPodMembers(podId);
    expect(podMembers[0]).to.equal(newMember);
  });

  it('should allow Tribal council to remove members from protocol pod', async () => {
    const initialNumPodMembers = await podFactory.getNumMembers(podId);

    const memberToBurn = tribalCouncilMembers[0];
    await podAdminGateway.connect(tribalCouncilTimelockSigner).removePodMember(podId, memberToBurn);

    const numPodMembers = await podFactory.getNumMembers(podId);
    await expect(numPodMembers).to.equal(initialNumPodMembers.sub(toBN(1)));

    const podMembers = await podFactory.getPodMembers(podId);
    expect(!podMembers.includes(memberToBurn)).to.be.true;
  });

  it('should allow a proposal to be proposed and executed in protocol access remit', async () => {
    // TODO: Perform on a testnet/mainnet likely
  });
});