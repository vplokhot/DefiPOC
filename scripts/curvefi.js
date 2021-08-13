const hre = require("hardhat");

async function main() {

  const DepositY = await hre.ethers.getContractFactory("DepositY");
  console.log("Deploying DepositY ...");

  const depositY = await DepositY.deploy();

  await depositY.deployed();
  
  console.log("DepositY setup ...");
  await depositY.setup("0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3")

  const swap = await depositY.curveFi_Swap()
  console.log("depositY curve value :", swap);
console.log("Fetching underlying ...");
    const coins = await depositY.coin()
    console.log("underlying coins :", coins);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
