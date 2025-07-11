# Deployment Guide

## Confidential Waste Recycling Platform - Hardhat Deployment

This guide provides complete instructions for deploying, verifying, and interacting with the Confidential Waste Recycling smart contract using Hardhat.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Compilation](#compilation)
5. [Testing](#testing)
6. [Local Deployment](#local-deployment)
7. [Sepolia Testnet Deployment](#sepolia-testnet-deployment)
8. [Contract Verification](#contract-verification)
9. [Interaction](#interaction)
10. [Simulation](#simulation)
11. [Deployment Information](#deployment-information)
12. [Troubleshooting](#troubleshooting)

---

## Prerequisites

- **Node.js**: >= 18.0.0
- **npm**: >= 9.0.0
- **MetaMask** or similar Ethereum wallet
- **Sepolia testnet ETH** (for testnet deployment)
- **Etherscan API Key** (for contract verification)

---

## Installation

### 1. Install Dependencies

```bash
npm install
```

This will install:
- Hardhat and all development tools
- OpenZeppelin contracts
- FHE libraries (@fhevm/contracts, @fhevm/solidity)
- Testing frameworks (Chai, Mocha)
- TypeChain for type-safe contract interactions

---

## Configuration

### 1. Create Environment File

Copy the example environment file:

```bash
cp .env.example .env
```

### 2. Configure Environment Variables

Edit `.env` with your settings:

```env
# Network RPC URLs
SEPOLIA_RPC_URL=https://rpc.sepolia.org

# Your private key (from MetaMask)
PRIVATE_KEY=your_private_key_without_0x_prefix

# Etherscan API key (from https://etherscan.io/myapikey)
ETHERSCAN_API_KEY=your_etherscan_api_key

# Optional: CoinMarketCap API for gas reporting
COINMARKETCAP_API_KEY=your_coinmarketcap_api_key

# Enable gas reporting
REPORT_GAS=true
```

**Security Warning**: Never commit your `.env` file! It's already in `.gitignore`.

### 3. Get Sepolia Testnet ETH

Get free testnet ETH from Sepolia faucets:
- https://sepoliafaucet.com/
- https://www.alchemy.com/faucets/ethereum-sepolia
- https://faucet.quicknode.com/ethereum/sepolia

---

## Compilation

### Compile Smart Contracts

```bash
npm run compile
```

This will:
- Compile all Solidity contracts
- Generate TypeChain types
- Create artifacts in `artifacts/` directory
- Cache compilation in `cache/` directory

### Clean Build Artifacts

```bash
npm run clean
```

---

## Testing

### Run All Tests

```bash
npm run test
```

### Run Tests with Coverage

```bash
npm run test:coverage
```

Coverage report will be generated in `coverage/` directory.

### Test Output Example

```
✓ Should set the correct owner
✓ Should initialize with zero reports
✓ Should allow owner to authorize reporters
✓ Should allow authorized reporter to submit report
✓ Should allow verifier to verify reports
✓ Should finalize period correctly
```

---

## Local Deployment

### 1. Start Local Hardhat Node

In one terminal:

```bash
npm run node
```

This starts a local Ethereum node at `http://127.0.0.1:8545`

### 2. Deploy to Local Network

In another terminal:

```bash
npm run deploy:local
```

### 3. Run Simulation

Test the full workflow locally:

```bash
npm run simulate
```

This simulates:
- Reporter authorization
- Report submission
- Report verification
- Period finalization
- Statistics aggregation

---

## Sepolia Testnet Deployment

### 1. Ensure You Have Sepolia ETH

Check your balance:
- Open MetaMask
- Switch to Sepolia network
- Ensure balance > 0.01 ETH

### 2. Deploy to Sepolia

```bash
npm run deploy
```

### Expected Output

```
🚀 Starting deployment...

📡 Network: sepolia
👤 Deployer address: 0x1234...
💰 Deployer balance: 0.5 ETH

📝 Deploying ConfidentialWasteRecycling contract...
⏳ Deployment in progress...

✅ Contract deployed successfully!
📍 Contract address: 0xAbCd1234...
🔗 Transaction hash: 0x5678...
⛽ Gas used: 3500000

💾 Deployment info saved to: deployments/sepolia-deployment.json

🔍 View on Etherscan:
https://sepolia.etherscan.io/address/0xAbCd1234...

⏳ Waiting for block confirmations before verification...
✅ Block confirmations received

💡 To verify the contract, run:
npm run verify

👑 Contract owner: 0x1234...

📊 Initial contract state:
   Total reports: 0
   Current period: 1

🎉 Deployment completed successfully!
```

### 3. Deployment Information

After deployment, check `deployments/sepolia-deployment.json`:

```json
{
  "network": "sepolia",
  "contractName": "ConfidentialWasteRecycling",
  "contractAddress": "0xAbCd1234...",
  "deployer": "0x1234...",
  "deploymentTime": "2025-10-25T12:00:00.000Z",
  "transactionHash": "0x5678...",
  "blockNumber": 1234567,
  "chainId": "11155111",
  "compiler": {
    "version": "0.8.24",
    "optimizer": {
      "enabled": true,
      "runs": 200
    }
  }
}
```

---

## Contract Verification

### Verify on Etherscan

```bash
npm run verify
```

### Expected Output

```
🔍 Starting contract verification...

📡 Network: sepolia
📍 Contract address: 0xAbCd1234...
📝 Contract name: ConfidentialWasteRecycling

⏳ Verifying contract on Etherscan...

✅ Contract verified successfully!
🔗 View on Etherscan: https://sepolia.etherscan.io/address/0xAbCd1234...#code

💾 Verification status saved to deployment file

🎉 Verification process completed!
```

### Etherscan Links

After verification, your contract will have:
- ✅ **Verified source code**
- ✅ **Read Contract** tab
- ✅ **Write Contract** tab
- ✅ **Contract ABI**

---

## Interaction

### Interactive Script

```bash
npm run interact
```

### Example Interactions

The script provides functions for:

#### 1. View Contract State
```javascript
await getContractState(contract);
```

#### 2. Authorize Reporter
```javascript
await authorizeReporter(contract, "0x1234...");
```

#### 3. Add Verifier
```javascript
await addVerifier(contract, "0x5678...");
```

#### 4. Submit Report
```javascript
await submitReport(contract, {
  plasticWeight: 100,
  paperWeight: 150,
  glassWeight: 80,
  metalWeight: 50,
  organicWeight: 200,
  energyGenerated: 500,
  carbonReduced: 300
});
```

#### 5. Verify Report
```javascript
await verifyReport(contract, 1); // Report ID
```

#### 6. Finalize Period
```javascript
await finalizePeriod(contract);
```

#### 7. Get Report Info
```javascript
await getReportInfo(contract, 1);
```

#### 8. Get Period Info
```javascript
await getPeriodInfo(contract, 1);
```

### Custom Interaction Example

Modify `scripts/interact.js` for custom workflows:

```javascript
const { loadContract, authorizeReporter, submitReport } = require('./scripts/interact.js');

async function customWorkflow() {
  const { contract } = await loadContract();

  // Authorize multiple reporters
  const reporters = ["0x1234...", "0x5678..."];
  for (const reporter of reporters) {
    await authorizeReporter(contract, reporter);
  }

  // Submit report
  await submitReport(contract, {
    plasticWeight: 150,
    paperWeight: 200,
    // ... other fields
  });
}

customWorkflow();
```

---

## Simulation

### Run Full Simulation

```bash
npm run simulate
```

### What It Does

1. **Deploys** contract to local network
2. **Sets up** 3 reporters and 1 verifier
3. **Simulates** 2 reporting periods with:
   - Random waste data generation
   - Report submission by all reporters
   - Report verification
   - Period finalization
4. **Displays** comprehensive statistics

### Example Output

```
🎬 Starting Confidential Waste Recycling Platform Simulation
════════════════════════════════════════════════════════════

👤 Available signers: 20

🚀 Deploying contract for simulation...
✅ Contract deployed at: 0x5FbDB2315678...

👥 Setting up reporters...
🔐 Authorizing reporter 1: 0x70997970C51812...
✅ Reporter 1 authorized

════════════════════════════════════════════════════════════
📅 PERIOD 1 - Reporting Phase
════════════════════════════════════════════════════════════

📝 Reporter 1 submitting report...
   Plastic: 312 kg
   Paper: 245 kg
   Glass: 189 kg
   Metal: 134 kg
   Organic: 567 kg
   Energy Generated: 823 kWh
   Carbon Reduced: 456 kg
   ✅ Report submitted (Gas: 450000)
   📋 Report ID: 1

────────────────────────────────────────────────────────────
📅 PERIOD 1 - Verification Phase
────────────────────────────────────────────────────────────

✅ Verifying report #1...
   ✓ Verified (Gas: 180000)

🔒 Finalizing period 1...
✅ Period 1 finalized

🎉 Simulation completed successfully!

💡 Key Features Demonstrated:
   ✓ Reporter authorization
   ✓ Verifier management
   ✓ Confidential report submission
   ✓ Report verification
   ✓ Period management
   ✓ Statistics aggregation
```

---

## Deployment Information

### Network Details

#### Sepolia Testnet
- **Chain ID**: 11155111
- **RPC URL**: https://rpc.sepolia.org
- **Explorer**: https://sepolia.etherscan.io
- **Currency**: SepoliaETH (test ETH)

#### Zama fhEVM Devnet (Future)
- **Chain ID**: 8009
- **RPC URL**: https://devnet.zama.ai
- **Currency**: ZAMA

### Contract Details

- **Name**: ConfidentialWasteRecycling
- **Solidity Version**: 0.8.24
- **License**: MIT
- **Optimizer**: Enabled (200 runs)

### Key Features

✅ **Fully Homomorphic Encryption (FHE)**
- Encrypted waste data
- Privacy-preserving statistics
- Confidential computations

✅ **Role-Based Access Control**
- Owner management
- Reporter authorization
- Verifier permissions

✅ **Period Management**
- Reporting periods
- Period finalization
- Historical tracking

✅ **Verification System**
- Report verification
- Verification scores
- Incentive mechanisms

---

## Troubleshooting

### Common Issues

#### 1. Insufficient Funds

**Error**: `sender doesn't have enough funds`

**Solution**:
- Check balance: `await ethers.provider.getBalance(address)`
- Get testnet ETH from faucets

#### 2. Nonce Too Low

**Error**: `nonce too low`

**Solution**:
- Reset MetaMask account: Settings > Advanced > Reset Account
- Or manually set nonce in transaction

#### 3. Gas Price Too Low

**Error**: `transaction underpriced`

**Solution**:
- Update `hardhat.config.js`:
```javascript
sepolia: {
  gasPrice: 20000000000, // 20 gwei
}
```

#### 4. Contract Not Deployed

**Error**: `contract not deployed on network`

**Solution**:
- Verify network: `console.log(hre.network.name)`
- Check deployment file exists
- Redeploy if necessary

#### 5. Verification Failed

**Error**: `Already Verified` or `Invalid API Key`

**Solution**:
- Check API key in `.env`
- Wait 1-2 minutes after deployment
- Ensure correct contract address

#### 6. FHE Library Issues

**Error**: `Cannot find module '@fhevm/solidity'`

**Solution**:
```bash
npm install @fhevm/solidity @fhevm/contracts --save
npm run compile
```

---

## Additional Commands

### Formatting

```bash
npm run format
```

### Linting

```bash
npm run lint
```

### Clean All

```bash
npm run clean
rm -rf node_modules artifacts cache typechain-types
npm install
```

---

## Security Considerations

⚠️ **Important Security Notes**:

1. **Never share your private key**
2. **Never commit `.env` file**
3. **Use testnet for testing**
4. **Audit contracts before mainnet**
5. **Verify contract source code**
6. **Test thoroughly before production**

---

## Support

For issues or questions:
- Review this documentation
- Check Hardhat docs: https://hardhat.org/docs
- Check Zama docs: https://docs.zama.ai
- Review contract code in `contracts/`
- Check test files in `test/`

---

## License

MIT License - See LICENSE file for details

---

**Last Updated**: October 2025
**Version**: 1.0.0
**Network**: Sepolia Testnet
