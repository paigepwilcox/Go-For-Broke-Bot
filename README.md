# GO FOR BROKE BOT

Go For Broke Bot served as my capstone project during my tenure at Ada Developers Academy, the project had an uncompromisng deadline of three weeks and required utilization of at least two new technologies. I opted to create an automated trading bot specialized in arbitrage trading--arbitrage is, the simultaneous buying and selling of securites, currency or commodities in different markets or in derivative forms in order to take adnatgae of differing prices for the same asset--handling tokens in the cryptocurrency market.

To safeguard my personal funds the bot will employ code--a pre-exisiting function from Aave's protocol--to obtain a flash-loan from Aave. Aave stands as a liquidity protocol that offers many applications, one of which is flash-loans. Flash-loans operate within a stringent 26-second timeframe--essentially, the time it takes for a single block to encrypt and append to the Ethereum blockchain. Should the loan, inclusive of fees, remain unpaid when the timeframe expires, all transactions undergo reversal. Securing Aave's investment and consequently protecting my own. These loaned funds serves as a safety measure as they facilitate the trading process.

The implementation of flash-loans involves inheritance of Aave's smart contract, FlashLoanSimpleReceiverBase, into my own, FlashLoanArbitrage smart contract and invoking Aave's executeOperation() and requestFlashLoan() functions. 

Due to time constraints, I did not finish unit testing for this code and felt uncomfortable connecting to a Ethereum's main network (blockchain) without such tests. As a workaround, I created a simplistic version of a "decentralized exchange" for demonstration purposes. I created an environment that had reserves of two tokens, allowing external smart contracts to invoke certain internal functions which execute transactions with this smart contract. By connecting to the test network blockchain called Goerli, I could test funcationality of my code using simulated funds and provide a tangible showcase for my professors and peers.

Presently, I am furhtering this project by developing comprehensive unit tests, exploring prevalent algorithms to optimize route selection, and delving into other areas of research.

A picture of a working example
![alt text](https://github.com/paigepwilcox/Go-For-Broke-Bot/blob/dex/brokebot.png?raw=true)


*A technical description of the application*
  
  Go For Broke Bot is a terminal application that performs arbitrage trades on a test network, named Goerli blockchain. This application is a Node.js javascript, hardhat-ethers project. Hardhat-ethers framework offers a simple way to connect with the Ethereum provider api called HRE. Using the HRE we can connect to the blockchain and interact with permited smart contracts.  
  
  This trading bot trades on a simulated exchange environment--located in the contracts/Dex.sol file--for presentational purposes. The trade will not fail as long as USDC token reserves are available in the Dex.sol contract. USDC funds can be replenished by receiving tokens via an Aave faucet and sending them to the Dex.sol contract. Always double check the addresses you are working with. 
  
  contracts/FlashLoanArbitrage.sol file contains the flash-loan and arbitrage logic. The arbitrage logic--found within executeOperation()--interacts with the curated simulated exchange by invoking functions within the Dex.sol contract by its address, dexContract. 


  Why is this bot useful?
  when the price of an asset is the same across markets, its creates equality for buyers and sellers of that asset.  


The deployed smart contracts can be viewed with a block explorer.
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
    Open your terminal and create a new directory for your project
    ```mkdir my-eth-project  /n  cd my-eth-project```

    Initialize a new Node.js project by running
    ```npm init -y```
  2. Install Hardhat:
    Install Hardhat locally
    ```npm install --save-dev hardhat```
  3. Initialize Hardhat in your project:
    Run the following command to initialize Hardhat in your project
    ```npx hardhat```
    This command will prompt you to create a hardhat.config.js file, choose a default setup or Ethereum project template, and set up necessary configurations.
  4. Install ethers.js:
    Install ethers.js for Ethereum interactions
    ```npm install --save ethers```


  
  Before running this program you must populate the env file with your own private information, see the env example.
  to run this program, type in the terminal 
   `npx hardhat run scripts/controller.js --network goerli`
  please only run ONCE as the code will only run if there are funds available in the dex.sol contract. I have funded it a substantial amount so it should be able to run at least 15x.







Happy Coding!