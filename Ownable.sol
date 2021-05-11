pragma solidity ^0.6.0;

contract Ownable {
  address public _owner;

  constructor() public {
    _owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == _owner, 'caller must be the owner');
    _;
  }

  modifier notOwner() {
    require(msg.sender != _owner, 'caller must not be the owner');
    _;
  }

  function isOwner() public view returns(bool){
      return msg.sender == _owner;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0), 'new owner is the zero address');
    _owner = newOwner;
  }
  
  function owner() public view returns(address) {
    return _owner;
  }

}