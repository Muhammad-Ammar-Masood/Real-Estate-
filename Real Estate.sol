// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract realEstate{

    event Sell(address seller, string location, uint sqFeet, uint price); 

    struct Land {
        address seller;
        string location;
        uint sqFeet;
        uint price;
        bool sold;
    }
 
    mapping(uint => Land) public lands;
    uint public landNo;

    struct Buyer {
        address buyer;
        Land landBrought;
        uint amountPaid;
    }

    mapping(uint => Buyer) public buyers;
    uint public buyerNo;

    function sellLand(string calldata location, uint sqFeet, uint price ) external {
        lands[landNo] = Land(msg.sender, location, sqFeet, price,false);
        ++landNo;
        emit Sell(msg.sender, location, sqFeet, price);
    }

    function buyLand(uint id) external payable {
        require(msg.sender != lands[id].seller, "Seller cannot buy his land");
        require(msg.value >= lands[id].price, "Not enough ethers");
        (bool success, ) = payable(lands[id].seller).call{value: msg.value}("");
        require(success, "Transfer failed");
        lands[id].sold = true;
        buyers[buyerNo] = Buyer(msg.sender, lands[id], msg.value);
        ++buyerNo;
    }

}
