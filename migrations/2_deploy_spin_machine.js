const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const SpinMachineV1 = artifacts.require('SpinMachineV1');

module.exports = async function (deployer) {
  const instance = await deployProxy(SpinMachineV1, { deployer });
  console.log('SpinMachineV1 deployed at', instance.address);
};