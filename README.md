# Tenzents-Employee

This bot will perform arbitrage using aave's flashloan as a way to protect personal funds. 
- two wallets 
  - 1 for gas fees which will have funds inside already
  - 2 for profits made through arbitrage 
- starting very basic, tenzent's employee will only be looking for differences in prices of the magic token between uniswap and sushiswap decentralized exchanges.
- test deployment will happen in remixide (with goerli?)
- unit tests will be written in foundry 



# DEMO
I am essentially creating a trading bot. My trading bot will perform a specific type of trade called arbitrage using a Flash Loan. Flash Loans only exist in the blockchain and this is a loan you can take out without having to put anything down. The flash loan is coded in a way so if the loan is not repayed within the same block the whole transaction reverts, hence its name Flash loan. Arbitrage is making like assets obtain and maintain equal value across exchanges or markets by way of trading. This type of trade is healthy for the blockchain ecosystem so the bot is doing a good, but not for free.
There are two main blockchains, Bitcoin and Ethereum. Ethereum allows for developers to build off of the ethereum virtual machine or EVM it with smart contracts, smart contracts are made with solidity and solidity is a statically typed oop language designed to target the EVM. Solidity contracts are hard to automate so we can use javascript as long as we have a some way to connect to the ethereum blockchain. We can connect through a library called ethers.js, and whats even better is if we install the hardhat that uses the ethers.js library we can connect to the blockchain and we can debug and test our solidity code (which is a nitoriously difficult task to accomplish)

  Arbitrage -- although this is not too important for a high level overview -- is the transaction or trade of the same asset between different markets with the purpose to make the price of the same asset equal between markets. 