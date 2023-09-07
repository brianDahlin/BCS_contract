import { ethers, network, run } from "hardhat";

const confirmations = 5;
const addresses = {
    baseTokenURI:'https://gateway.pinata.cloud/ipfs/QmXzdGZZ7Kqsr2eePLDPeLmy7JKcM5Uuz2sPL8FrDJKnSg/',
    baseExtension:'.json',
    totalSupply: 5000,
    devReserve:1000,
};

async function main() {
    
    const BCS = await ethers.getContractFactory("BCS");
    const hcfc = await BCS.deploy(addresses.baseTokenURI, addresses.baseExtension, addresses.totalSupply, addresses.devReserve);
    console.log('BCS deployed to:', hcfc.address);

    console.log(`Waiting for ${confirmations} confirmations`);
    await hcfc.deployTransaction.wait(confirmations);
    
    console.log(`Passed ${confirmations} confirmations, ready to verify`);
    console.log("Verifying...");
    try {
        await run('verify:verify', {
            address: hcfc.address,
            constructorArguments: [addresses.baseTokenURI, addresses.baseExtension, addresses.totalSupply, addresses.devReserve],
        });
        console.log("BCS verified");
    } catch (e) {
        console.log(e);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
