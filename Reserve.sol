// SPDX-License-Identifier: GPL-3.0

pragma solidity <0.8.0;
import "./Liquidity.sol";

contract Reserve {

    struct investments{
        uint256 ethers;
        uint256 tokens;
        uint256 time;
    }
    address public ownerContract;
    uint256 number;
    Liquidity liquidityContract;
    
    mapping(address => investments) public reserves;
    
    constructor(){
        ownerContract = msg.sender;
    }
    /**
     * @dev Store value in variable
     * @param tok value to store
     */
    function store(address invester, uint256 tok) payable public {
        require(ownerContract == msg.sender, "MINDPAY : Not allowed");
        reserves[invester].ethers += msg.value;
        reserves[invester].tokens += tok;
        reserves[invester].time = block.timestamp;
    }

    /**
     * @dev Return value 
     * @return value of reserve ethers for user
     */
    function retrieveEthers(address invester) public view returns (uint256){
        return reserves[invester].ethers;
    }
    
    
    /**
     * @dev Return value 
     * @return value of reserve tokens for user
     */
    function retrieveTokens(address invester) public view returns (uint256){
        return reserves[invester].tokens;
    }
    
    
    /**
     * @dev Return value 
     * @return value of reserve time for user
     */
    function retrieveTime(address invester) public view returns (uint256){
        return reserves[invester].time;
    }
    
    /**
     * @dev Resets all reserve values
     * @param invester sends back reserve to 'invester'
     */
    function cancel(address payable invester) public{
        require(ownerContract == msg.sender, "MINDPAY : Not allowed");
        uint256 investment = reserves[invester].ethers;
        require(investment > 0, "MINDPAY reserve : Zero error!");
        reserves[invester].ethers = 0;
        reserves[invester].tokens = 0;
        reserves[invester].time = 0;
        invester.transfer(investment);
    }
    
    /**
     * @dev Return investment and tokens from reserve 
     * @param _invester Reset reserve for
     * @param _liquidityContract contract to which reserve contract will transfer fund to
     */
    function stake(address _invester, Liquidity  _liquidityContract) public payable returns (uint256 investment,uint256 tokens){
        require(ownerContract == msg.sender, "MINDPAY : Not allowed");
        investment = reserves[_invester].ethers;
        tokens = reserves[_invester].tokens;
        require(investment > 0, "MINDPAY reseve : Zero error!");
        reserves[_invester].ethers = 0;
        reserves[_invester].tokens = 0;
        reserves[_invester].time = 0;
        _liquidityContract.store{value:investment}(_invester);
    }
    
    /**
     * @dev function to transfer ethers from this contract
     * @param receiver Address of receiver who will receive ethers
     */
     function transferEthers(address payable receiver, uint256 amount) private{
         receiver.transfer(amount);
     }
    
    /**
     * @dev Returns balance from contract
     */
    function getContractEthers() view public returns(uint){
        return address(this).balance;
    }

    function getMessageSender() view public returns(address){
        return msg.sender;
    }
}
