const { ethers } = require("hardhat");
// connect to the ethereum provider with hardhat
const hre = require("hardhat");
require("dotenv").config();

// global variables:
let config, arbitrageContract, owner, inTrade;

// config variable is json 
const network = hre.network.name;
console.log("network name:", network);
// if (network === 'arbitrum') config = require('./../config/arbitrum.json');
if (network === 'goerli') config = require('./../config/goerli.json');

// config = require('./../config/arbitrum.json');

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
    console.log("route successfully loaded!");
    return targetRoute;
}

// find a trade 
const findTrade = async () => {
    console.log("finding a trade...")
    let targetRoute = findRoute();

    try {
        let tradeSize = 10000;
        // const swapfunc = await arbitrageContract.swap(targetRoute.router1, targetRoute.token1, targetRoute.token2, tradeSize);
        // console.log(swapfunc);

        const working = await arbitrageContract.checkingProvider(tradeSize);
        console.log(working);
        
        const amountsOut = await arbitrageContract.getAmountOutMin(targetRoute.router1, targetRoute.router2, targetRoute.token1, targetRoute.token2, tradeSize);
        console.log(amountsOut);
        // await dualTrade(targetRoute.router1,targetRoute.router2,targetRoute.token1,targetRoute.token2,tradeSize);
        console.log("-------------*-----------")
        console.log("estimating trade.....")
        console.log("-------------*-----------")
        // let tradeSize =  ethers.BigNumber.from(1000); //some big number
        const amtBack = await arbitrageContract.estimateDualTrade(targetRoute.router1, targetRoute.router2, targetRoute.token1, targetRoute.token2, tradeSize);
        console.log("before the if statement***");
        if (amtBack.gt(tradeSize)) {
            await dualTrade(targetRoute.router1,targetRoute.router2,targetRoute.token1,targetRoute.token2,tradeSize);
        } else {
            await findTrade();
        }
    } catch (e) {
        console.log("findTrade error:", e)
        // await findTrade();
    }
}

// trade
const dualTrade = async (router1, router2, baseToken, token2, amount) => {
    if (inTrade === true) {
        console.log("opps! in a trade");
        await findTrade();
        // return false?
    }
    
    try {
        inTrade = true;
        console.log('Making a trade eeeeee.......');

        // const setTxValues = await arbContract.connect(owner).dualTradePath(router1, router2, baseToken, token2);
        // await setTxValues.wait();
        const tx = await arbitrageContract.connect(owner).requestFlashLoan(baseToken, amount);
        console.log('hit');
        console.log(owner);
        await tx.wait();
        
        console.log('trade completed!');
        inTrade = false;
        await findTrade()
    } catch (e) {
        console.log('O NO an ERROR, THE HORROR');
        console.log(e);
        inTrade = false;
        // await findTrade();
    }
}



//connects to our deployed contract  
//https://docs.ethers.org/v5/api/contract/contract-factory/
const setup = async () => {
    [owner] = await ethers.getSigners();
    // console.log(owner);

    const Iarb = await ethers.getContractFactory('FlashLoanArbitrage');
    arbitrageContract = await Iarb.attach(config.arbContract);
    // console.log("arbitrageContract ----", arbitrageContract);
}

process.on('uncaughtException', function(err) { // uncaught js exception 
    console.log('UnCaught Exception 83: ' + err);
    console.error(err.stack);
});

  process.on('unhandledRejection', (reason, p) => { // unhandle promise based async context, if the promise was rejected and no error handler is attached to the promise within a turn of the event loop
    console.log('Unhandled Rejection at: '+p+' - reason: '+reason);
});

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });









