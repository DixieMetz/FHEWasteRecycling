# Quick Start Guide

## Confidential Waste Recycling Platform - Hardhat Edition

This guide will help you get up and running quickly with the Hardhat-based development framework.

---

## ⚡ 5-Minute Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env and add:
# - PRIVATE_KEY (from MetaMask)
# - ETHERSCAN_API_KEY (from etherscan.io)
```

### 3. Compile Contracts

```bash
npm run compile
```

### 4. Run Tests

```bash
npm run test
```

### 5. Deploy to Sepolia

```bash
npm run deploy
```

---

## 🎯 Common Tasks

### Test Locally

```bash
# Terminal 1: Start local node
npm run node

# Terminal 2: Deploy locally
npm run deploy:local

# Terminal 3: Run simulation
npm run simulate
```

### Deploy to Testnet

```bash
# 1. Get Sepolia ETH from faucet
# https://sepoliafaucet.com/

# 2. Deploy
npm run deploy

# 3. Verify on Etherscan
npm run verify

# 4. Interact with contract
npm run interact
```

### Run Tests

```bash
# All tests
npm run test

# With coverage
npm run test:coverage

# Watch mode (requires installing nodemon)
npx hardhat test --watch
```

---

## 📝 Contract Interactions

### Using interact.js

```javascript
// Load contract
const { contract } = await loadContract();

// Authorize reporter
await authorizeReporter(contract, "0xReporterAddress");

// Submit report
await submitReport(contract, {
  plasticWeight: 100,
  paperWeight: 150,
  glassWeight: 80,
  metalWeight: 50,
  organicWeight: 200,
  energyGenerated: 500,
  carbonReduced: 300
});

// Verify report
await verifyReport(contract, 1);

// Get report info
await getReportInfo(contract, 1);
```

### Using Hardhat Console

```bash
npx hardhat console --network sepolia
```

```javascript
// In console
const Contract = await ethers.getContractFactory("ConfidentialWasteRecycling");
const contract = await Contract.attach("0xYourContractAddress");

// Check state
await contract.totalReports();
await contract.currentPeriod();
await contract.owner();
```

---

## 🔍 Verification

### Automatic Verification

```bash
npm run verify
```

### Manual Verification

```bash
npx hardhat verify --network sepolia 0xYourContractAddress
```

---

## 🛠️ Development Workflow

### 1. Local Development

```bash
# Start node
npm run node

# Deploy
npm run deploy:local

# Test interactions
npm run simulate
```

### 2. Testing

```bash
# Run tests
npm run test

# Check coverage
npm run test:coverage

# Lint code
npm run lint

# Format code
npm run format
```

### 3. Deployment

```bash
# Compile
npm run compile

# Deploy to Sepolia
npm run deploy

# Verify
npm run verify

# Interact
npm run interact
```

---

## 📊 Deployment Info

After deployment, check `deployments/sepolia-deployment.json`:

```json
{
  "contractAddress": "0x...",
  "deployer": "0x...",
  "network": "sepolia",
  "deploymentTime": "...",
  "transactionHash": "0x...",
  "verified": true
}
```

---

## 🐛 Troubleshooting

### Issue: Insufficient Funds

```bash
# Get Sepolia ETH from faucet
# https://sepoliafaucet.com/
```

### Issue: Compilation Error

```bash
# Clean and recompile
npm run clean
npm run compile
```

### Issue: Test Failures

```bash
# Run tests with detailed output
npx hardhat test --verbose
```

### Issue: Verification Failed

```bash
# Wait 1-2 minutes after deployment
# Then retry verification
npm run verify
```

### Issue: Network Connection

```bash
# Check network in hardhat.config.js
# Verify RPC URL in .env
# Test connection:
npx hardhat run scripts/deploy.js --network sepolia
```

---

## 📚 Useful Commands

### Hardhat

```bash
# List accounts
npx hardhat accounts

# Check balance
npx hardhat run scripts/check-balance.js --network sepolia

# Run specific test
npx hardhat test test/ConfidentialWasteRecycling.test.js

# Gas report
REPORT_GAS=true npm run test
```

### Network Info

```bash
# Sepolia block explorer
https://sepolia.etherscan.io/

# Sepolia RPC
https://rpc.sepolia.org

# Chain ID: 11155111
```

---

## 🎓 Learning Resources

- **Hardhat Docs**: https://hardhat.org/docs
- **Ethers.js Docs**: https://docs.ethers.org/v6/
- **Zama FHE Docs**: https://docs.zama.ai/
- **Solidity Docs**: https://docs.soliditylang.org/

---

## 💡 Tips

1. **Always test locally first**: Use `npm run simulate` before deploying to testnet
2. **Keep track of gas**: Enable gas reporting in tests
3. **Verify contracts**: Always verify on Etherscan for transparency
4. **Backup deployment info**: Save `deployments/*.json` files
5. **Use environment variables**: Never commit private keys or API keys

---

## 🚀 Next Steps

1. ✅ Deploy to Sepolia testnet
2. ✅ Verify contract on Etherscan
3. ✅ Authorize reporters and verifiers
4. ✅ Submit test reports
5. ✅ Monitor contract activity
6. 🔜 Integrate frontend (optional)
7. 🔜 Add monitoring and alerts
8. 🔜 Plan mainnet deployment

---

## 📞 Support

For issues:
- Check [DEPLOYMENT.md](./DEPLOYMENT.md)
- Review [README.md](./README.md)
- Check Hardhat docs: https://hardhat.org/docs

---

**Happy Building!** 🎉
