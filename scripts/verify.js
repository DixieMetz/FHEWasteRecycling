const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  console.log("🔍 Starting contract verification...\n");

  const network = hre.network.name;
  console.log("📡 Network:", network);

  // Load deployment information
  const deploymentFile = path.join(__dirname, "..", "deployments", `${network}-deployment.json`);

  if (!fs.existsSync(deploymentFile)) {
    throw new Error(`❌ Deployment file not found: ${deploymentFile}\nPlease deploy the contract first using: npm run deploy`);
  }

  const deploymentInfo = JSON.parse(fs.readFileSync(deploymentFile, "utf8"));
  const contractAddress = deploymentInfo.contractAddress;

  console.log("📍 Contract address:", contractAddress);
  console.log("📝 Contract name:", deploymentInfo.contractName);

  // Verify on Etherscan
  if (network === "sepolia") {
    console.log("\n⏳ Verifying contract on Etherscan...");

    try {
      await hre.run("verify:verify", {
        address: contractAddress,
        constructorArguments: [],
      });

      console.log("\n✅ Contract verified successfully!");
      console.log(`🔗 View on Etherscan: https://sepolia.etherscan.io/address/${contractAddress}#code`);

      // Update deployment info with verification status
      deploymentInfo.verified = true;
      deploymentInfo.verifiedAt = new Date().toISOString();
      fs.writeFileSync(deploymentFile, JSON.stringify(deploymentInfo, null, 2));

      console.log("\n💾 Verification status saved to deployment file");

    } catch (error) {
      if (error.message.includes("Already Verified")) {
        console.log("\n✅ Contract is already verified!");
        console.log(`🔗 View on Etherscan: https://sepolia.etherscan.io/address/${contractAddress}#code`);
      } else {
        console.error("\n❌ Verification failed:");
        console.error(error.message);
        throw error;
      }
    }
  } else {
    console.log("\n⚠️  Etherscan verification is only available for Sepolia network");
    console.log("Current network:", network);
  }

  console.log("\n🎉 Verification process completed!");
}

// Execute verification
if (require.main === module) {
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error("\n❌ Verification failed:");
      console.error(error);
      process.exit(1);
    });
}

module.exports = { main };
