pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

contract Exchange {

  //structure definitiions

  struct Order {
      uint amount;
      address floater;
  }

  struct userOrders {
      uint bookLevel;
      uint indexLocation;
  }

  struct filledOrder {
      address floater;
      address fixer;
      uint amount;
  }

  // Queue inspired by: https://github.com/chriseth/solidity-examples/blob/master/queue.sol
  struct OrderQueue {
    Order[] data;
    uint front;
    uint back;
  }

  // Contact variables

  mapping (uint=>OrderQueue) book;
  mapping (address=>userOrders[]) openOrders;
  mapping (uint=>uint) levelLength;
  uint levels;
  filledOrder[]  filledOrders;

  constructor(uint _levels) public {
      levels = _levels;
  }

  //Queue functions

  /// the number of elements stored in the queue.
  function length(OrderQueue storage q) view internal returns (uint) {
    return q.back - q.front;
  }

  /// the number of elements this queue can hold
  function capacity(OrderQueue storage q) view internal returns (uint) {
      return q.data.length - 1;
  }

  /// push a new element to the back of the queue
  function push(OrderQueue storage q, Order memory data) internal returns (uint location)
  {
      //if ((q.back + 1) % q.data.length == q.front)
      //    return; // throw;
      //q.data[q.back] = data;
      //q.back = (q.back + 1) % q.data.length;
      q.data.length++;
      q.data[q.back] = data;
      location = q.back;
      q.back++;

  }

  /// @dev remove and return the element at the front of the queue
  function pop(OrderQueue storage q) internal returns (Order storage r)
  {
      //if (q.back == q.front)
      //    return; // throw;
      //r = q.data[q.front];
      //delete q.data[q.front];
      //q.front = (q.front + 1) % q.data.length;
      r = q.data[q.front];
      delete q.data[q.front];
      q.front++;
  }

  function pop2(OrderQueue storage q) internal returns (Order memory r)
  {
      r = q.data[q.front];
      delete q.data[q.front];
      q.front++;
  }

  function Peek(OrderQueue storage q) internal view returns (Order memory r)
  {
    r = q.data[q.front];
  }

  function PeekLocation(OrderQueue storage q, uint location) internal view returns (Order memory r)
  {
    //require(location >= q.front && location <= q.back);
    r = q.data[location];
  }

  ////////////////////////////////////////
  // retrieve from book

  function getLevel(uint level) public view returns (OrderQueue memory){
      require(level < levels && level > 0);
      return book[level];
  }

  function getLevelLocation(uint level, uint location) public view returns (Order memory){
      require(level <= levels && level > 0);
      //require(location >= book[level].front && location <= book[level].back);
      return PeekLocation(book[level], location);
  }

  function getLevelLength(uint level) public view returns (uint){
      require(level < levels && level > 0);
      return levelLength[level];
  }

  function getUserOrder(uint index) public view returns (Order memory r){
      require(openOrders[msg.sender].length > index);
      userOrders memory orderToGet = openOrders[msg.sender][index];
      r = book[orderToGet.bookLevel].data[orderToGet.indexLocation];
  }


  ////////////////////////////////////////
  // add and remove orders

  function addOrder(uint addLevel, uint addAmount) public returns (userOrders memory r) {
      require(addLevel < levels && addLevel > 0);
      Order memory newOrder = Order(addAmount, msg.sender);
      //if (!book[addLevel].valid) {
        //Order[] storage newq = new Order[];
        //Order[] storage temp = Order[]();
        //book[addLevel] = OrderQueue(temp, 0, 0, true);
      //}
      uint location = push(book[addLevel], newOrder);
      userOrders memory pointer =  userOrders(addLevel, location);
      openOrders[msg.sender].push(pointer);
      levelLength[addLevel]++;
      r = pointer;
  }


  function removeOrder(uint index) public {
      require(openOrders[msg.sender].length > index);
      userOrders memory orderToRemove = openOrders[msg.sender][index];
      //remove order from orderbook level
      delete book[orderToRemove.bookLevel].data[orderToRemove.indexLocation];
      //remove order from open orders
      delete openOrders[msg.sender][index];
      levelLength[orderToRemove.bookLevel]--;
  }


  ////// test functions





}
