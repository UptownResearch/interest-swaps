const Exchange = artifacts.require("./Exchange.sol");
const truffleAssert = require('truffle-assertions');

contract("Exchange", accounts => {
  it("...should add an order.", async () => {
    const ExchangeInstance = await Exchange.deployed();

    // add Order of size 10
    orderSize = 10
    result  = await ExchangeInstance.addOrder.call(1, orderSize, { from: accounts[0] });
    await ExchangeInstance.addOrder(1, orderSize);
    //console.log(result);

    // Get stored value
    const returnedItems = await ExchangeInstance.getLevelLocation.call(
        Number(result['bookLevel']), Number(result['indexLocation'])
      );
    //console.log(returnedItems);
    const order = returnedItems;
    assert.equal(order['amount'], orderSize)
    assert.equal(order['floater'], accounts[0])

    //console.log(await ExchangeInstance.getLevel.call(1));
    //ExchangeInstance.getLevel.call(1).then( (result) => {console.log("Result", result.length)})
  });

  it("...should delete an order.", async () => {
    const ExchangeInstance = await Exchange.deployed();

    // add Order of size 10
    orderSize = 10
    await ExchangeInstance.addOrder(1, orderSize, { from: accounts[0] });
    //ExchangeInstance.getLevel.call(1).then( (result) => {console.log("Result", result.data.length)})

    // add Order of size 20
    orderSize = 20
    await ExchangeInstance.addOrder(1, orderSize, { from: accounts[0] });

    // add Order of size 20
    orderSize = 30
    await ExchangeInstance.addOrder(1, orderSize, { from: accounts[0] });

    //get list of orders
    const orders = await ExchangeInstance.getLevel.call(1);
    assert.equal(orders.data.length, 4);

    await ExchangeInstance.removeOrder(2);
    //const orderFromBook = await ExchangeInstance.getUserOrder.call(2);
    //console.log(orderFromBook);
    ExchangeInstance.getLevel.call(1).then( (result) => {console.log("Result", result.data)})
    //assert.equal(orderFromBook.amount, 0);
    //assert.equal(orderFromBook.floater, 0);
  });

});
