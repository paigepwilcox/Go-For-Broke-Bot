const { ethers } = require("hardhat");
// connect to the ethereum provider with hardhat
const hre = require("hardhat");
require("dotenv").config();

// global variables:
let config, arbitrageContract, owner, inTrade;

// config variable is json 
const network = hre.network.name;
console.log("Network Name:", network);
console.log();
if (network === 'goerli') config = require('./../config/goerli.json');

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
    console.log();
    console.log("Route Successfully Loaded!", targetRoute);
    console.log();
    return targetRoute;
}

// find a trade 
const findTrade = async () => {
    console.log("GO FOR BROKE!");
    console.log("༼ಢ_ಢ༽");
    console.log("***************************");
    console.log("Starting Trade");
    console.log();
    let targetRoute = findRoute();

    try {
        let tradeSize = 1000000;

        if (tradeSize === 1000000) {
            await dualTrade(targetRoute.router1,targetRoute.router2,targetRoute.token1,targetRoute.token2,tradeSize);
        } else {
            // await findTrade();
            console.log("trade size doesnt match, run again!");
        }
    } catch (e) {
        console.log("༼☯﹏☯༽")
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
    const wethBalancesBefore = await arbitrageContract.getBalance(token2);
    const usdcBalancesBefore = await arbitrageContract.getBalance(baseToken);
    
    try {
        inTrade = true;

        const tx = await arbitrageContract.connect(owner).requestFlashLoan(baseToken, amount);
        console.log('hit');
        await tx.wait();
        
        inTrade = false;
        const wethBalancesAfter = await arbitrageContract.getBalance(token2);
        const usdcBalancesAfter = await arbitrageContract.getBalance(baseToken);
        console.log();
        console.log('Trade Completed!');
        console.log("--------------------------------")
        console.log("Balances BEFORE trade")
        console.log("usdc balance:", usdcBalancesBefore);
        console.log("weth balance:", wethBalancesBefore);
        console.log();
        console.log("Balances AFTER trade")
        console.log("usdc balance:", usdcBalancesAfter);
        console.log("weth balance:", wethBalancesAfter);
        console.log("--------------------------------")
        console.log();
        console.log("ᕕ༼✿•̀︿•́༽ᕗ")
        console.log("Profit Made --> ", usdcBalancesAfter - usdcBalancesBefore);
        // await findTrade()
    } catch (e) {
        console.log('ERROR');
        console.log("༼☯﹏☯༽")
        console.log(e);
        inTrade = false;
        // await findTrade();
    }
}

//connects to our deployed contract  
//https://docs.ethers.org/v5/api/contract/contract-factory/
const setup = async () => {
    [owner] = await ethers.getSigners();
    const Iarb = await ethers.getContractFactory('FlashLoanArbitrage');
    arbitrageContract = await Iarb.attach(config.arbContract);
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
