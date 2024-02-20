TODO: 
1. update arbitrage trade flow discription 

# GO FOR BROKE BOT
:3

Go For Broke Bot served as my capstone project during my tenure at Ada Developers Academy. The project had an uncompromisng deadline of three weeks, and required utilization of at least two new technologies. I opted to create an automated trading bot specialized for arbitrage trade, handling tokens in the cryptocurrency market. Arbitrage is, the simultaneous buying and selling of securites, currency or commodities in different markets or in derivative forms in order to take advantage of differing prices for the same asset.

To safeguard my personal funds the bot will employ POOL.flashLoanSimple() and executeOperation()--pre-exisiting functions from Aave's protocol--to obtain a flash-loan from Aave. Aave stands as a liquidity protocol that offers many applications, one of which is flash-loans. Flash-loans operate within a stringent 26-second timeframe--essentially, the time it takes for a single block to encrypt and append to the Ethereum blockchain. Should the loan, inclusive of fees, remain unpaid when the timeframe expires, all transactions undergo reversal. Securing Aave's investment and consequently protecting my own. These loaned funds serves as a safety measure as the funds will facilitate the trading process.

The implementation of flash-loans involves inheritance of Aave's smart contract, FlashLoanSimpleReceiverBase, into my own, FlashLoanArbitrage smart contract and invoking Aave's executeOperation() and requestFlashLoan() functions. 

The arbitrage trade is ordered as so:


Due to time constraints, I did not finish unit testing for this code and felt uncomfortable connecting to a Ethereum's main network (blockchain) without such tests. As a workaround, I decided to deploy my smart contract onto the georli testnet then created another smart contract which catfished a simplistic version of a "decentralized exchange". This "decentralized exchange" is an environment that has reserves of two tokens, and allows for external smart contracts to invoke methods, making it possible for transactions to occur. By connecting to the test network blockchain called Goerli, I could test funcationality of my code using simulated funds and provide a tangible showcase for my professors and peers.

In the future, I will further this project by developing comprehensive unit tests, exploring prevalent algorithms to optimize route selection, and eventually, connect to a mainnet.

A picture of a working example
![alt text](https://github.com/paigepwilcox/Go-For-Broke-Bot/blob/dex/brokebot.png?raw=true)


*A technical description of the application*
  
  Go For Broke Bot is a terminal application that performs arbitrage trades on a test network, named Goerli blockchain. This application has two parts, the first is the controller which is a Hardhat-ethers project with a runtime of Node.js, and JavaScript logic. The second part are smart contracts--transaction protocols stored on a blockchain-- written in Solidity. Solidity is a statically typed language, without any type of console.log funtions, and is notoriously hard to debug. Hardhat-ethers framework offers a simple way to connect with the Ethereum provider API called HRE. Using the HRE we can connect to the blockchain and interact with permited smart contracts.  
  
  Controller:
  scripts/controller.js file contains functions to create routes, and invoke smart contract functions with the purpose of executing a profitable trade.

  Smart Contracts:
  contracts/Dex.sol file contains a simulated exchange environment for presentational purposes. The trade will not fail as long as USDC token reserves are available in the Dex.sol contract. USDC funds can be replenished by receiving tokens via an Aave faucet and sending them to the Dex.sol contract. Always double check the addresses you are working with. 
  
  contracts/FlashLoanArbitrage.sol file contains the flash-loan and arbitrage logic. The arbitrage logic--found within executeOperation()--creates transactions with the curated simulated exchange by invoking functions within the Dex.sol contract. 


  Q: Why is this bot useful?
  A: When the price of an asset is the same across all markets, it creates equality for buyers and sellers of that asset.  


The deployed smart contracts can be viewed with a block explorer.
 Chech out the transactions that have occured!
# Block Explorer Links:
  See the owner of the contracts:
  https://goerli.etherscan.io/address/0xda797cfb7bc9529d3e80147e15cc089359c7447e

  See the FlashLoanArbitrage.sol deployed contract
  https://goerli.etherscan.io/address/0xf3d765aefa1a7269ac2c6cf0cdce398993bd587c

  See the Dex.sol deolpyed contract
  https://goerli.etherscan.io/address/0x630cbd2f7438362f61b870b923b1b1d2ebc8bb03
 


# Set Up Your Own Project
  Dependencies
    - HardHat
    - Ethers.js
    - Node.js

  Prerequisites:
      Node.js and npm installed on your machine.
      A code editor (like Visual Studio Code, Sublime Text, or Atom).
  
  Steps:
  1. Initialize a new Node.js project:
     1. Open your terminal and create a new directory for your project then initialize

  ```mkdir my-eth-project  /n  cd my-eth-project```
  ```npm init -y```


  2. Install Hardhat locally

    ```npm install --save-dev hardhat```


  3. Initialize Hardhat in your project: 
  ```npx hardhat```

    
    This command will prompt you to create a hardhat.config.js file, choose a default setup or Ethereum project template, and set up necessary configurations.


  4. Install ethers.js for Ethereum interactions


    ```npm install --save ethers```


  
  Before running this program you must populate the env file with your own private information, see the env example.
  To run this program, type the below in the terminal.
   `npx hardhat run scripts/controller.js --network goerli`
 







Happy Coding!