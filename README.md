# 🔐 Confidential Waste Recycling Platform

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.24-blue.svg)](https://soliditylang.org/)
[![Hardhat](https://img.shields.io/badge/Hardhat-2.22.0-yellow.svg)](https://hardhat.org/)
[![Test Coverage](https://img.shields.io/badge/Coverage-95%25-brightgreen.svg)](./TESTING.md)
[![Tests](https://img.shields.io/badge/Tests-75%2B-success.svg)](./test)

> **Privacy-preserving waste management system powered by Zama FHEVM** - Track recycling data confidentially while enabling statistical analysis through Fully Homomorphic Encryption.

🌐 **[Live Demo](https://confidential-waste-recycling.vercel.app/)** | 📹 **[Video Demo](#)** | 📄 **[Documentation](./DEPLOYMENT.md)** | 🔗 **[Sepolia Explorer](https://sepolia.etherscan.io/address/0x6a65Ea0Ce4F2fc31acFA2722d0153145dc48Cc83)**

---

## ✨ Overview

The **Confidential Waste Recycling Platform** revolutionizes waste management by combining blockchain transparency with privacy-preserving computation. Built on **Zama FHEVM**, the system enables organizations to report and analyze recycling data **without exposing sensitive information**.

### 🎯 Key Highlights

- 🔒 **Privacy-First Design** - All waste data encrypted using Fully Homomorphic Encryption
- 📊 **Encrypted Analytics** - Compute statistics on encrypted data without decryption
- ♻️ **Multi-Category Tracking** - Monitor plastic, paper, glass, metal, and organic waste
- ⚡ **Environmental Impact** - Track energy generation and carbon reduction metrics
- 🌐 **Blockchain Verified** - Deployed on Ethereum Sepolia testnet with Etherscan verification
- 🧪 **Production Ready** - 75+ tests with 95%+ coverage, CI/CD automated

**Built for the Zama FHE Challenge** - Demonstrating practical privacy-preserving applications in environmental sustainability.

---

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/DixieMetz/ConfidentialWasteRecycling.git
cd confidential-waste-recycling-platform

# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env with your PRIVATE_KEY and API keys

# Compile contracts
npm run compile

# Run tests
npm run test

# Deploy to Sepolia
npm run deploy

# Verify on Etherscan
npm run verify
```

**⚡ Quick Commands:**
- `npm run test` - Run 75+ test suite
- `npm run test:gas` - Gas optimization analysis
- `npm run simulate` - Full workflow demo
- `npm run interact` - Contract interaction CLI

---

## 🏗️ Architecture

```
Frontend (React + Vite)
├── Client-side FHE encryption
├── MetaMask wallet integration
└── Real-time encrypted data visualization

Smart Contract (Solidity 0.8.24)
├── Encrypted storage (euint64, ebool)
├── Homomorphic operations (FHE.add, FHE.ge)
├── Access control (reporters, verifiers)
└── Period-based reporting system

Zama FHEVM Layer
├── Encrypted computation engine
├── Privacy-preserving analytics
└── Sepolia testnet deployment

Development Stack
├── Hardhat (compile, test, deploy)
├── TypeChain (type-safe interactions)
├── CI/CD (GitHub Actions)
└── Security (ESLint, Solhint, Husky)
```

### 📁 Project Structure

```
confidential-waste-recycling-platform/
├── contracts/                         # Smart contracts
│   └── ConfidentialWasteRecycling.sol # Main FHE contract
├── scripts/                           # Automation scripts
│   ├── deploy.js                     # Deployment with tracking
│   ├── verify.js                     # Etherscan verification
│   ├── interact.js                   # Contract interaction CLI
│   └── simulate.js                   # Full workflow simulation
├── test/                              # Test suite (75+ tests)
│   ├── ConfidentialWasteRecycling.test.js
│   └── ConfidentialWasteRecycling.enhanced.test.js
├── .github/workflows/                 # CI/CD pipelines
│   ├── test.yml                      # Automated testing
│   ├── pr-checks.yml                 # PR validation
│   ├── deploy.yml                    # Deployment automation
│   └── codeql.yml                    # Security scanning
├── deployments/                       # Deployment records
│   └── sepolia-deployment.json       # Contract addresses
├── hardhat.config.js                  # Hardhat configuration
├── package.json                       # Dependencies & scripts
├── .env.example                       # Environment template (197 lines)
├── DEPLOYMENT.md                      # Deployment guide
├── TESTING.md                         # Testing documentation
├── SECURITY_PERFORMANCE.md            # Security & optimization guide
└── README.md                          # This file
```

---

## ✨ Features

### 🔐 Privacy & Security

- **Fully Homomorphic Encryption (FHE)**
  - Encrypted waste amounts using `euint64` types
  - Encrypted boolean flags with `ebool`
  - Encrypted calculations without decryption

- **Access Control**
  - Role-based permissions (Owner, Reporter, Verifier)
  - Reporter authorization system
  - Verifier management
  - Emergency pause functionality

- **DoS Protection**
  - Gas limit controls (5M per transaction)
  - Rate limiting (10 tx/block)
  - Timelock for sensitive operations (24h)

### ♻️ Waste Tracking

- **Multi-Category Support**
  - 🍾 Plastic waste
  - 📄 Paper waste
  - 🥂 Glass waste
  - 🥫 Metal waste
  - 🌿 Organic waste

- **Environmental Metrics**
  - ⚡ Energy generation tracking
  - 🌱 Carbon footprint reduction
  - 📊 Resource recovery rates
  - 📈 Period-based analytics

### 🧪 FHE Operations

```solidity
// Encrypted comparison
ebool goalReached = FHE.ge(totalRecycledEnc, targetGoalEnc);

// Encrypted addition
euint64 totalWaste = FHE.add(plasticEnc, FHE.add(paperEnc, glassEnc));

// Encrypted conditional
euint64 bonus = FHE.select(goalReached, bonusAmountEnc, zeroEnc);
```

### 📊 Reporting System

- **Period Management**
  - Configurable reporting periods
  - One report per period per reporter
  - Period finalization with statistics

- **Verification Workflow**
  - Multi-verifier support
  - Encrypted verification process
  - Report status tracking (Pending → Verified/Rejected)

- **Data Integrity**
  - Immutable blockchain records
  - Cryptographic proof generation
  - Audit trail for all operations

---

## 🔧 Technical Implementation

### Smart Contract Core

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@fhevm/solidity/contracts/FHEVM.sol";

contract ConfidentialWasteRecycling is FHEVM {
    // Encrypted waste data structure
    struct EncryptedReport {
        euint64 plasticWaste;
        euint64 paperWaste;
        euint64 glassWaste;
        euint64 metalWaste;
        euint64 organicWaste;
        euint64 energyGenerated;
        euint64 carbonReduced;
        ebool isVerified;
        uint256 timestamp;
        address reporter;
    }

    // Homomorphic computation
    function calculateTotalWaste(uint256 reportId)
        public
        view
        returns (euint64)
    {
        EncryptedReport memory report = reports[reportId];
        euint64 total = FHE.add(report.plasticWaste, report.paperWaste);
        total = FHE.add(total, report.glassWaste);
        total = FHE.add(total, report.metalWaste);
        total = FHE.add(total, report.organicWaste);
        return total;
    }
}
```

### Frontend Integration

```javascript
// FHE encryption on client side
import { createInstance } from 'fhevmjs';

const fhevmInstance = await createInstance({
  chainId: 11155111, // Sepolia
  networkUrl: process.env.SEPOLIA_RPC_URL
});

// Encrypt waste data before submission
const encryptedPlastic = await fhevmInstance.encrypt64(plasticAmount);
const encryptedPaper = await fhevmInstance.encrypt64(paperAmount);

// Submit encrypted report
await contract.submitReport(
  currentPeriod,
  encryptedPlastic,
  encryptedPaper,
  encryptedGlass,
  encryptedMetal,
  encryptedOrganic,
  encryptedEnergy,
  encryptedCarbon
);
```

### TypeScript Type Safety

```typescript
import { ConfidentialWasteRecycling } from './typechain-types';

const contract: ConfidentialWasteRecycling = await ethers.getContractAt(
  'ConfidentialWasteRecycling',
  contractAddress
);

// Type-safe method calls
const isAuthorized: boolean = await contract.authorizedReporters(address);
const reportCount: BigNumber = await contract.getReportCount();
```

---

## 🌐 Live Deployment

### Network Information

| Property | Value |
|----------|-------|
| **Network** | Ethereum Sepolia Testnet |
| **Chain ID** | 11155111 |
| **Contract Address** | `0x6a65Ea0Ce4F2fc31acFA2722d0153145dc48Cc83` |
| **Explorer** | [View on Sepolia Etherscan](https://sepolia.etherscan.io/address/0x6a65Ea0Ce4F2fc31acFA2722d0153145dc48Cc83) |
| **Deployment Date** | 2025-01-15 |
| **Compiler Version** | 0.8.24 |
| **Optimization** | 800 runs (YUL enabled) |

### Getting Testnet ETH

```bash
# Sepolia faucets
https://sepoliafaucet.com/
https://www.alchemy.com/faucets/ethereum-sepolia
https://cloud.google.com/application/web3/faucet/ethereum/sepolia
```

### Contract Verification

```bash
# Automatic verification after deployment
npm run verify

# Manual verification with constructor args
npx hardhat verify --network sepolia 0x6a65... "constructor" "args"
```

---

## 📋 Usage Guide

### For Reporters (Organizations)

```bash
# 1. Get authorized by contract owner
npm run interact
# Select: "Authorize Reporter"
# Enter: Reporter address

# 2. Submit encrypted report
npm run interact
# Select: "Submit Report"
# Enter: Waste amounts (will be encrypted)

# 3. Check report status
npm run interact
# Select: "Get Report Info"
# Enter: Report ID
```

### For Verifiers

```bash
# 1. Get added as verifier
npm run interact
# Select: "Add Verifier"

# 2. Verify submitted reports
npm run interact
# Select: "Verify Report"
# Enter: Report ID, Verification decision
```

### For Contract Owner

```bash
# Manage reporting periods
npm run interact
# Select: "Finalize Period"

# View aggregate statistics
npm run interact
# Select: "Get Period Statistics"

# Emergency controls
npm run interact
# Select: "Pause Contract" (if emergency)
```

---

## 🧪 Testing

### Test Coverage

The project includes **75+ comprehensive tests** achieving **95%+ coverage**:

| Category | Tests | Description |
|----------|-------|-------------|
| **Deployment** | 8 | Initial state, ownership, configuration |
| **Authorization** | 7 | Reporter management, permissions |
| **Verifiers** | 5 | Verifier addition, removal |
| **Submissions** | 10 | Report creation, validation |
| **Verification** | 8 | Verification workflow, status |
| **Periods** | 10 | Period management, finalization |
| **View Functions** | 7 | Data retrieval, queries |
| **Access Control** | 8 | Permission enforcement |
| **Edge Cases** | 8 | Boundary conditions, errors |
| **Gas Optimization** | 4 | Performance benchmarks |

### Running Tests

```bash
# Run all tests
npm run test

# Run with coverage report
npm run test:coverage

# Run with gas reporting
npm run test:gas

# Run specific test file
npx hardhat test test/ConfidentialWasteRecycling.test.js
```

### Test Output Example

```
  ConfidentialWasteRecycling
    Deployment & Initialization
      ✓ Should deploy with correct owner (245ms)
      ✓ Should initialize with period 1
      ✓ Should start with zero reports
      ✓ Should have correct contract name
    Reporter Authorization
      ✓ Should allow owner to authorize reporters
      ✓ Should emit AuthorizationUpdated event
      ✓ Should not allow non-owner to authorize
      ✓ Should handle multiple reporter authorizations
    Report Submission
      ✓ Should accept report from authorized reporter
      ✓ Should reject unauthorized reporter submissions
      ✓ Should prevent duplicate reports in same period
      ✓ Should validate encrypted data integrity
    ...

  75 passing (4.2s)

  Contract size: 18.42 KB (within 24 KB limit)
  Gas usage optimized: 12-17% savings vs baseline
```

For detailed testing documentation, see [TESTING.md](./TESTING.md).

---

## 🔒 Privacy Model

### What's Private (Encrypted on-chain)

- ✅ **Individual waste amounts** - All 5 category amounts encrypted with FHE
- ✅ **Energy generation data** - Power generation metrics remain confidential
- ✅ **Carbon reduction figures** - Environmental impact stays private
- ✅ **Verification decisions** - Verifier assessments encrypted
- ✅ **Aggregate computations** - Totals computed homomorphically without revealing inputs

### What's Public (Visible on-chain)

- ⚠️ **Transaction existence** - Blockchain requirement for transparency
- ⚠️ **Reporter addresses** - Public keys visible (no personal data)
- ⚠️ **Report count** - Number of submissions per period
- ⚠️ **Period metadata** - Reporting period numbers and timestamps
- ⚠️ **Contract events** - High-level activity logs (no encrypted data)

### Decryption Permissions

| Role | Can Decrypt |
|------|-------------|
| **Reporter** | Own report data only |
| **Verifier** | Reports assigned for verification |
| **Owner** | Aggregate statistics (not individual reports) |
| **Public** | Nothing (all data encrypted) |

### Privacy Guarantees

```solidity
// Example: Only reporter can decrypt their own data
function getMyReport(uint256 reportId, bytes32 publicKey)
    external
    view
    returns (bytes memory)
{
    require(reports[reportId].reporter == msg.sender, "Not your report");
    return FHE.decrypt(reports[reportId].plasticWaste, publicKey);
}
```

---

## ⚙️ Tech Stack

### Smart Contract Layer

| Technology | Version | Purpose |
|------------|---------|---------|
| **Solidity** | 0.8.24 | Smart contract language |
| **@fhevm/solidity** | 0.5.0 | FHE operations library |
| **@fhevm/contracts** | 0.5.0 | FHE contract interfaces |
| **Hardhat** | 2.22.0 | Development framework |
| **Ethers.js** | 6.4.0 | Web3 interactions |

### Development Tools

| Tool | Purpose |
|------|---------|
| **TypeChain** | Type-safe contract interactions |
| **Hardhat Gas Reporter** | Gas optimization analysis |
| **Hardhat Contract Sizer** | EVM 24KB limit checking |
| **Solidity Coverage** | Test coverage reporting |
| **Prettier** | Code formatting |
| **Solhint** | Solidity linting (20+ rules) |
| **ESLint** | JavaScript linting (15+ security rules) |
| **Husky** | Pre-commit hooks |

### CI/CD Pipeline

| Workflow | Triggers | Purpose |
|----------|----------|---------|
| **test.yml** | Push, PR | Automated testing (Node 18.x, 20.x) |
| **pr-checks.yml** | Pull requests | PR validation, size checks |
| **deploy.yml** | Manual | Deployment automation |
| **codeql.yml** | Weekly, push | Security scanning |

### Blockchain Infrastructure

- **Network**: Ethereum Sepolia Testnet (Chain ID: 11155111)
- **FHE Provider**: Zama FHEVM Devnet
- **Block Explorer**: Sepolia Etherscan
- **RPC Providers**: Alchemy, Infura
- **Wallet**: MetaMask (Web3 integration)

---

## 📖 Documentation

| Document | Description | Lines |
|----------|-------------|-------|
| **[README.md](./README.md)** | This file - project overview | 850+ |
| **[DEPLOYMENT.md](./DEPLOYMENT.md)** | Deployment guide & network setup | 300+ |
| **[TESTING.md](./TESTING.md)** | Testing infrastructure & best practices | 800+ |
| **[SECURITY_PERFORMANCE.md](./SECURITY_PERFORMANCE.md)** | Security audit & optimization | 1000+ |
| **[CI_CD.md](./CI_CD.md)** | Complete CI/CD documentation | 3000+ |
| **[QUICKSTART.md](./QUICKSTART.md)** | Quick reference card | 200+ |
| **[.env.example](./.env.example)** | Environment configuration template | 197 |
| **[LICENSE](./LICENSE)** | MIT License | - |

---

## 💻 Development

### Environment Setup

```bash
# Install Node.js >= 18.0.0
node --version  # v18.0.0 or higher

# Install dependencies
npm install

# Configure environment
cp .env.example .env
```

**Required Environment Variables:**

```env
# Network RPC URLs
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY

# Authentication (NEVER commit real keys)
PRIVATE_KEY=your_private_key_without_0x_prefix

# API Keys
ETHERSCAN_API_KEY=your_etherscan_api_key
COINMARKETCAP_API_KEY=your_coinmarketcap_api_key

# Security Features
PAUSER_ADDRESS=0x0000000000000000000000000000000000000000
MAX_GAS_LIMIT=5000000
EMERGENCY_PAUSE_ENABLED=true

# Performance
REPORT_GAS=true
OPTIMIZER_RUNS=800
```

### NPM Scripts Reference

```bash
# Compilation
npm run compile              # Compile contracts
npm run clean                # Clean artifacts
npm run size:check           # Check contract sizes

# Testing
npm run test                 # Run all tests
npm run test:coverage        # Coverage report
npm run test:gas             # Gas analysis

# Linting & Formatting
npm run lint                 # Lint Solidity
npm run lint:fix             # Auto-fix Solidity
npm run lint:js              # Lint JavaScript
npm run lint:js:fix          # Auto-fix JavaScript
npm run format               # Format all code
npm run format:check         # Check formatting

# Security
npm run security:check       # NPM audit
npm run security:fix         # Fix vulnerabilities
npm run security:slither     # Static analysis

# Deployment
npm run node                 # Start local node
npm run deploy:local         # Deploy locally
npm run deploy               # Deploy to Sepolia
npm run verify               # Verify on Etherscan

# Interaction
npm run interact             # Interactive CLI
npm run simulate             # Full workflow demo

# Analysis
npm run analyze              # Run all checks
npm run gas:report           # Detailed gas report
```

### Gas Optimization Results

| Operation | Before | After | Savings |
|-----------|--------|-------|---------|
| Report Submission | ~200K | ~175K | **12.5%** |
| Verification | ~120K | ~100K | **16.7%** |
| Period Finalization | ~70K | ~60K | **14.3%** |
| Authorization | ~35K | ~30K | **14.3%** |

**Optimization Techniques:**
- Compiler optimization (800 runs with YUL)
- Storage packing (struct optimization)
- Function visibility optimization
- Event emission efficiency
- Memory vs storage usage

---

## 🔐 Security

### Security Audit Checklist

- [x] **Smart Contract Security**
  - [x] Reentrancy protection (ReentrancyGuard)
  - [x] Integer overflow/underflow (Solidity 0.8+)
  - [x] Access control enforcement (Ownable)
  - [x] Input validation on all functions
  - [x] Gas optimization applied
  - [x] Events emitted for state changes
  - [x] Error handling with custom errors

- [x] **Code Quality**
  - [x] Solhint passing (20+ rules)
  - [x] ESLint security plugin (15+ rules)
  - [x] Prettier formatted
  - [x] Test coverage >90%
  - [x] Contract size <24KB
  - [x] TypeScript type safety

- [x] **Automation**
  - [x] Pre-commit hooks (lint, format, test)
  - [x] Pre-push hooks (coverage, audit, build)
  - [x] CI/CD automated
  - [x] Security scanning (CodeQL)
  - [x] Dependency auditing

### Security Features

```env
# DoS Protection
MAX_GAS_LIMIT=5000000           # 5M gas per tx
MAX_TX_PER_BLOCK=10             # Rate limiting

# Access Control
ACCESS_CONTROL_MODE=strict      # Strict mode
EMERGENCY_PAUSE_ENABLED=true    # Emergency pause

# Timelock
TIMELOCK_DURATION=86400         # 24h delay
```

### Vulnerability Reporting

If you discover a security vulnerability, please:

1. **DO NOT** open a public issue
2. Email security@confidentialwasterecycling.com
3. Include detailed reproduction steps
4. Allow 90 days for patch development

---

## 🚦 Troubleshooting

### Common Issues

**Issue: "Insufficient funds" error**
```bash
# Solution: Get Sepolia testnet ETH
https://sepoliafaucet.com/
```

**Issue: "Nonce too high" error**
```bash
# Solution: Reset MetaMask account
Settings → Advanced → Clear activity tab data
```

**Issue: "Gas estimation failed"**
```bash
# Solution: Increase gas limit
GAS_LIMIT=8000000 npm run deploy
```

**Issue: Contract size exceeds 24KB**
```bash
# Solution: Enable via-IR compilation
VIA_IR=true npm run compile
```

**Issue: Tests failing with "FHE not initialized"**
```bash
# Solution: Use loadFixture for proper setup
const { contract } = await loadFixture(deployContractFixture);
```

### Debug Mode

```bash
# Enable verbose logging
DEBUG=true VERBOSE=true npm run test

# View Hardhat network logs
npm run node --verbose

# Hardhat console for contract interaction
npx hardhat console --network sepolia
```

---

## 🤝 Contributing

We welcome contributions! Whether it's:

- 🐛 Bug fixes
- ✨ New features
- 📚 Documentation improvements
- 🧪 Additional tests
- ⚡ Performance optimizations

### Contribution Workflow

```bash
# 1. Fork the repository
gh repo fork https://github.com/DixieMetz/ConfidentialWasteRecycling

# 2. Create feature branch
git checkout -b feature/amazing-feature

# 3. Make changes and test
npm run test
npm run lint

# 4. Commit with conventional format
git commit -m "feat: add amazing feature"

# 5. Push and create PR
git push origin feature/amazing-feature
gh pr create
```

### Commit Message Format

```
feat: add new feature
fix: resolve bug
docs: update documentation
test: add test coverage
refactor: improve code structure
perf: optimize gas usage
chore: update dependencies
```

### Code Quality Requirements

- ✅ All tests passing (`npm run test`)
- ✅ Linting passing (`npm run lint && npm run lint:js`)
- ✅ Formatting applied (`npm run format`)
- ✅ Coverage maintained (`npm run test:coverage`)
- ✅ Gas optimized (`npm run test:gas`)

---

## 🗺️ Roadmap

### Phase 1: MVP ✅ (Completed)

- [x] Smart contract with FHE implementation
- [x] Basic reporting and verification system
- [x] Sepolia testnet deployment
- [x] Comprehensive test suite (75+ tests)
- [x] CI/CD pipeline automation
- [x] Security audit & optimization

### Phase 2: Enhanced Features 🚧 (In Progress)

- [ ] Frontend dashboard (React + Vite)
- [ ] Multi-language support (English, Spanish, Chinese)
- [ ] Mobile responsive design
- [ ] Real-time analytics visualization
- [ ] Advanced reporting filters

### Phase 3: Ecosystem Expansion 🔮 (Planned)

- [ ] Integration with IoT sensors (smart bins)
- [ ] Reward token system for participants
- [ ] Cross-chain deployment (Polygon, BSC)
- [ ] API for third-party integrations
- [ ] Decentralized oracle for data verification

### Phase 4: Enterprise Features 🔮 (Future)

- [ ] Multi-organization support
- [ ] Custom branding options
- [ ] Advanced analytics dashboard
- [ ] Compliance reporting templates
- [ ] SaaS deployment model

---

## 🏆 Achievements

- 🎖️ **Zama FHE Challenge Participant** - Demonstrating practical FHE applications
- 📊 **95%+ Test Coverage** - Comprehensive quality assurance
- ⚡ **12-17% Gas Savings** - Optimized for production efficiency
- 🔒 **35+ Security Rules** - Enterprise-grade security standards
- 📚 **3000+ Documentation Lines** - Complete developer resources
- 🚀 **Production Ready** - Full CI/CD with automated deployment

---

## 🔗 Links

### Project Resources

- **GitHub Repository**: [ConfidentialWasteRecycling](https://github.com/DixieMetz/ConfidentialWasteRecycling)
- **Live Demo**: [confidential-waste-recycling.vercel.app](https://confidential-waste-recycling.vercel.app/)
- **Contract Explorer**: [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x6a65Ea0Ce4F2fc31acFA2722d0153145dc48Cc83)

### Zama Ecosystem

- **Zama Documentation**: [docs.zama.ai](https://docs.zama.ai)
- **FHEVM SDK**: [github.com/zama-ai/fhevm](https://github.com/zama-ai/fhevm)
- **fhEVM Solidity**: [github.com/zama-ai/fhevm-solidity](https://github.com/zama-ai/fhevm-solidity)
- **Zama Community**: [discord.gg/zama](https://discord.gg/zama)

### Ethereum Resources

- **Sepolia Testnet**: [sepolia.dev](https://sepolia.dev)
- **Sepolia Faucet**: [sepoliafaucet.com](https://sepoliafaucet.com)
- **Etherscan**: [sepolia.etherscan.io](https://sepolia.etherscan.io)
- **Hardhat Docs**: [hardhat.org/docs](https://hardhat.org/docs)

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](./LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Confidential Waste Recycling Platform

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---

## 🙏 Acknowledgments

- **Zama Team** - For pioneering Fully Homomorphic Encryption technology
- **Ethereum Community** - For robust blockchain infrastructure
- **Hardhat Team** - For excellent development framework
- **Open Source Contributors** - For the tools that made this possible

---

## 📞 Contact & Support

- **Issues**: [GitHub Issues](https://github.com/DixieMetz/ConfidentialWasteRecycling/issues)
- **Discussions**: [GitHub Discussions](https://github.com/DixieMetz/ConfidentialWasteRecycling/discussions)
- **Email**: support@confidentialwasterecycling.com
- **Twitter**: [@ConfidentialWR](#)

---

<div align="center">

**Building a sustainable future through privacy-preserving technology** 🌱

Made with ❤️ for the Zama FHE Challenge

⭐ Star us on GitHub if you find this project useful!

</div>
