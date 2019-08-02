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

    mapping (uint=>Order[]) book;
    mapping (address=>userOrders[]) openOrders;
    uint levels;

    constructor(uint _levels) public {
        levels = _levels;
    }

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

}
