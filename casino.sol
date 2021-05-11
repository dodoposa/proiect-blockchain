pragma solidity ^0.6.0;
import './Ownable.sol';
import './erc20.sol';
import './SafeMath.sol';

contract Casino is ERC20{

    using SafeMath for uint256;

    string public symbol = "LCC";
    uint8 public decimals = 4;
    uint256 public totalSupply;
	address public owner;
    string public tokenName = "Lucky_Casino_Chips";

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
	
    mapping (address => mapping (address => uint256)) public allowance;


    constructor (uint256 memory _total) public{
        require(_total > 0);
        totalSupply=_total;
        owner=msg.sender;
        balanceOf[msg.sender] = totalSupply;
    }


    function totalSupply() external view returns (uint256){
        return totalSupply;
    }

    function balanceOf(address account) external view returns (uint256){
        return balanceOf(account);
    }


    /* Send coins */
    function transfer(address _to, uint256 _value) external returns(bool success){
        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
		require (_value > 0); 
        require (balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
        return true;
    }

    function allowance(address _owner, address _spender) public view returns(uint){
        require(_owner!= 0x0);
        require(_spender!= 0x0);
        return allowance[_owner][_spender];
    }

    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value) external
        returns (bool success) {
		require (_value > 0); 
        allowance[msg.sender][_spender] = _value;
        return true;
    }
       

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
		require(_value > 0); 
        require(balanceOf[_from] >= _value);                 // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
       emit Transfer(_from, _to, _value);
        return true;
    }
	

}