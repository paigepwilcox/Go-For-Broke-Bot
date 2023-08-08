const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Flash Loan Arbitrage contract", function () {
    it("Deployment should assign the owner ", async function () {
        const [owner] = await ethers.getSigners();
        console.log(owner);
        const tradingBot = await ethers.deployContract("FlashLoanArbitrage");
        // const ownerBalance = await tradingBot.balanceOf(owner.address);

        expect(owner).to.equal("0xDA797Cfb7bC9529D3E80147e15cc089359c7447E");
    } );
});
