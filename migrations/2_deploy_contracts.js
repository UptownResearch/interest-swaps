var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var OrderBook = artifacts.require("./OrderBook.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(OrderBook, 5);
};
