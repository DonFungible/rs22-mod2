const { ethers } = require("hardhat");
const { BigNumber } = require("ethers");
const { expect } = require("chai");

context("Unit tests", function () {
  beforeEach(async function () {
    // Deploy contract
    const factory = await ethers.getContractFactory("FreeMint");
    this.contract = await factory.deploy();
    await this.contract.deployed();

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
  });

  context("Public mint", function () {
    it("mint any amount up to txn limit", async function () {
      await this.contract.connect(this.signers.random).mintFree(1);

      expect(
        await this.contract.balanceOf(this.signers.random.address)
      ).to.equal(1);
      await this.contract.connect(this.signers.random).mintFree(3);
      expect(
        await this.contract.balanceOf(this.signers.random.address)
      ).to.equal(4);
    });
    it("can't mint more than max supply", async function () {
      await expect(
        this.contract.connect(this.signers.random).mintFree(11)
      ).to.be.revertedWith("Exceeds max supply");
    });
  });
});
