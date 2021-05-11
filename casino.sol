pragma solidity ^0.6.0;
import './erc20.sol';
import './SafeMath.sol';

contract Casino is ERC20{

    using SafeMath for uint256;

    string public symbol = "LCC";
    uint8 public decimals = 4;
    uint256 public _totalSupply;
	address public owner;
    string public tokenName = "Lucky_Casino_Chips";

    /* This creates an array with all balances */
    mapping (address => uint256) public _balanceOf;
	
    mapping (address => mapping (address => uint256)) public _allowance;


    constructor (uint256 _total) public{
        require(_total > 0);
        _totalSupply=_total;
        owner=msg.sender;
        _balanceOf[msg.sender] = _totalSupply;
    }


    function totalSupply() external view override returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256){
        return _balanceOf[account];
    }


    /* Send coins */
    function transfer(address _to, uint256 _value) external override returns(bool success){
        require (_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
		require (_value > 0); 
        require (_balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        require (_balanceOf[_to] + _value >= _balanceOf[_to]); // Check for overflows
       _balanceOf[msg.sender] = SafeMath.sub(_balanceOf[msg.sender], _value);                     // Subtract from the sender
        _balanceOf[_to] = SafeMath.add(_balanceOf[_to], _value);                            // Add the same to the recipient
        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
        return true;
    }

    function allowance(address _owner, address _spender) public view override returns(uint){
        require(_owner!= address(0x0));
        require(_spender!= address(0x0));
        return _allowance[_owner][_spender];
    }

    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value) external override
        returns (bool success) {
		require (_value > 0); 
        _allowance[msg.sender][_spender] = _value;
        return true;
    }
       

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) external override returns (bool success) {
        require(_to != address(0x0));                                // Prevent transfer to 0x0 address. Use burn() instead
		require(_value > 0); 
        require(_balanceOf[_from] >= _value);                 // Check if the sender has enough
        require(_balanceOf[_to] + _value >= _balanceOf[_to]);  // Check for overflows
        require(_value <= _allowance[_from][msg.sender]);     // Check allowance
        _balanceOf[_from] = SafeMath.sub(_balanceOf[_from], _value);                           // Subtract from the sender
        _balanceOf[_to] = SafeMath.add(_balanceOf[_to], _value);                             // Add the same to the recipient
        _allowance[_from][msg.sender] = SafeMath.sub(_allowance[_from][msg.sender], _value);
       emit Transfer(_from, _to, _value);
        return true;
    }
	

}