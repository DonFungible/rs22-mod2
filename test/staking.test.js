const { ethers } = require("hardhat");
const { BigNumber } = require("ethers");
const { expect } = require("chai");

context("Unit tests", function () {
  beforeEach(async function () {
    // Deploy contract
    const gameTokenFactory = await ethers.getContractFactory("GameTokenERC20");
    const itemNFTFactory = await ethers.getContractFactory("ItemERC721");
    const stakingFactory = await ethers.getContractFactory("Staking");
    this.gameToken = await gameTokenFactory.deploy();
    this.itemNFT = await itemNFTFactory.deploy();
    await this.gameToken.deployed();
    await this.itemNFT.deployed();

    this.staking = await stakingFactory.deploy(
      this.itemNFT.address,
      this.gameToken.address
    );
    await this.staking.deployed();

    // Get contract users
    const signers = await ethers.getSigners();
    this.signers = {
      admin: signers[0],
      allowlisted: signers[1],
      random: signers[2],
    };
    // Get expected test variables
    this.expected = {
      maxSupply: 10,
      maxMints: 5,
    };
    console.log(`ADMIN ADDRESS: ${this.signers.admin.address}`);
  });

  /*
      User stakes 1 NFT
      Should not have 10c until +24 hours
      User should be able to take 10c after 24 hours
      User should not be able to take any rewards until +24 hours 
      User waits 48 hours 
      User should be able to take out 20c
      
  */

  context("Stake", function () {
    it("mint any amount up to txn limit", async function () {
      // console.log(await this.staking.itemNFT());
      await this.itemNFT.connect(this.signers.admin).mint(5);
      const ownerOf1 = await this.itemNFT
        .connect(this.signers.admin)
        .ownerOf(1);
      expect(ownerOf1).to.equal(this.signers.admin.address);
      const safeTfrTxn = await this.itemNFT[
        // .connect(this.signers.admin)
        "safeTransferFrom(address,address,uint256)"
      ](
        this.signers.admin.address,
        this.staking.address,
        ethers.BigNumber.from(1)
      );
      const ownerOf1AfterTfr = await this.itemNFT
        .connect(this.signers.admin)
        .ownerOf(1);

      expect(ownerOf1AfterTfr).to.equal(this.staking.address);

      // // ACCUMULATE STAKING REWARDS
      let rewards = await this.staking.computeRewards(1);
      console.log(rewards);

      const anHour = 60 * 60;
      const twentyFourHours = 24 * anHour;
      await ethers.provider.send("evm_increaseTime", [24 * anHour]);
      await ethers.provider.send("evm_mine");

      rewards = await this.staking.computeRewards(1);
      expect(rewards).to.equal(10);

      await ethers.provider.send("evm_increaseTime", [5 * anHour]);
      await ethers.provider.send("evm_mine");

      rewards = await this.staking.computeRewards(1);
      expect(rewards).to.equal(10);

      await ethers.provider.send("evm_increaseTime", [19 * anHour]);
      await ethers.provider.send("evm_mine");

      rewards = await this.staking.computeRewards(1);
      expect(rewards).to.equal(20);

      // CLAIM REWARD
      console.log("BALANCE BEFORE CLAIMING");
      const balanceERC20BeforeClaim = await this.gameToken.balanceOf(
        this.signers.admin.address
      );
      expect(balanceERC20BeforeClaim).to.equal(0);

      await this.staking.connect(this.signers.admin).claimStakingRewards(1);

      console.log("BALANCE AFTER CLAIMING");
      const balanceERC20AfterClaim = await this.gameToken.balanceOf(
        this.signers.admin.address
      );
      expect(balanceERC20BeforeClaim).to.equal(20);
    });
  });
});
