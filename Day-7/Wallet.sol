pragma solidity >=0.5.14 <0.7.4;

contract Wallet{
    string public financeteam = 'This belong to Finance Team';
    address payable owner= msg.sender;
    uint256 counter;
    mapping (string => uint256)public Grade_Ether_Withdrawal_Limit;
    struct EmpDetails{
        address payable empaddress;
        uint256 empcode;
        bool regflag;
        string empgrade;
        uint256 creditbalance;
    }
    
    EmpDetails[]EmployeeDetails;
    
    constructor()public {
        EmployeeDetails.push() = EmpDetails(owner,0,true,'FT',0);
        Grade_Ether_Withdrawal_Limit["1A"] = 30 ether;
        Grade_Ether_Withdrawal_Limit["1B"] = 30 ether;
        Grade_Ether_Withdrawal_Limit["1C"] = 30 ether;
        Grade_Ether_Withdrawal_Limit["2A"] = 20 ether;
        Grade_Ether_Withdrawal_Limit["2B"] = 20 ether;
        Grade_Ether_Withdrawal_Limit["2C"] = 20 ether;
        Grade_Ether_Withdrawal_Limit["3A"] = 10 ether;
        Grade_Ether_Withdrawal_Limit["3B"] = 10 ether;
        Grade_Ether_Withdrawal_Limit["3C"] = 10 ether;
        Grade_Ether_Withdrawal_Limit["4A"] = 5 ether;
        Grade_Ether_Withdrawal_Limit["4B"] = 5 ether;
        Grade_Ether_Withdrawal_Limit["4C"] = 5 ether;
        Grade_Ether_Withdrawal_Limit["5A"] = 2 ether;
        Grade_Ether_Withdrawal_Limit["5B"] = 2 ether;
        Grade_Ether_Withdrawal_Limit["5C"] = 2 ether;
    }
    
   
    
    // To register the Employee
    function RegisterEmployee(address payable _empaddress)public {
        require(checkaddr(_empaddress) == -1, 'You are already registered');
        counter = counter + 1;
        EmployeeDetails.push() = EmpDetails(_empaddress,counter,true,'',0);
    }
    
     //To check if the particular employee has already registered or not
    function checkaddr(address payable _addr)private view returns(int256){
       for (uint i = 0; i < EmployeeDetails.length; i++) {
           if (EmployeeDetails[i].empaddress == _addr) {
               return int256(i);}
           }
        return -1;
    }
    
     // To check if the sender of the message is indeed the owner or not
    modifier checkowner(){
        require(msg.sender == owner,"Only the owner has permission for this");
        _;
    }
    
    // To Assign/Change Grade for an Employee
    function AssignEmployeeGrade(address payable _empaddress, string memory  _grade)public payable checkowner{
        require(checkaddr(_empaddress) != -1,'This address is not yet registered, Kindly register first');
        EmployeeDetails[uint256(checkaddr(_empaddress))].empgrade = _grade;
    }
    
    //For the employee to see his details
    function GetDetails(address payable _empaddress)public view returns(string memory,address payable, uint256, string memory, uint256){
        require ((msg.sender == _empaddress) || (msg.sender == owner),"You are not authorised to view details of this address");
        uint256 index = uint256(checkaddr(_empaddress));
        return ('PFB your address, employee code, grade, credit utilised',EmployeeDetails[index].empaddress, EmployeeDetails[index].empcode, EmployeeDetails[index].empgrade,  EmployeeDetails[index].creditbalance);
    }
    
    // To change the Grade-Ether Limit
    function ChangeGradeEther(string memory _grade, uint _wei)public payable checkowner{
        Grade_Ether_Withdrawal_Limit[_grade] = _wei;
    }
    
    // To check if address belongs to Finance Team
    function checkFT(address payable _empaddress)private view returns(bool){
        bytes32 ft = keccak256(abi.encodePacked("FT"));
        uint256 index = uint256(checkaddr(_empaddress));
        bytes32 sender = keccak256(abi.encodePacked(EmployeeDetails[index].empgrade));
        if (ft == sender){
            return true;
        }
        return false;
    }
    
    // To Deposit Ether
    function Deposit_Ether() public payable {
    require(checkFT(msg.sender) == true,'Only FinanceTeam has permission for this');
    }
    
    
    // To withdraw Ether
    function Withdraw_Ether(uint256 wei_unit)public payable{
        uint256 index = uint256(checkaddr(msg.sender));
        require(int256(index) != -1,'This address is not yet registered, Kindly register first');
        require((keccak256(abi.encodePacked(EmployeeDetails[index].empgrade))) != (keccak256(abi.encodePacked(''))),'Kindly ask Owner to assign your Employee Grade first');
        uint256 checkwithdraw = EmployeeDetails[index].creditbalance + wei_unit;
        require(checkwithdraw <= address(this).balance,'Credit Card balance Limit exceeded, contact Fiannce Team');
        require((Grade_Ether_Withdrawal_Limit[EmployeeDetails[index].empgrade] >= checkwithdraw)||(checkFT(msg.sender) == true) ,'You will exceed limit for your grade with this transaction either lower the withdrawal or contact Finance Team');
        EmployeeDetails[index].creditbalance = checkwithdraw;
        msg.sender.transfer(wei_unit);
    }
        
    // To clear credit dues of an Employee
    function ClearDues(address payable _empaddress,uint256 wei_unit)public payable{
        require(checkFT(msg.sender) == true,'Only FinanceTeam has permission for this');
        uint256 index = uint256(checkaddr(_empaddress));
        int256 clearamt =  int256(EmployeeDetails[index].creditbalance - wei_unit);
        require(clearamt >= 0 ,'Please enter a lesser amount for clearance');
        EmployeeDetails[index].creditbalance = EmployeeDetails[index].creditbalance - wei_unit;
    }
    
    // To get CreditCard balance details
    function getCardBalance() public view returns(uint256){
        require(checkFT(msg.sender) == true,'Only FinanceTeam has permission for this');
        return(address(this).balance);
    }
    
    // Reset SmartSharedWallet
    function ResetCreditCard() public checkowner payable{
        delete EmployeeDetails;
    }
}
