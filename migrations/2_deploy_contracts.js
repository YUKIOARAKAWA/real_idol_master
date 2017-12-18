const fs = require('fs');

const IdolContract = artifacts.require('IdolContract.sol');

module.exports = function deployCOntracts(deployer) {
  deployer.deploy(IdolContract);
}
