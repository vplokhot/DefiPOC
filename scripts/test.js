require("@nomiclabs/hardhat-ethers");

const swapAddress = "0xD51a44d3FaE010294C616388b506AcdA1bfAAE46"
const depositAddress = "0x3993d34e7e99Abf6B6f367309975d1360222D446"
const triTokenAddress = "0xc4AD29ba4B3c580e6D59105FFf484999997675Ff"

const wethAddress = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
const wbtcAddress = "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599"
const usdtAddress = "0xdac17f958d2ee523a2206206994597c13d831ec7"

async function main() {

  const account = await hre.ethers.getSigner();
  const wei = hre.ethers.utils.parseEther('10.0')

  console.log(account.address)
  
  // console.log(accounts.address)
  // console.log(hre.ethers.utils.formatEther(wei))



  const TriPool = await hre.ethers.getContractFactory("TriPool_Deposit");
  console.log("Deploying TriPool ...");

  const tripool = await TriPool.deploy();
  await tripool.deployed();

  await tripool.setup(depositAddress, triTokenAddress);

  const initialBalance = await tripool.getTokenBalance(account.address)
  console.log(initialBalance.toString(), " initialBalance ")

  const amounts = [0, 0, wei]
  const result = await tripool.add_liquidity(amounts, 0, account.address, {value: wei});
  console.log(result, " result ")

  const postBalance = await tripool.getTokenBalance(account.address)
  console.log(postBalance.toString(), " postBalance ")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
