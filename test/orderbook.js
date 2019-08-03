const OrderBook = artifacts.require("./OrderBook.sol");
const truffleAssert = require('truffle-assertions');

contract("OrderBook", accounts => {
  it("...should add an order.", async () => {
    const OrderBookInstance = await OrderBook.deployed();

    // add Order of size 10
    orderSize = 10
    await OrderBookInstance.addOrder(1, orderSize, { from: accounts[0] });

    // Get stored value
    const returnedItems = await OrderBookInstance.getLevel.call(1);
    const order = returnedItems[0];
    assert.equal(order['amount'], orderSize)
    assert.equal(order['floater'], accounts[0])
    //assert.equal(storedData, 89, "The value 89 was not stored.");
  });

  it("...should delete an order.", async () => {
    const OrderBookInstance = await OrderBook.deployed();

    // add Order of size 10
    orderSize = 10
    await OrderBookInstance.addOrder(1, orderSize, { from: accounts[0] });

    // add Order of size 20
    orderSize = 20
    await OrderBookInstance.addOrder(1, orderSize, { from: accounts[0] });

    // add Order of size 20
    orderSize = 30
    await OrderBookInstance.addOrder(1, orderSize, { from: accounts[0] });

    //get list of orders
    const orders = await OrderBookInstance.getLevel.call(1);
    assert.equal(orders.length, 4);

    await OrderBookInstance.removeOrder(2);
    const orders2 = await OrderBookInstance.getLevel.call(1);
    assert.equal(orders2.length, 3);

  });

  it("...should not permit orders at level 0", async() => {
    const OrderBookInstance = await OrderBook.deployed();
    await truffleAssert.reverts(OrderBookInstance.addOrder(0, 10, { from: accounts[0] }));
  });

  it("...should match orders up to limit", async() => {
    const OrderBookInstance = await OrderBook.deployed();
    // OrderBook.take(uint amountDesired, uint levellimit) 
    await OrderBookInstance.take( { from: accounts[1] });
  })

});
