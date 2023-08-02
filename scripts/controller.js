// connect to the ethereum provider with hardhat
const hre = require("hardhat");
require("dotenv").config();

// global variables:
let config, arbContract, owner, inTrade, balances;

// config variable is json 
const network = hre.network.name;
if (network === 'arbitrum') config = require('./../config/arbitrum.json')

// main function
const main = async () => {
    await setup();
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

//connects to our deployed contract  
//https://docs.ethers.org/v5/api/contract/contract-factory/
const setup = async () => {
    [owner] = await hre.ethers.getSigners();

    const arb = await ethers.getContractFactory('FlashLoanArbitrage');
    const arbContract = await arb.attach(config.arbContract);
}









