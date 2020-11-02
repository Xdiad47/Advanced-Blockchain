pragma solidity >=0.5.13 < 0.7.3;

contract Lottery{
    
    address owner;
    bool public isPause;
    
    mapping(address => uint) public addressOfLotteryParticipation;
    address[] public addressOfParticipation;
    
    constructor() public{
        owner = msg.sender;
    }
    
    function receiveEthers() payable public{
        require (msg.value >= 1 ether, "You require minimum of 1 ether to participate");
        require(contains(msg.sender)==0, "You are already a part of the Lottery");
        addressOfLotteryParticipation[msg.sender] = msg.value;
        addressOfParticipation.push(msg.sender);
    }
    function randomNumberFunction() private onlyOwner returns(uint){
        uint randomNumber = uint(keccak256(abi.encodePacked(block.difficulty,
        block.timestamp, msg.sender,addressOfParticipation))) % addressOfParticipation.length;
        return(randomNumber);
    }
    
    function transferEtherToWinner() public onlyOwner{
        uint randomWinner = randomNumberFunction();
        address payable winner = payable(addressOfParticipation[randomWinner]);
        winner.transfer(address(this).balance);
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner, "owner only have the access");
        _;
        
    }
    function contains(address _addr) private returns(uint){
        return addressOfLotteryParticipation[_addr];
    }
    function setPause( bool _ispause) public onlyOwner{
        require(msg.sender == owner, "You Dont have access to this function");
        isPause = _ispause;
    }
     function terminateThisSmartContract() public{
        require(msg.sender == owner, "You Dont have access to this function");
        require(!isPause, "Contract is Paused");
        address payable to = msg.sender;
        selfdestruct(to);
    } 
    function resetBalance(uint256 value)public {
    for (uint i=0; i< addressOfParticipation.length ; i++){
        addressOfLotteryParticipation[addressOfParticipation[i]] = value;
    }
}
