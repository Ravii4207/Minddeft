pragma solidity <0.8.0;

import "./Reserve.sol"; 
import "./Liquidity.sol";
import"./Stake.sol";
import "./ERC20.sol";

contract MINDPAY{

    uint256 number;
    Reserve reserveContract;
    Liquidity liquidityContract;
    Stake stakeContract;
    ERC20 MINDPAY;
    address ownerAddress;
    
    constructor(string memory name, string memory symbol) {
        ownerAddress = msg.sender;
        reserveContract = new Reserve();
        liquidityContract = new Liquidity();
        stakeContract = new Stake();
        MINDPAY = new ERC20(name, symbol);
    }
    
    
    
     //Invest  value in variable
    
    function deposit() payable public{
        uint256 tokens = getTokensForEthers(msg.value);
        uint256 ethersTobeLocked = (msg.value * 90)/100;
        uint256 ethersTobeLiquidated = msg.value - ethersTobeLocked;
        reserveContract.store{value:ethersTobeLocked}(msg.sender, tokens);
        liquidityContract.store{value:ethersTobeLiquidated}(msg.sender);
    }

     //Calculates tokens for ethers
     //weis value to store
     
    function getTokensForEthers(uint256 weis) private pure returns (uint256) {
        uint256  weiInEthers = weis / 1000000000000000000;
        uint256 tokenAllowance = 1000;
        tokenAllowance = weiInEthers * tokenAllowance;
        if(weiInEthers > 1 && weiInEthers <= 5){
            tokenAllowance += (tokenAllowance * 10)/100;
        }else if( weiInEthers > 5){
            tokenAllowance += (tokenAllowance * 20)/100;
        }else{
            
        }
        return tokenAllowance;
    }
    

    
     //credits investment and burns tokens
     
    function cancelInvestment() public {
       
        reserveContract.cancel(msg.sender);
    }
    
    
      
      //Liquidates reserved investment and stakes reserved tokens
     
    function stakeInvestment() payable public returns (uint256 liquidityAmount, uint256 stakeTokens){
        

        (liquidityAmount, stakeTokens) = reserveContract.stake(msg.sender,liquidityContract);
        require(liquidityAmount > 0, "MINDPAY : Reserve amount zero");
        require(stakeTokens > 0, "MINDPAY : Token amount zero");
        
        MINDPAY.transfer(msg.sender,stakeTokens);
    }
    
    
    
    function retrieveReserverContract() public view returns (Reserve){
        require(msg.sender == ownerAddress);
        return reserveContract;
    }
    
    
    //return value of 'Liquidity'
    
    function retrieveLiquidityContract() public view returns (Liquidity){
        require(msg.sender == ownerAddress);
        return liquidityContract;
    }
    
    
      //Return value value of 'Stake'
    
    function retrieveStakeContract() public view returns (Stake){
        require(msg.sender == ownerAddress);
        return stakeContract;
    }
    
    
     // @return value of 'Pay token'
     
    function retrieveERC20Contract() public view returns (ERC20){
        require(msg.sender == ownerAddress);
        return MINDPAY;
    }
    
    // Returns balance from contract
    
    function getContractEthers() view public returns(uint){
        return address(this).balance;
    }
    
}
