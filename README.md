# College Project 
This is a Team Project made for the Blockchain course at UBB, Romania.

## Gambling App: LuckyCasino

This is a Solidity Project with a focus on gambling applications using Blockchain.

| Gambling Type | Idea                                                         |
| ------------- | ------------------------------------------------------------ |
| Slot Machine  |                                                              |
| Coin Flip     |                                                              |
| Roulette      |                                                              |
| Lottery       | Manager of the lottery and different players that gamble on a lottery pool |

- ### Slot Machine

  

- ### Coin Flip

  

- ### Roulette

  

- ### Lottery

  ​	Creating a lottery contract, you become the manager and only you can pick a winner. Players can participate but only if they send at least 1Ether to the prize pool. The winner gets the entire prize pool.

  | Players                                                      | Manager                                                      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | <img src="https://github.com/dodoposa/proiect-blockchain/blob/main/Pictures/Lottery/Screenshot_69.png" alt="Screenshot_69" style="zoom:33%;" /> | <img src="https://github.com/dodoposa/proiect-blockchain/blob/main/Pictures/Lottery/Screenshot_72.png" alt="Screenshot_72" style="zoom:33%;" /> |

  

  

  ​	The winner is chosen randomly calling the random function keccak256 and take the modulo from the number of players.

  ![Screenshot_70](https://github.com/dodoposa/proiect-blockchain/blob/main/Pictures/Lottery/Screenshot_70.png)

  ​	The entire idea is that you can deploy a new lottery contract, people start playing and they get added to the players dynamic array, the managers chooses the winner and then we empty the player list for the next round.

  ![Screenshot_71](https://github.com/dodoposa/proiect-blockchain/blob/main/Pictures/Lottery/Screenshot_71.png)

  ​	

  
