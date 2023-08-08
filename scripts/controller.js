// connect to the ethereum provider with hardhat
const hre = require("hardhat");
require("dotenv").config();

// global variables:
let config, arbContract, owner, inTrade, balances;

// config variable is json 
const network = hre.network.name;
if (network === 'arbitrum') config = require('./../config/arbitrum.json');

// main function
const main = async () => {
    await setup();
    await findTrade();
}

// returns a target object 
let index = 0;
const findRoute = () => {
    const targetRoute= {};
    const route = config.routes[index];

    index += 1;
    if (index >= config.routes.length) index = 0;

    targetRoute.router1 = route[0];
    targetRoute.router2 = route[1];
    targetRoute.token1 = route[2];
    targetRoute.token2 = route[3];

    return targetRoute;
}

// find a trade 
const findTrade = async () => {
    let targetRoute = findRoute();

    try {
        let tradeSize =  ethers.BigNumber.from(1000); //some big number
        const amtBack = await arbContract.estimateDualTrade(targetRoute.router1, targetRoute.router2, targetRoute.token1, targetRoute.token2, tradeSize);

        if (amtBack.gt(tradeSize)) {
            await dualTrade();
        }
    } catch (e) {
        console.log(e)
        await findTrade();
    }
}

// trade
const dualTrade = async (router1, router2, baseToken, token2, amount) => {
    if (inTrade === true) {
        await findTrade();
        // return false?
    }
    
    try {
        inTrade = true;
        console.log('Making a trade eeeeee');

        const setTxValues = await arbContract.connect(owner).dualTradePath(router1, router2, baseToken, token2);
        await setTxValues.wait();
        const tx = await arbContract.connect(owner).executeOperation(baseToken, amount);

        console.log('hit');
        console.log(owner);
        await tx.wait();
        console.log('completed!');
        inTrade = false;
        await findTrade()
    } catch (e) {
        console.log('O NO an ERROR, THE HORROR');
        console.log(e);
        inTrade = false;
        await findTrade();
    }
}



//connects to our deployed contract  
//https://docs.ethers.org/v5/api/contract/contract-factory/
const setup = async () => {
    [owner] = await hre.ethers.getSigners();
    console.log(owner);

    const arb = await ethers.getContractFactory('FlashLoanArbitrage');
    const arbContract = await arb.attach(config.arbContract);
}









