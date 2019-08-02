const OrderBook = artifacts.require("./OrderBook.sol");

contract("OrderBook", accounts => {
  it("...should add an order.", async () => {
    const OrderBookInstance = await OrderBook.deployed(5);

    // Set value of 89
    await OrderBookInstance.addOrder(1, 10, { from: accounts[0] });

    // Get stored value
    const storedData = await OrderBookInstance.getLevel(1).call();

    console.log(storedData);
    //assert.equal(storedData, 89, "The value 89 was not stored.");
  });
});
