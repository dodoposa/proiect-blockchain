pragma solidity ^0.6.0;
import './erc20.sol';
import './SafeMath.sol';
import './Ownable.sol';

contract LuckyCasino is ERC20, Ownable{

    using SafeMath for uint256;

    string private _symbol = "LCC";
    uint8 private _decimals = 4;
    uint256 public _totalSupply;
    string private _tokenName = "Lucky_Casino_Chips";
    uint private secret;
    /* This creates an array with all balances */
    mapping (address => uint256) public _balanceOf;
	
    mapping (address => mapping (address => uint256)) public _allowance;


    constructor (uint256 _total) public Ownable(){
        require(_total > 0);
        _totalSupply=_total;
        _balanceOf[msg.sender] = _totalSupply;
        secret=0;
    }


    function totalSupply() external view override returns (uint256){
        
        return _totalSupply;
        
    }

    function balanceOf(address account) external view override returns (uint256){
           
        return _balanceOf[account];
     
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        secret++;
        require (_to != address(0x0));  
        require (_from != address(0x0)); 
        require (_value >= 0); 
        require (_balanceOf[_from] >= _value);           // Check if the sender has enough
        require (_balanceOf[_to] + _value >= _balanceOf[_to]); // Check for overflows
       _balanceOf[_from] = SafeMath.sub(_balanceOf[_from], _value);                     // Subtract from the sender
        _balanceOf[_to] = SafeMath.add(_balanceOf[_to], _value);                            // Add the same to the recipient
        emit Transfer(_from, _to, _value);                
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) external override returns(bool success){
        secret++;
        _transfer(msg.sender, _to, _value);
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
            secret++;
		require (_value > 0); 
        _allowance[msg.sender][_spender] = _value;
        return true;
    }
       

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) external override returns (bool success) {
        secret++;
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

    uint private _chipsPerWei = 5;

    function setChipsPerWei (uint _newChipsPerWei) external onlyOwner {
        secret++;
        require(_newChipsPerWei > 1);
        _chipsPerWei = _newChipsPerWei;
    }

    function getChipsPerWei () external view returns(uint){
        
        return _chipsPerWei;
    }
    function buyChips() external payable {
        secret++;
        require (msg.value > 0 wei);
        address _owner = owner();
        _transfer(_owner, msg.sender, SafeMath.mul(msg.value, _chipsPerWei));
    }

    function sellChips(uint _chipAmount) external {
        secret++;
        require(_balanceOf[msg.sender] >= _chipAmount);
        uint _weiAmount = SafeMath.div(_chipAmount, _chipsPerWei);
        uint value = address(this).balance;
        require(address(this).balance >= _weiAmount);
        _transfer(msg.sender, _owner, SafeMath.mul(_weiAmount, _chipsPerWei));
        msg.sender.transfer(_weiAmount);
    }

    function withdraw() external onlyOwner {
        secret++;
        address payable _owner = payable(_owner);
        _owner.transfer(address(this).balance);

    }
	
    function generaterandom(uint mod) internal returns(uint){
        secret++;
        return uint(keccak256(abi.encodePacked(now, 
                                          msg.sender, 
                                          secret,
                                          block.difficulty))) % 
                                          mod;
    }
// <498 Heads win
// 498, 499, 500, 501, 502 lands on the side
// >502 tails win
    function playCoinflip(string memory choice, uint betAmount) internal returns(uint){

        uint result = generaterandom(1001);
        if(result < 498){
            if(keccak256(abi.encodePacked((choice))) == keccak256(abi.encodePacked(("heads")))){
                //win 2X
                betAmount = SafeMath.mul(betAmount,2);
                return betAmount;
            }
        }
        if(result >= 498 && result <=502){
            if(keccak256(abi.encodePacked((choice))) == keccak256(abi.encodePacked(("side")))){
                //win 99X
                betAmount = SafeMath.mul(betAmount,99);
                return betAmount;
            }
        }
        if(result >502){
            if(keccak256(abi.encodePacked((choice))) == keccak256(abi.encodePacked(("tails")))){
                //win 2X
                betAmount = SafeMath.mul(betAmount,2);
                return betAmount;
            }
        }

        return 0;
    }
    
    function playCoinflipWrapper(string calldata choice, uint betAmount) external returns(uint){
        require(_balanceOf[msg.sender] > betAmount);
        // _balanceOf[msg.sender] = SafeMath.sub(_balanceOf[msg.sender],betAmount);
        // _totalSupply = SafeMath.add(_totalSupply, betAmount);
        _transfer(msg.sender,address(owner()),betAmount);
        uint outcome = playCoinflip(choice, betAmount);
        _transfer(address(owner()),msg.sender,outcome);
    }
    
    function playSlots() external returns(uint, string memory){
        uint betAmount = 2;
        require(_balanceOf[msg.sender] > betAmount);
        _transfer(msg.sender,address(owner()),betAmount);
        uint _win;
        string memory _spinResult;
        uint first = generaterandom(6) + 1;
        uint second = generaterandom(6) + 1;
        uint third = generaterandom(6) + 1;
        (_win, _spinResult) = _spin(first, second, third);
        _transfer(address(owner()),msg.sender,_win);
        return (_win, _spinResult);
    }
    
    function _getSymbols(uint wheel) internal pure returns ( string memory){
        require( wheel >= 1);
        require(wheel <= 6);
        string memory firstSymbol = '';
        if (wheel == 1) {
            firstSymbol = 'CHERRY';
        }
        else if (wheel == 2) {
            firstSymbol = 'LEMON';
        }
        else if (wheel == 3) {
            firstSymbol = 'ORANGE';
        }
        else if (wheel == 4) {
            firstSymbol = 'PLUM';
        }
        else if (wheel == 5) {
            firstSymbol = 'BELL';
        }
        else if (wheel == 6) {
            firstSymbol = 'BAR';
        }
        return firstSymbol;
        
    }
    
    function _spin(uint firstWheel, uint secondWheel, uint thirdWheel) internal pure returns (uint, string memory){
        uint _win = 0;
    
        if(firstWheel == 1 && secondWheel == 1 && (thirdWheel == 3 || thirdWheel == 6))
            _win = 7;
        else if(firstWheel == 1 && secondWheel == 1)
            _win = 5;
        else if(firstWheel == 1)
            _win = 2;
        else if(firstWheel == 2 && secondWheel == 2 && (thirdWheel == 2 || thirdWheel == 6))
            _win = 8;
        else if(firstWheel == 3 && secondWheel == 3 && (thirdWheel == 3 || thirdWheel == 6))
            _win = 10;
        else if(firstWheel == 4 && secondWheel == 4 && (thirdWheel == 4 || thirdWheel == 6))
            _win = 14;
        else if(firstWheel == 5 && secondWheel == 5 && (thirdWheel == 5 || thirdWheel == 6))
            _win = 20;
        else if(firstWheel == 6 && secondWheel == 6 && thirdWheel == 6)
            _win = 250;
        
        string memory firstSymbol = _getSymbols(firstWheel);
        string memory secondSymbol = _getSymbols(secondWheel);
        string memory thirdSymbol = _getSymbols(thirdWheel);
        string memory _spinResult = string(abi.encodePacked(firstSymbol, ' ', secondSymbol, ' ', thirdSymbol));
        return (_win, _spinResult);
        
    }
}