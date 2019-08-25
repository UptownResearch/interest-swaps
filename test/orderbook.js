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
    //await OrderBookInstance.take( { from: accounts[1] });
  });

  it("...should create an order queue of length 1", async() => {
    const OrderBookInstance = await OrderBook.deployed();
    await OrderBookInstance.pushOrder(1, 10);
    //console.log(await OrderBookInstance.viewFrontBack());
    //console.log(await OrderBookInstance.tryPeek());
    assert.equal(await OrderBookInstance.getLength(), 1);

  });

  it("...should permit removal from the queue", async() =>{
    const OrderBookInstance = await OrderBook.deployed();
    // REMEMBER OrderBookInstance already has STATE!
    await OrderBookInstance.pushOrder(1, 20);
    //First we call to see the result (without changing state!)
    //console.log(await OrderBookInstance.removeFirstOrder.call());
    //Next we call to change the state
    await OrderBookInstance.removeFirstOrder();
    assert.equal(await OrderBookInstance.getLength(), 1);
  });

  it("...should do a wierd", async() =>{
    const OrderBookInstance = await OrderBook.deployed();
    // REMEMBER OrderBookInstance already has STATE!
    await OrderBookInstance.pushOrder(1, 30);
    //First we call to see the result (without changing state!)
    //console.log(await OrderBookInstance.tryPeek());
    console.log(await OrderBookInstance.removeFirstOrder.call());
    //Next we call to change the state
    //console.log(await OrderBookInstance.tryPeek());
    await OrderBookInstance.removeFirstOrder();
    //console.log(await OrderBookInstance.takeALook());
    console.log(await OrderBookInstance.doAWeird.call());

    assert.equal(await OrderBookInstance.getLength(), 1);
  })



});
