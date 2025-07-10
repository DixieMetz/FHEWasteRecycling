const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  console.log("🚀 Starting deployment...\n");

  // Get network information
  const network = hre.network.name;
  const [deployer] = await hre.ethers.getSigners();

  console.log("📡 Network:", network);
  console.log("👤 Deployer address:", deployer.address);

  // Get balance
  const balance = await hre.ethers.provider.getBalance(deployer.address);
  console.log("💰 Deployer balance:", hre.ethers.formatEther(balance), "ETH\n");

  // Check if balance is sufficient
  if (balance === 0n) {
    throw new Error("❌ Deployer account has no funds!");
  }

  console.log("📝 Deploying ConfidentialWasteRecycling contract...");

  // Deploy the contract
  const ConfidentialWasteRecycling = await hre.ethers.getContractFactory("ConfidentialWasteRecycling");

  console.log("⏳ Deployment in progress...");
  const contract = await ConfidentialWasteRecycling.deploy();

  await contract.waitForDeployment();
  const contractAddress = await contract.getAddress();

  console.log("\n✅ Contract deployed successfully!");
  console.log("📍 Contract address:", contractAddress);

  // Get deployment transaction
  const deployTx = contract.deploymentTransaction();
  if (deployTx) {
    console.log("🔗 Transaction hash:", deployTx.hash);
    console.log("⛽ Gas used:", deployTx.gasLimit.toString());
  }

  // Create deployments directory if it doesn't exist
  const deploymentsDir = path.join(__dirname, "..", "deployments");
  if (!fs.existsSync(deploymentsDir)) {
    fs.mkdirSync(deploymentsDir, { recursive: true });
  }

  // Save deployment information
  const deploymentInfo = {
    network: network,
    contractName: "ConfidentialWasteRecycling",
    contractAddress: contractAddress,
    deployer: deployer.address,
    deploymentTime: new Date().toISOString(),
    transactionHash: deployTx ? deployTx.hash : null,
    blockNumber: deployTx ? deployTx.blockNumber : null,
    chainId: (await hre.ethers.provider.getNetwork()).chainId.toString(),
    compiler: {
      version: "0.8.24",
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  };

  // Save to JSON file
  const deploymentFile = path.join(deploymentsDir, `${network}-deployment.json`);
  fs.writeFileSync(deploymentFile, JSON.stringify(deploymentInfo, null, 2));
  console.log("\n💾 Deployment info saved to:", deploymentFile);

  // Display Etherscan link for Sepolia
  if (network === "sepolia") {
    console.log("\n🔍 View on Etherscan:");
    console.log(`https://sepolia.etherscan.io/address/${contractAddress}`);

    console.log("\n⏳ Waiting for block confirmations before verification...");
    await contract.deploymentTransaction().wait(6);
    console.log("✅ Block confirmations received");

    console.log("\n💡 To verify the contract, run:");
    console.log(`npm run verify`);
  }

  // Get contract owner
  const owner = await contract.owner();
  console.log("\n👑 Contract owner:", owner);

  // Get initial state
  const totalReports = await contract.totalReports();
  const currentPeriod = await contract.currentPeriod();

  console.log("\n📊 Initial contract state:");
  console.log("   Total reports:", totalReports.toString());
  console.log("   Current period:", currentPeriod.toString());

  console.log("\n🎉 Deployment completed successfully!");

  // Return deployment info for use in other scripts
  return {
    contractAddress,
    contract,
    deployer: deployer.address,
    network
  };
}

// Execute deployment
if (require.main === module) {
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error("\n❌ Deployment failed:");
      console.error(error);
      process.exit(1);
    });
}

module.exports = { main };
