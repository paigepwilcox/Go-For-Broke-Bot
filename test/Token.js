const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Flash Loan Arbitrage contract", function () {
    it("Deployment should assign the total supply of tokens to the owner", async function () {
        const [owner] = await ethers.getSigners();
        const tradingBot = await ethers.deployContract("FlashLoanArbitrage");
        const ownerBalance = await tradingBot.balanceOf(owner.address);

        expect(await tradingBot.totalSupply()).to.equal(ownerBalance);
    } );
});
