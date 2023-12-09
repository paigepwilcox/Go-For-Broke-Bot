# GO FOR BROKE BOT

Go For Broke Bot served as my capstone project during my tenure at Ada Developers Academy, the project had an uncompromisng deadline of three weeks and required utilization of at least two new technologies. I opted to create an automated trading bot specialized in arbitrage trading--arbitrage is, the simultaneous buying and selling of securites, currency or commodities in different markets or in derivative forms in order to take adnatgae of differing prices for the same asset--handling tokens in the cryptocurrency market.

To safeguard my personal funds the bot will employ code--a pre-exisiting function from Aave's protocol--to obtain a flash-loan from Aave. Aave stands as a liquidity protocol that offers many applications, one of which is flash-loans. Flash-loans operate within a stringent 26-second timeframe--essentially, the time it takes for a single block to encrypt and append to the Ethereum blockchain. Should the loan, inclusive of fees, remain unpaid when the timeframe expires, all transactions undergo reversal. Securing Aave's investment and consequently protecting my own. These loaned funds serves as a safety measure as they facilitate the trading process.

The implementation of flash-loans involves inheritance of Aave's smart contract, FlashLoanSimpleReceiverBase, into my own, FlashLoanArbitrage smart contract and invoking Aave's executeOperation() and requestFlashLoan() functions. 

Due to time constraints, I did not finish unit testing for this code and felt uncomfortable connecting to a Ethereum's main network (blockchain) without such tests. As a workaround, I created a simplistic version of a "decentralized exchange" for demonstration purposes. I created an environment that had reserves of two tokens, allowing external smart contracts to invoke certain internal functions which execute transactions with this smart contract. By connecting to the test network blockchain called Goerli, I could test funcationality of my code using simulated funds and provide a tangible showcase for my professors and peers.

Presently, I am furhtering this project by developing comprehensive unit tests, exploring prevalent algorithms to optimize route selection, and delving into other areas of research.




Under the "dex" branch: Go For Broke Bot is a terminal application that performs a specific type of trade called Arbitrage, it aslo utilizes Flash Loans from Aave's V3 protocol. A flash loan is a loan that needs repayment in the same block that it was lent. The allure to this loan is that you do not need to put down collateral, and if the loan is not repayed within the same block, all transactions that happened after the loan was given will be reverted. I utilied flashloans as a way to be risk adverse. This trading bot trades on a simulated Decentralized Exchange script that I wrote, see Dex.sol under contracts. This insures that the trade will not fail as long as there are usdc token funds in the Dex.sol contract. The FlashLoanArbitrage.sol file contains the arbitrage logic, the arbitrage logic calls functions within the Dex.sol contract. The smart contracts, FlashLoanArbitrage.sol and Dex.sol are both deployed on the Goerli testnet. I can interact with these contracts with a JavaScript "controller". By way of this controller I can make calls to and invoke functions within the deployed smart contracts.
This terminal app performs a flashloan, then does an arbitrage trade on a (extremely simple) simulated dex.




# DESCRIPTION
- A technical description of the application
  - Under the "dex" branch: 
  Go For Broke Bot is a terminal application that performs arbitrage on a test network Goerli blockchain. Hardhat-ethers framework offers a simple way to connect with the Ethereum provider called HRE which you declare and initialize at the top of your file. Using the HRE we can connect to the blockchain and to permited smart contracts.  
  
  This trading bot trades on a simulated decentralised exchange--located in the Dex.sol file--for presentational purposes. The trade will not fail as long as USDC token reserves are available in the Dex.sol contract. USDC funds can be replenished by receiving tokens via an Aave faucet and sending them to the Dex.sol contract, always double check the addresses you are working with. 
  
  FlashLoanArbitrage.sol file contains the flash-loan and arbitrage logic. The arbitrage logic--found within executeOperation()--interacts with the simulated exchange by invoking functions within the Dex.sol contract by its address dexContract. The smart contracts are deployed on the Goerli testnet and can be viewed with a block explorer. 
  
  Block Explorer Links:
  link for FlashLoanArbitrage smart contract -- https://goerli.etherscan.io/address/0xF3D765AEFA1A7269AC2C6Cf0cdce398993bD587C  
  link for Dex smart contract -- https://goerli.etherscan.io/address/0x630cBD2F7438362f61b870B923B1B1d2ebC8BB03. 
  
  Unfortunately, Solidity doesnt offer effective ways for automation. I bypassed this by interacting with these smart contracts through a JavaScript "controller", controller.js file, to automate my calls to functions within these smart contracts. Presently they are commented out for presentational purposes.  

  Before running this program you must populate the env file with your own private information, see the env example.
  to run this program, type in the terminal 
   `npx hardhat run scripts/controller.js --network goerli`
  please only run ONCE as the code will only run if there are funds available in the dex.sol contract. I have funded it a substantial amount so it should be able to run at least 15x.



# See the owner of the contracts

https://goerli.etherscan.io/address/0xda797cfb7bc9529d3e80147e15cc089359c7447e
See the FlashLoanArbitrage.sol deployed contract

https://goerli.etherscan.io/address/0xf3d765aefa1a7269ac2c6cf0cdce398993bd587c
See the Dex.sol deolpyed contract

https://goerli.etherscan.io/address/0x630cbd2f7438362f61b870b923b1b1d2ebc8bb03




- Dependencies
  - HardHat
  - Ethers.js
  - Node.js

- Set-Up 
  - Install Node.js
  - Install and create a Hardhat JavaScript project 
  - Install ethers.js through the Hardhat framework



Happy Coding!