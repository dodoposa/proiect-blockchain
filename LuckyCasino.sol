pragma solidity ^0.6.0;

import './casino.sol';
import './Ownable.sol';
import './SafeMath.sol';

contract LuckyCasino is Casino, Ownable{
    using SafeMath for uint256;
    uint private _chipsPerWei = 5;

    function setChipsPerWei (uint _newChipsPerWei) external onlyOwner {
        require(_newChipsPerWei > 1);
        _chipsPerWei = _newChipsPerWei;
    }

    function getChipsPerWei () external view returns(uint){
        return _chipsPerWei;
    }
    function buyChips() external payable {
        require (msg.value > 0);
        transfer(msg.sender, SafeMath.mul(msg.value, _chipsPerWei));
    }

    function sellChips(uint chipAmount) external {
        require(balanceOf(msg.sender) >= chipAmount);
        uint _weiAmount = chipAmount * _chipsPerWei;
        require(address(this).balance >= _weiAmount);
        msg.sender.transfer(_weiAmount);
    }

    function withdraw() external onlyOwner {
        address _owner = owner();
        _owner.transfer(address(this).balance);
    }
}