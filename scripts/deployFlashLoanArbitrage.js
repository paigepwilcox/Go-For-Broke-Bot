const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("owner address:", owner.address);
  const FlashLoanArbitrage = await hre.ethers.getContractFactory("FlashLoanArbitrage");
  const flashLoanArbitrage = await FlashLoanArbitrage.deploy("0xa97684ead0e402dC232d5A977953DF7ECBaB3CDb");
  console.log("made it to deploy");
  // console.log(flashLoanArbitrage.deployTransaction);
  //  this above value will be passed into our flashLoanArbitrage constructor 

  // await flashLoanArbitrage.deployed();
  // console.log(flashLoanArbitrage);
  await flashLoanArbitrage.deploymentTransaction().wait();
}
/* 
deploy() will trigger this deployment of the contract and 
.deployed() checks if the contract is already available on the blockchain and if the deployment is still ongoing will wait for the deployment transaction to be mined 
*/

main()
  .then(() => process.exit(0))
  .catch((error) => {
  console.error("you are getting this error: ", error);
  process.exitCode = 1;
}
);
