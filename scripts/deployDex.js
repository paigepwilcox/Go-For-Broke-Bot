const hre = require("hardhat");

async function main() {
    console.log("deploying DEX");

    const Dex = await hre.ethers.getContractFactory("Dex");
    const dex = await Dex.deploy();
    await dex.deploymentTransaction().wait();

    console.log("deployed");
}

main()
    .catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });