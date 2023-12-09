# GO FOR BROKE BOT

Go For Broke Bot is a capstone project requiring the use of at least two new tecks, with a timeframe of three weeks for Ada Developers Academy. I chose to make an automated trading bot that performs an arbitrage trade by exchanges tokens in crypto. As a saferty measure to protect my personal funds, the bot will get a flash-loan from Aave, a liquidity protocol. Aave's flash-loans work within a 26 second timeframe, money is lent and it if its not paid back, fees included, witihn the 26 seconds any and all transactions reverse securing Aave's investment and in turn useful to secure my own. It will do this by importing Aave's smart contract into my own smart contract, and using Aave's executeOperation() & requestFlashLoan() functions. 

Requirements:
- two new techs 


# DESCRIPTION
- A description of the application
  - Under the "dex" branch: 
  Go For Broke Bot is an automated terminal application that performs a specific type of trade. This trading bot trades on a fake DEX that I wrote. This insures that the trade will not fail as long as there are usdc token funds in the Dex.sol contract. The FlashLoanArbitrage.sol file has the flash loan and arbitrage logic, the arbitrage logic calls functions within the Dex.sol contract. The smart contracts are deployed on the Goerli testnet. I can interact with these contracts with a JavaScript "controller". By way of this controller, I can automate my calls to the functions within these smart contracts.  
  This terminal app performs a flashloan and arbitrage on a (extremely simple) simulated dex.

  Before running this program you must populate the env file with your own private information, see the env example.
  to run this program, type in the terminal 
   `npx hardhat run scripts/controller.js --network goerli`
  please only run ONCE as the code will only run if there are funds in the dex.sol contract. I have funded it a good amount so should be able to run 5x at least.

- A list of dependencies
  - HardHat
  - Ethers.js
  - Node.js

- Instructions for setting up the app
  - Install Node.js
  - Install and create a Hardhat javascript project 
  - Install ethers.js through the Hardhat framework

