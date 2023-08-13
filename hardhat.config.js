// require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    goerli: {
      url: process.env.INFURA_GOERLI_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY_GAS, process.env.PRIVATE_KEY_PROFIT],
      // gas: 5000000,
      // gasPrice:  50000000000,
      // gasLimit: 5000000000,
    },
    arbitrum: {
      url: process.env.INFURA_ARBITRUM_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY_GAS, process.env.PRIVATE_KEY_PROFIT],
    }
  },
};
