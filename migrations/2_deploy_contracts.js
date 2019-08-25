var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var OrderBook = artifacts.require("./OrderBook.sol");
var Exchange = artifacts.require("./Exchange.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(OrderBook, 5);
  deployer.deploy(Exchange, 5);
};
