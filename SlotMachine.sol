// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract SlotMachine {
    
    
    function _getSymbols(uint wheel) private pure returns ( string memory){
        require( wheel > 0 && wheel < 6);
        string memory firstSymbol = '';
        if (wheel == 0) {
            firstSymbol = 'CHERRY';
        }
        else if (wheel == 1) {
            firstSymbol = 'LEMON';
        }
        else if (wheel == 2) {
            firstSymbol = 'ORANGE';
        }
        else if (wheel == 3) {
            firstSymbol = 'PLUM';
        }
        else if (wheel == 4) {
            firstSymbol = 'BELL';
        }
        else if (wheel == 5) {
            firstSymbol = 'BAR';
        }
        return firstSymbol;
        
    }
    
    function spin() external view returns (uint, string memory){
        uint _win = 0;
        uint firstWheel = uint(keccak256(abi.encodePacked(now, msg.sender))) % 6;
        uint secondWheel = uint(keccak256(abi.encodePacked(now, msg.sender))) % 6;
        uint thirdWheel = uint(keccak256(abi.encodePacked(now, msg.sender))) % 6;
    
        if(firstWheel == 0 && secondWheel == 0 && (thirdWheel == 2 || thirdWheel == 5))
            _win = 7;
        else if(firstWheel == 0 && secondWheel == 0)
            _win = 5;
        else if(firstWheel == 0)
            _win = 2;
        else if(firstWheel == 1 && secondWheel == 1 && (thirdWheel == 1 || thirdWheel == 5))
            _win = 8;
        else if(firstWheel == 2 && secondWheel == 2 && (thirdWheel == 2 || thirdWheel == 5))
            _win = 10;
        else if(firstWheel == 3 && secondWheel == 3 && (thirdWheel == 3 || thirdWheel == 5))
            _win = 14;
        else if(firstWheel == 4 && secondWheel == 4 && (thirdWheel == 4 || thirdWheel == 5))
            _win = 20;
        else if(firstWheel == 5 && secondWheel == 5 && thirdWheel == 5)
            _win = 250;
        
        string memory firstSymbol = _getSymbols(firstWheel);
        string memory secondSymbol = _getSymbols(secondWheel);
        string memory thirdSymbol = _getSymbols(thirdWheel);
        string memory _spinResult = string(abi.encodePacked(firstSymbol, ' ', secondSymbol, ' ', thirdSymbol));
        return (_win, _spinResult);
        
    }
}