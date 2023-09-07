require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades')
require('dotenv').config();

const MAINNET_RPC_URL = process.env.MAINNET_RPC_URL

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL

const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL

const PRIVATE_KEY = [process.env.PRIVATE_KEY]

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    mainnet: {
      url: MAINNET_RPC_URL,
      accounts: PRIVATE_KEY,
    },
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: PRIVATE_KEY,
    },
    mumbai: {
      url: MUMBAI_RPC_URL,
      accounts: PRIVATE_KEY,
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.19"
      },
      {
        version: "0.8.0"
      },
    ],
  },
  mocha: {
    timeout: 10000,
  },
};
