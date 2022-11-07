require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");
require("solidity-coverage");
require("dotenv").config({ path: __dirname + "/.env" });

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    hardhat: {
      blockGasLimit: 900012804080,
      gas: 900012804080,
    },
    goerli: {
      url: process.env.ALCHEMY_GOERLI_URL,
      accounts: [process.env.PRIVATE_KEY],
      blockGasLimit: 30e6,
      gas: 25e6,
    },
    // fuji: {
    //   url: process.env.INFURA_AVALANCHE_URL,
    //   accounts: [process.env.PRIVATE_KEY],
    //   blockGasLimit: 8e6,
    //   gas: 8e6,
    // },
    mumbai: {
      url: process.env.ALCHEMY_MUMBAI_URL,
      // url: process.env.INFURA_MUMBAI_URL,
      accounts: [process.env.PRIVATE_KEY],
      // blockGasLimit: 20e6,
      // gas: 20e6,
      blockGasLimit: 18e6,
      // gasPrice: 18e6,
      gas: 18e6,
    },
    mainnet: {
      url: process.env.ALCHEMY_MAINNET_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  mocha: {
    timeout: 100000000,
  },
  etherscan: {
    apiKey: "824UZ5TSVBH55JZBEU1G8HKN4KWPJICP8V", // ! MATIC
    // apiKey: process.env.ETHERSCAN_KEY, // * ETH
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
    coinmarketcap: process.env.COINMARKETCAP_KEY,
  },
};
