const ethers = require("ethers")


async function main (){
    let provider = ethers.getDefaultProvider("http://localhost:8545");

    const wallet = new ethers.Wallet("0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e");
    const balance = await provider.getBalance(wallet.address)
    console.log("Balance: ", ethers.utils.formatEther(balance));
}

main();
