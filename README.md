# GO FOR BROKE BOT

This bot will perform arbitrage using aave's flashloan as a way to protect personal funds. 



# DESCRIPTION
- A description of the application
  - Under the "dex" branch: 
  Go For Broke Bot is an automated terminal application that performs a specific type of trade. This trading bot trades on a fake DEX that I wrote. This insures that the trade will not fail as long as there are usdc token funds in the Dex.sol contract. The FlashLoanArbitrage.sol file has the flash loan and arbitrage logic, the arbitrage logic calls functions within the Dex.sol contract. The smart contracts are deployed on the Goerli testnet. I can interact with these contracts with a JavaScript "controller". By way of this controller, I can automate my calls to the functions within these smart contracts.  
  This terminal app performs a flashloan and arbitrage on a (extremely simple) simulated dex. 

  to run this program type in the terminal 
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

