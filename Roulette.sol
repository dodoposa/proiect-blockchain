pragma solidity ^0.6.0;

contract Roulette {
    uint betAmount = 1000000000;
    uint necessaryBalance = 0;
    uint8[] payouts = [2,3,3,2,2,36];
    uint8[] numberRange = [1,2,2,1,1,36];
    mapping (address => uint256) winnings;
     /*
    BetTypes:
      0: color
      1: column
      2: dozen
      3: eighteen
      4: modulus
      5: number

    Depending on the BetType, number should be:
      color: 0 for black, 1 for red
      column: 0 for left, 1 for middle, 2 for right
      dozen: 0 for first, 1 for second, 2 for third
      eighteen: 0 for low, 1 for high
      modulus: 0 for even, 1 for odd
      number: number
  */
  struct Bet {
    address player;
    uint8 betType;
    uint8 number;
  }
  Bet[] public bets;

    function bet(uint8 number, uint8 betType) payable public {
    require(betType >= 0 && betType <= 5); 
    require(number >= 0 && number <= numberRange[betType]);
    uint payoutForThisBet = payouts[betType] * msg.value;
    uint provisionalBalance = necessaryBalance + payoutForThisBet;
    require(provisionalBalance < address(this).balance);
    necessaryBalance += payoutForThisBet;
    bets.push(Bet({
      betType: betType,
      player: msg.sender,
      number: number
    }));
  }

  function spinWheel() public returns(uint){
    require(bets.length > 0);
    uint number = uint(keccak256(abi.encodePacked(now, msg.sender)))  % 37;
    for (uint i = 0; i < bets.length; i++) {
      bool won = false;
      Bet memory b = bets[i];
      if (number == 0) {
        won = (b.betType == 5 && b.number == 0);                   /* bet on 0 */
      } else {
        if (b.betType == 5) {
          won = (b.number == number);                              /* bet on number */
        } else if (b.betType == 4) {
          if (b.number == 0) won = (number % 2 == 0);              /* bet on even */
          if (b.number == 1) won = (number % 2 == 1);              /* bet on odd */
        } else if (b.betType == 3) {
          if (b.number == 0) won = (number <= 18);                 /* bet on low 18s */
          if (b.number == 1) won = (number >= 19);                 /* bet on high 18s */
        } else if (b.betType == 2) {
          if (b.number == 0) won = (number <= 12);                 /* bet on 1st dozen */
          if (b.number == 1) won = (number > 12 && number <= 24);  /* bet on 2nd dozen */
          if (b.number == 2) won = (number > 24);                  /* bet on 3rd dozen */
        } else if (b.betType == 1) {
          if (b.number == 0) won = (number % 3 == 1);              /* bet on left column */
          if (b.number == 1) won = (number % 3 == 2);              /* bet on middle column */
          if (b.number == 2) won = (number % 3 == 0);              /* bet on right column */
        } else if (b.betType == 0) {
          if (b.number == 0) {                                     /* bet on black */
            if (number <= 10 || (number >= 20 && number <= 28)) {
              won = (number % 2 == 0);
            } else {
              won = (number % 2 == 1);
            }
          } else {                                                 /* bet on red */
            if (number <= 10 || (number >= 20 && number <= 28)) {
              won = (number % 2 == 1);
            } else {
              won = (number % 2 == 0);
            }
          }
        }
      }
      if (won) {
        winnings[b.player] += betAmount * payouts[b.betType];
      }
    }
    delete bets;
    necessaryBalance = 0;
    return number;
  }

    event Received(address, uint);
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    function getStatus() public view returns(uint, uint, uint, uint) {
    return (
      bets.length,             // number of bets
      bets.length * betAmount, // value of bets
      address(this).balance,   // roulette balance
      winnings[msg.sender]     // winnings of player
    );
  }

  function cashOut() public {
    address payable player = msg.sender;
    uint256 amount = winnings[player];
    require(amount > 0);
    require(amount <= address(this).balance);
    winnings[player] = 0;
    player.transfer(amount);
  }
}
