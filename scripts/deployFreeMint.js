// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const contractFactory = await ethers.getContractFactory("FreeMint");
  this.contract = await contractFactory.deploy();
  await this.contract.deployed();

  await this.contract.setBaseURI("https://api.coolcatsnft.com/cat/");

  console.log(
    `Contract deployed to: https://etherscan.io/address/${this.contract.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
