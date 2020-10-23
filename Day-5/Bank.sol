pragma solidity >=0.5.13 <0.7.3;

contract Bank{
    address public bnk;
    
    mapping (address => uint) public addressOfEOA;

    
    constructor() public{
        bnk = msg.sender;
    }
    
   
    
     function DepositMoney() public payable{
        addressOfEOA[msg.sender] = msg.value;
    }
    
    function WithdrawMoney(address payable _to) public{
        _to.transfer(addressOfEOA[_to]);
    } 
}
