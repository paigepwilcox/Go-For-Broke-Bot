const hre = require("hardhat");

async function main() {
  const FlashLoanArbitrage = await hre.ethers.getContractFactory("FlashLoanArbitrage");
  const flashLoanArbitrage = await FlashLoanArbitrage.deploy("0x0496275d34753A48320CA58103d5220d394FF77F");
  //  this above value will be passed into our flashLoanArbitrage constructor 

  await flashLoanArbitrage.deployed();
  console.log("FLashlona arbitrage contract deployed: ", flashLoanArbitrage.address);
}
/* deploy() will trigger this deployment of the contract and .deployed() checks if the contract is already available on the blockchain and if the deployment is still ongoing will wait for the deployment transaction to be mined 
question for instructor --- what are we awaiting? i get that its async then await and then catch is basically catching our resolved promises but what are we awaiting? why do we need to wait for all three?*/

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
