// require dotenv 
// make sure ethers is in package.json (dependencies)
// import ethers or use hre from hard hat to connect to the provider 
import { ethers } from ethers



// set up provider connection
// connect to the arbitrum network, console.log(network.name) to make sure we are on the right network




// set up a async function named main that will call the setup() and will call lookForTrade() javascript functions


/* 
lookForTrade() function should:


*/


/* 
setup() function should: 
- assign the owner 
- connect, declare and assign a name to the FlashLoanArbitrage contract that I wrote
i.e. 
creates instance of contract returns the byte address  
const contract = await ethers.getContractFactory('FlashLoanArbitrage')
https://docs.ethers.org/v5/api/contract/contract-factory/
- ???what is the balances object???
- set up a setTimout function to log results of trades 
*/



