require("@nomiclabs/hardhat-ethers");

const swapAddress = "0xD51a44d3FaE010294C616388b506AcdA1bfAAE46"
const depositAddress = "0x3993d34e7e99Abf6B6f367309975d1360222D446"

const wethAddress = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
const wbtcAddress = "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599"
const usdtAddress = "0xdac17f958d2ee523a2206206994597c13d831ec7"

async function main() {

  const accounts = await hre.ethers.getSigner();
  const wei = hre.ethers.utils.parseEther('10.0')
  
  // console.log(accounts.address)
  // console.log(hre.ethers.utils.formatEther(wei))


  

  const SwapTriCrypto2 = await hre.ethers.getContractFactory("SwapTriCrypto2");
  console.log("Deploying swapTriCrypto2 ...");

  const swapTriCrypto2 = await SwapTriCrypto2.deploy();

  await swapTriCrypto2.deployed();

  const balance = await hre.ethers.provider.getBalance(swapTriCrypto2.address)
  const ethBalance = hre.ethers.utils.formatEther(balance.toString())
  console.log(ethBalance, " swap balance");

  await swapTriCrypto2.deposit({from: accounts.address, value: wei})
  await swapTriCrypto2.deposit({from: accounts.address, value: wei})

  const balance2 = await hre.ethers.provider.getBalance(swapTriCrypto2.address)
  const ethBalance2 = hre.ethers.utils.formatEther(balance2.toString())
  console.log(ethBalance2, " swap balance");
  

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
