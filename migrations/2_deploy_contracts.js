var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var SimpleStorage = artifacts.require("./OrderBook.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(OrderBook, 5);
};
