pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

contract OrderBook {

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


    mapping (uint=>Order[]) book;
    mapping (address=>userOrders[]) openOrders;
    uint levels;
    filledOrder[]  filledOrders;
    OrderQueue _test;
    Order viewableOrder;
    Order weird;

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
    function push(OrderQueue storage q, Order memory data) internal
    {
        //if ((q.back + 1) % q.data.length == q.front)
        //    return; // throw;
        //q.data[q.back] = data;
        //q.back = (q.back + 1) % q.data.length;
        q.data.length++;
        q.data[q.back] = data;
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
        viewableOrder = q.data[q.front];
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



    ////////////////////////////////////////

    // External Users of Queue

    function pushOrder(uint addLevel, uint addAmount) public {
      Order memory newOrder = Order(addAmount, msg.sender);
      push(_test, newOrder);
    }


    function getLength() view public returns (uint) {
      return length(_test);
    }

    function removeFirstOrder() public returns (Order memory r){
      //r = pop(_test);
      //return (r.amount, r.floater);
      return pop2(_test);
    }

    function viewFrontBack() public view returns (uint, uint) {
      return (_test.back, _test.front);
    }

    function tryPeek() public view returns (Order memory r)
    {
      r = _test.data[_test.front];
    }

    function takeALook() public view returns (Order memory r)
    {
      r = viewableOrder;
    }

    function doAWeird() public returns (Order memory r)
    {
      weird = pop2(_test);
      r = weird;
    }

    ///////////////

    function addOrder(uint addLevel, uint addAmount) public {
        require(addLevel < levels && addLevel > 0);
        Order memory newOrder = Order(addAmount, msg.sender);
        book[addLevel].push(newOrder);
        userOrders memory pointer =  userOrders(addLevel, book[addLevel].length-1);
        openOrders[msg.sender].push(pointer);
    }

    function getLevel(uint level) public view returns (Order[] memory){
        require(level < levels && level > 0);
        return book[level];
    }

    function viewUserOrders() public view returns (userOrders[] memory){
        return openOrders[msg.sender];
    }

    function returnLevel(uint levelIndex) public view returns (Order[] memory){
        require(levelIndex < levels && levelIndex > 0);
        return book[levelIndex];
    }

    function removeOrder(uint index) public {
        require(openOrders[msg.sender].length > index);
        userOrders memory orderToRemove = openOrders[msg.sender][index];
        Order[] storage levelToUpdate = book[orderToRemove.bookLevel];

        if (levelToUpdate.length > 1){
            for (uint x=index; x < levelToUpdate.length-1; x++){
                levelToUpdate[x] = levelToUpdate[x+1];
            }
            delete levelToUpdate[levelToUpdate.length - 1];
            levelToUpdate.length--;
            book[orderToRemove.bookLevel] = levelToUpdate;
        } else {
            delete book[orderToRemove.bookLevel][0];
            book[orderToRemove.bookLevel].length--;
        }
        //remove order from list
        delete openOrders[msg.sender][index];
    }

    //useful for testing, must be removed later
    function forceRemoveOrder(uint level, uint index) public {
        Order[] storage levelToUpdate = book[level];
        if (levelToUpdate.length > 1){
            for (uint x=index; x < levelToUpdate.length-1; x++){
                levelToUpdate[x] = levelToUpdate[x+1];
            }
            delete levelToUpdate[levelToUpdate.length - 1];
            levelToUpdate.length--;
            book[level] = levelToUpdate;
        } else {
            delete book[level][0];
            book[level].length--;
        }
    }

    /*********
    function take(uint amountDesired, uint levellimit ) public {
      uint amountremaining = amountDesired;
      uint level = 1;
      while (amountremaining > 0 && level <= levellimit) {

        if (level > levels){
          break;
        }

        if (book[level].length == 0){
          level++;
          continue;
        }

        if (book[level][0].amount < amountremaining) {
          //fill entire order
          Order[] storage book_level = book[level];
          Order storage toFill = book_level.pop();

          filledOrder memory filled =  filledOrder(
            toFill.floater,
            msg.sender,
            toFill.amount
            );

          amountremaining -= toFill.amount;
          filledOrders.push(filled);

        } else {
          //fill part of order
          book[level][0].amount -= amountremaining;

          filledOrder memory filled = filledOrder(
            book[level][0].floater,
            msg.sender,
            amountremaining
            );
          amountremaining = 0;
          filledOrders.push(filled);
          break;
        }
      }
    }
    *****/


}
