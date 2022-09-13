// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.8.0;

// Store & retrieve value in a variable

contract Liquidity {
    address public ownerContract;
    
    constructor(){
        ownerContract = msg.sender;
    }
    
    mapping(address => uint256) public investers;
    
    function store(address invester)payable public {
        require(ownerContract == msg.sender, "MINDPAY: Not allowed");
        investers[invester] += msg.value;
    }
    
    
    function getContractEthers() view public returns(uint){
        return address(this).balance;
    }
}
