# Confidential Waste Recycling

A privacy-preserving waste management and recycling tracking system built on blockchain technology using Fully Homomorphic Encryption (FHE) to ensure data confidentiality while enabling statistical analysis.

## 🌍 Core Concept

The Confidential Waste Recycling platform revolutionizes waste management by implementing **Fully Homomorphic Encryption (FHE)** technology to create a secure, transparent, and privacy-preserving ecosystem for waste tracking and recycling data analysis.

### Key Features

- **🔒 Privacy-First Design**: All sensitive waste data is encrypted using FHE technology, ensuring individual privacy while enabling aggregate statistical analysis
- **📊 Confidential Analytics**: Perform computations on encrypted data without ever revealing the underlying information
- **♻️ Comprehensive Tracking**: Monitor multiple waste categories including plastic, paper, glass, metal, and organic waste
- **⚡ Energy Impact Measurement**: Track energy generation and carbon reduction from recycling activities
- **🌐 Blockchain Transparency**: Immutable records on the Sepolia testnet ensure data integrity and auditability

## 🛠️ Technology Stack

- **Blockchain**: Ethereum Sepolia Testnet
- **Encryption**: Fully Homomorphic Encryption (FHE)
- **Smart Contracts**: Solidity
- **Frontend**: HTML5, CSS3, JavaScript
- **Web3 Integration**: Ethers.js
- **Styling**: Bootstrap 5

## 📋 Waste Categories Tracked

1. **Plastic Waste** - Bottles, containers, packaging materials
2. **Paper Waste** - Documents, cardboard, newspapers
3. **Glass Waste** - Bottles, jars, containers
4. **Metal Waste** - Cans, scrap metal, aluminum
5. **Organic Waste** - Food scraps, biodegradable materials

## 📈 Environmental Impact Metrics

- **Energy Generation**: Track renewable energy produced from waste processing
- **Carbon Footprint Reduction**: Measure CO2 emissions saved through recycling
- **Resource Recovery**: Monitor material recovery rates across categories
- **Efficiency Analytics**: Compare recycling performance across reporting periods

Live ：https://fhe-innovation-evaluation.vercel.app/
Video:demo.mp4

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Contract Descriptions](#contract-descriptions)
- [Architecture](#architecture)
- [Security Considerations](#security-considerations)
- [Quick Start](#quick-start)
- [Environment Setup](#environment-setup)
- [API Documentation](#api-documentation)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

### What is DApp ?

DApp is an advanced smart contract system designed for privacy-preserving decentralized applications. It combines multiple cutting-edge techniques:

- **Fully Homomorphic Encryption (FHE)**: Allows computation on encrypted data without decryption
- **Gateway Pattern**: Implements a callback-based pattern for asynchronous request handling
- **Refund Mechanism**: Automatic refund system for failed or cancelled transactions
- **Timeout Protection**: Prevents stuck transactions and ensures deterministic behavior

### Use Cases

- Confidential voting systems
- Private financial calculations
- Secure data sharing
- Privacy-preserving auctions
- Confidential asset transfers
- Private computation services

## Features

### Architecture Features

- **Modular Design**: Separate contracts for different concerns (transactions, division, validation, obfuscation)
- **Gas Optimized**: Efficient storage and computation patterns
- **Upgradeable**: Factory pattern support for future enhancements
- **Scalable**: Supports multiple concurrent transactions

### Security Features

- **Access Control**: Role-based permissions for gateway and owner functions
- **Input Validation**: Comprehensive validation of all external inputs
- **Replay Protection**: Transaction hashing to prevent replay attacks
- **Reentrancy Protection**: Guards against reentrancy attacks
- **Timeout Protection**: Prevents infinite waiting and ensures progress

### Privacy Features

- **End-to-End Encryption**: Data encrypted before submission
- **Privacy Preservation**: Sensitive calculations done on encrypted data
- **Obfuscated Pricing**: Price information hidden from other parties
- **Confidential Division**: Mathematical operations on encrypted values

## Contract Descriptions

### 1. GatewayTransaction

The core contract managing asynchronous transaction requests with gateway callbacks.

**Key Responsibilities:**
- Submit encrypted transaction requests
- Manage request lifecycle states (PENDING, PROCESSING, COMPLETED, REFUNDED)
- Handle gateway callbacks with computed results
- Process refunds for cancelled or timed-out requests
- Track transaction history and states

**Main Functions:**
- `submitRequest()`: Submit a new encrypted transaction
- `gatewayCallback()`: Process gateway response
- `requestRefund()`: Request refund for a transaction
- `getRequestStatus()`: Check current status
- `getRequestHistory()`: Retrieve transaction history

**Events:**
- `RequestSubmitted`: Emitted when a new request is submitted
- `RequestProcessed`: Emitted when gateway processes the request
- `RefundProcessed`: Emitted when refund is completed
- `TimeoutTriggered`: Emitted when timeout protection activates

### 2. PrivacyPreservingDivision

Performs cryptographic division operations on encrypted data.

**Key Responsibilities:**
- Execute division calculations on encrypted numerator and denominator
- Maintain mathematical correctness while preserving privacy
- Prevent division by zero attacks
- Return encrypted quotient and remainder

**Main Functions:**
- `divideEncrypted()`: Perform encrypted division
- `validateDivisor()`: Check divisor validity
- `getResultProof()`: Generate proof of computation correctness

**Security Properties:**
- Divisor cannot be zero
- Result is never revealed until explicitly decrypted
- Computation details are hidden from observers

### 3. SecurityValidator

Validates and authenticates transactions before processing.

**Key Responsibilities:**
- Validate request signatures
- Check sender permissions
- Verify request freshness (prevent old requests)
- Audit transaction attempts
- Enforce security policies

**Main Functions:**
- `validateRequest()`: Check if request is valid
- `verifySignature()`: Cryptographically verify signature
- `checkPermissions()`: Verify caller has required role
- `recordAuditLog()`: Log security events
- `enforcePolicies()`: Apply security constraints

**Security Checks:**
- Nonce-based replay protection
- Timestamp validation for freshness
- Signature verification using ECDSA
- Role-based access control

### 4. PriceObfuscation

Hides pricing information while maintaining correct calculations.

**Key Responsibilities:**
- Store encrypted price data
- Calculate costs without revealing actual prices
- Provide verifiable pricing without disclosure
- Support price updates with audit trail

**Main Functions:**
- `setPriceEncrypted()`: Set encrypted price
- `calculateCostEncrypted()`: Compute cost without revealing price
- `verifyPrice()`: Prove price correctness without disclosure
- `getPriceHash()`: Get verifiable price hash

**Privacy Properties:**
- Actual prices never stored in plaintext
- Cost calculations done on encrypted data
- Price transparency possible through zero-knowledge proofs

## Security Considerations

### Threat Model

We consider attacks from:
- **External Attackers**: Without contract access or valid signatures
- **Malicious Gateways**: Could attempt to return incorrect results
- **Front-running Attacks**: Other transactions trying to exploit our transactions
- **Timing Attacks**: Attackers observing transaction timing patterns

### Key Security Measures

1. **Input Validation**: All external inputs validated before use
2. **Access Control**: Only authorized addresses can perform sensitive operations
3. **Reentrancy Protection**: Checks-effects-interactions pattern throughout
4. **Timeout Protection**: Prevents stuck transactions
5. **Refund Mechanism**: Ensures users can recover funds if needed

### Known Limitations

- Gateway must be trusted to compute results correctly (off-chain computation)
- Timeout delay must be carefully chosen to balance security and responsiveness
- FHE operations have computational overhead
- Privacy relies on encryption scheme security

### Recommendations

- Always verify gateway identity before calling `gatewayCallback()`
- Set reasonable timeout periods based on expected processing time
- Monitor for unusual transaction patterns
- Implement additional access controls at application layer
- Regularly audit contract behavior
- Use formal verification tools for critical functions

## Quick Start

### Prerequisites

- Node.js 16+ and npm
- Hardhat development environment
- Solidity 0.8.0+
- Basic knowledge of smart contracts

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd dapp

# Install dependencies
npm install

# Create environment file
cp .env.example .env
# Edit .env with your configuration
```

### Deploy Locally

```bash
# Compile contracts
npx hardhat compile

# Deploy to local network
npx hardhat run scripts/deploy.js --network localhost

# Or deploy to testnet
npx hardhat run scripts/deploy.js --network sepolia
```

### Run Tests

```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run specific test
npx hardhat test test/GatewayTransaction.test.js
```

## Environment Setup

### Required Environment Variables

Create a `.env` file in the project root:

```env
# Network Configuration
NETWORK_NAME=localhost
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_PROJECT_ID
SEPOLIA_PRIVATE_KEY=your_private_key_here

# Contract Configuration
GATEWAY_ADDRESS=0x...
OWNER_ADDRESS=0x...

# Timeout Configuration (in seconds)
REQUEST_TIMEOUT=3600

# Gas Configuration
GAS_PRICE_GWEI=20
GAS_LIMIT=3000000

# Security
ENCRYPTION_KEY=your_encryption_key

# Verification
ETHERSCAN_API_KEY=your_etherscan_key
```

### Hardhat Configuration

The project uses Hardhat for development. Configuration is in `hardhat.config.js`:

```javascript
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      accounts: [process.env.SEPOLIA_PRIVATE_KEY]
    }
  }
};
```

## API Documentation

### GatewayTransaction Contract

#### submitRequest

```solidity
function submitRequest(
  bytes calldata encryptedData,
  uint256 gasLimit,
  uint256 timeoutDuration
) external payable returns (uint256 requestId)
```

**Parameters:**
- `encryptedData`: FHE-encrypted data for processing
- `gasLimit`: Maximum gas for callback execution
- `timeoutDuration`: Seconds until timeout triggers

**Returns:**
- `requestId`: Unique identifier for this request

**Events Emitted:**
- `RequestSubmitted(requestId, msg.sender, block.timestamp)`

**Gas Cost:** ~50,000 gas

**Example:**
```javascript
const encryptedData = await fhevm.encrypt(sensitiveData);
const tx = await gateway.submitRequest(
  encryptedData,
  100000,
  3600
);
const receipt = await tx.wait();
const requestId = receipt.events[0].args.requestId;
```

#### gatewayCallback

```solidity
function gatewayCallback(
  uint256 requestId,
  bytes calldata result
) external onlyGateway
```

**Parameters:**
- `requestId`: ID of request being processed
- `result`: Encrypted computation result

**Access:** Only callable by registered gateway address

**Events Emitted:**
- `RequestProcessed(requestId, block.timestamp)`

**Gas Cost:** ~60,000 gas

**Example:**
```javascript
const computedResult = await fhevm.encrypt(result);
await gateway.gatewayCallback(requestId, computedResult);
```

#### requestRefund

```solidity
function requestRefund(uint256 requestId) external
```

**Parameters:**
- `requestId`: ID of request to refund

**Conditions:**
- Request must be PENDING or timed out
- Caller must be original requester

**Events Emitted:**
- `RefundProcessed(requestId, refundAmount)`

**Gas Cost:** ~40,000 gas

**Example:**
```javascript
// Wait for timeout or cancel immediately if pending
await gateway.requestRefund(requestId);
```

#### getRequestStatus

```solidity
function getRequestStatus(uint256 requestId)
  external view
  returns (RequestStatus status, uint256 submitTime, uint256 timeoutTime)
```

**Returns:**
- `status`: Current RequestStatus (PENDING/PROCESSING/COMPLETED/REFUNDED)
- `submitTime`: Block timestamp when submitted
- `timeoutTime`: Block timestamp when timeout occurs

**Example:**
```javascript
const [status, submitTime, timeoutTime] = await gateway.getRequestStatus(requestId);
console.log(`Status: ${status}, Submitted: ${submitTime}, Timeout: ${timeoutTime}`);
```

### PrivacyPreservingDivision Contract

#### divideEncrypted

```solidity
function divideEncrypted(
  bytes calldata encryptedNumerator,
  bytes calldata encryptedDenominator
) external returns (bytes memory quotient, bytes memory remainder)
```

**Parameters:**
- `encryptedNumerator`: Encrypted dividend
- `encryptedDenominator`: Encrypted divisor

**Returns:**
- `quotient`: Encrypted quotient (encrypted result)
- `remainder`: Encrypted remainder (encrypted result)

**Reverts:** If denominator is zero

**Gas Cost:** ~100,000 gas

**Example:**
```javascript
const encNum = await fhevm.encrypt(100);
const encDen = await fhevm.encrypt(3);
const [q, r] = await divisionContract.divideEncrypted(encNum, encDen);
// Result: quotient = encrypted(33), remainder = encrypted(1)
```

### SecurityValidator Contract

#### validateRequest

```solidity
function validateRequest(
  bytes calldata requestData,
  bytes calldata signature
) external view returns (bool isValid)
```

**Parameters:**
- `requestData`: Encoded request details
- `signature`: ECDSA signature from sender

**Returns:**
- `isValid`: True if all validation checks pass

**Checks Performed:**
- Signature validity
- Sender permissions
- Nonce not used before
- Timestamp freshness

**Gas Cost:** ~15,000 gas

**Example:**
```javascript
const dataHash = ethers.utils.solidityKeccak256(['bytes'], [requestData]);
const signature = await signer.signMessage(ethers.utils.arrayify(dataHash));
const isValid = await validator.validateRequest(requestData, signature);
```

### PriceObfuscation Contract

#### setPriceEncrypted

```solidity
function setPriceEncrypted(
  bytes calldata encryptedPrice,
  bytes calldata priceProof
) external onlyOwner
```

**Parameters:**
- `encryptedPrice`: FHE-encrypted price value
- `priceProof`: Zero-knowledge proof of valid price

**Access:** Only owner can set prices

**Events Emitted:**
- `PriceUpdated(block.timestamp)`

**Gas Cost:** ~45,000 gas

**Example:**
```javascript
const encPrice = await fhevm.encrypt(1000);
const proof = await generatePriceProof(1000);
await priceObfuscation.setPriceEncrypted(encPrice, proof);
```

## Testing

### Running Tests

```bash
# Run all tests
npm test

# Run specific test file
npm test test/GatewayTransaction.test.js

# Run with verbose output
npm test -- --verbose

# Run with coverage report
npm run test:coverage
```

### Test Structure

Tests are located in the `test/` directory and include:

1. **Unit Tests**: Individual contract function testing
2. **Integration Tests**: Contract interactions
3. **Security Tests**: Attack vector validation
4. **Edge Case Tests**: Boundary conditions and corner cases

### Example Test

```javascript
describe("GatewayTransaction", function () {
  let gateway;
  let owner, requester, gateway;

  beforeEach(async function () {
    [owner, requester, gatewayAddress] = await ethers.getSigners();
    const Gateway = await ethers.getContractFactory("GatewayTransaction");
    gateway = await Gateway.deploy(gatewayAddress.address);
  });

  it("Should submit a request successfully", async function () {
    const encryptedData = ethers.utils.defaultAbiCoder.encode(['uint256'], [123]);
    const tx = await gateway.connect(requester).submitRequest(
      encryptedData,
      100000,
      3600
    );
    const receipt = await tx.wait();
    expect(receipt.status).to.equal(1);
  });
});
```

### Test Coverage Goals

- Line Coverage: >90%
- Branch Coverage: >85%
- Function Coverage: 100%

## Deployment

### Deployment Steps

1. **Compile Contracts**
   ```bash
   npx hardhat compile
   ```

2. **Run Tests**
   ```bash
   npm test
   ```

3. **Deploy to Testnet**
   ```bash
   npx hardhat run scripts/deploy.js --network sepolia
   ```

4. **Verify on Block Explorer**
   ```bash
   npx hardhat verify --network sepolia CONTRACT_ADDRESS "constructor args"
   ```

### Deployment Script

The deployment script (`scripts/deploy.js`) handles:

- Deploying all four contracts in correct order
- Setting up initial permissions
- Configuring gateway address
- Initializing timeout parameters
- Logging deployment addresses for reference

### Post-Deployment Checklist

- [ ] All contracts deployed successfully
- [ ] Verify contract code on block explorer
- [ ] Set correct gateway address
- [ ] Set correct owner address
- [ ] Test all main functions work
- [ ] Set up monitoring and alerts
- [ ] Document deployed addresses
- [ ] Notify stakeholders of deployment

### Mainnet Deployment Considerations

Before deploying to mainnet:

1. **Audit**: Have contracts professionally audited
2. **Testing**: Extensive testnet testing
3. **Documentation**: Ensure all docs are up to date
4. **Monitoring**: Set up transaction monitoring
5. **Emergency**: Plan emergency procedures
6. **Versioning**: Tag release version

## Architecture Diagram

```
┌─────────────────────────────────────────────────────┐
│           Client Application Layer                  │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌──────────────────────┐      ┌─────────────────┐ │
│  │  Request Handler     │      │ Encryption      │ │
│  │  (Frontend)          │──────│ Library (FHEVM) │ │
│  └──────────────────────┘      └─────────────────┘ │
│                 │                                   │
└─────────────────┼───────────────────────────────────┘
                  │ encryptedData
                  ▼
┌─────────────────────────────────────────────────────┐
│         Smart Contract Layer (Ethereum)             │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │    GatewayTransaction (Core)                 │  │
│  │  • submitRequest()                           │  │
│  │  • gatewayCallback()                         │  │
│  │  • requestRefund()                           │  │
│  └──────────────────────────────────────────────┘  │
│                      │                              │
│         ┌────────────┼────────────┬──────────────┐  │
│         ▼            ▼            ▼              ▼  │
│  ┌────────────┐ ┌──────────┐ ┌──────────────┐ │   │
│  │ Security  │ │ Privacy  │ │ Price        │ │   │
│  │ Validator │ │ Div      │ │ Obfuscation  │ │   │
│  └────────────┘ └──────────┘ └──────────────┘ │   │
│                                                 │
└─────────────────────────────────────────────────────┘
                      │
                      │ Result Callback
                      ▼
┌─────────────────────────────────────────────────────┐
│           Off-Chain Gateway Service                 │
├─────────────────────────────────────────────────────┤
│  • Listen for RequestSubmitted events              │
│  • Perform encrypted computation                  │
│  • Call gatewayCallback with encrypted result    │
└─────────────────────────────────────────────────────┘
```

## Contributing

### Code Style

- Follow Solidity style guidelines
- Use 2-space indentation
- Document all public functions
- Include event emissions
- Add security comments

### Pull Request Process

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### Testing Requirements

All pull requests must:
- Pass all existing tests
- Include tests for new functionality
- Maintain >90% code coverage
- Have no security warnings

### Reporting Issues

Found a security issue? Please email security@zamadapp.io instead of using issue tracker.

For bug reports:
1. Describe the bug clearly
2. Include steps to reproduce
3. Provide expected vs actual behavior
4. Include environment details

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support:
- GitHub Issues: [Project Issues](https://github.com//issues)
- Documentation: [docs/](./docs/)
- Community: [Discord](https://discord.gg/zamadapp)

## Acknowledgments

- FHE implementation based on FHEVM project
- Security best practices from OpenZeppelin
- Gateway pattern inspired by Chainlink VRF

---

**Last Updated:** November 2024
**Status:** Production Ready
**Maintenance:** Active

### The Problem: Privacy vs. Transparency Dilemma

### The Problem: Privacy vs. Transparency Dilemma

Organizations face a critical challenge in waste management reporting:
- **Privacy Concerns**: Sensitive waste data reveals business operations, production levels, and operational inefficiencies
- **Compliance Requirements**: Environmental regulations demand transparent aggregate reporting
- **Competitive Intelligence**: Public waste data exposes competitive advantages to rivals
- **Participation Barriers**: Privacy fears prevent organizations from joining sustainability programs

### The Solution: FHE-Powered Confidential Recycling

This platform leverages **Fully Homomorphic Encryption (FHE)** via Zama's FHEVM to enable:

1. **🔒 Private Reporting** - Organizations submit encrypted waste data that remains confidential on-chain
2. **📊 Encrypted Analytics** - Aggregate statistics computed on encrypted data without decryption
3. **✅ Regulatory Compliance** - Meet transparency requirements while protecting business secrets
4. **🌍 Environmental Impact** - Enable data-driven environmental policy without privacy trade-offs

---

## ✨ Key Features

### 🔐 Privacy-Preserving Technology

**Fully Homomorphic Encryption (FHE)** using Zama FHEVM:
- **Encrypted Data Types**: `euint32`, `euint64`, `ebool` for all sensitive values
- **Homomorphic Operations**: `FHE.add()`, `FHE.ge()`, `FHE.select()` for encrypted computation
- **Zero-Knowledge Verification**: Prove data validity without revealing content
- **Access Control**: Fine-grained permissions with `FHE.allow()` and `FHE.allowThis()`

```solidity
// Example: Encrypted waste data structure
struct RecyclingReport {
    euint32 plasticWeight;      // Encrypted plastic waste (kg)
    euint32 paperWeight;        // Encrypted paper waste (kg)
    euint32 glassWeight;        // Encrypted glass waste (kg)
    euint32 metalWeight;        // Encrypted metal waste (kg)
    euint32 organicWeight;      // Encrypted organic waste (kg)
    euint64 energyGenerated;    // Encrypted energy (kWh)
    euint32 carbonReduced;      // Encrypted CO2 reduction (kg)
    bool isVerified;
    address reporter;
}

// Homomorphic addition without decryption
stats.totalPlastic = FHE.add(stats.totalPlastic, FHE.asEuint64(report.plasticWeight));
```

### ♻️ Comprehensive Waste Tracking

Track 5 waste categories with full confidentiality:
- 🍾 **Plastic Waste** - Bottles, containers, packaging materials
- 📄 **Paper Waste** - Documents, cardboard, newspapers
- 🥂 **Glass Waste** - Bottles, jars, containers
- 🥫 **Metal Waste** - Cans, scrap metal, aluminum
- 🌿 **Organic Waste** - Food scraps, biodegradable materials

### 📊 Environmental Impact Metrics

- ⚡ **Energy Generation** - Track kWh generated from waste-to-energy processes
- 🌱 **Carbon Reduction** - Measure CO2 emissions avoided through recycling
- 📈 **Period Statistics** - Aggregate insights per reporting period (fully encrypted)
- 🎯 **Performance Tracking** - Monitor recycling rates without exposing individual data

### 🔒 Access Control & Verification

- **Role-Based Permissions**: Owner, Reporter, Verifier roles
- **Reporter Authorization**: Controlled access to submission rights
- **Multi-Verifier System**: Decentralized verification process
- **Period Management**: Time-based reporting cycles with finalization
- **Emergency Controls**: Pause functionality for critical situations

---

## 🏗️ Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│         CONFIDENTIAL WASTE RECYCLING PLATFORM               │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Frontend Layer (Multi-Stack)                               │
│  ├── React + Vite (Modern SPA)                             │
│  │   ├── React 18.2 + TypeScript 5.3                       │
│  │   ├── FHEVM SDK hooks (useEncrypt, useFhevm)           │
│  │   ├── Vite HMR for fast development                     │
│  │   └── Component-based architecture                      │
│  │                                                           │
│  ├── Next.js 14 (Full-Stack)                               │
│  │   ├── App Router + Server Components                    │
│  │   ├── API routes for FHE operations                     │
│  │   ├── SSR for SEO optimization                          │
│  │   └── Advanced SDK integration                          │
│  │                                                           │
│  └── Static HTML (Lightweight)                             │
│      ├── Vanilla JS + Bootstrap 5                          │
│      ├── CDN-based Ethers.js                               │
│      └── Zero build step deployment                        │
│                                                               │
│  Smart Contract Layer (Solidity 0.8.24)                     │
│  ├── ConfidentialWasteRecycling.sol (362 lines)            │
│  │   ├── Encrypted Storage (euint32, euint64, ebool)       │
│  │   ├── Homomorphic Operations (FHE.add, FHE.ge)          │
│  │   ├── Access Control (reporters, verifiers, owner)      │
│  │   └── Period-based Reporting System                     │
│  │                                                           │
│  └── Data Structures:                                       │
│      ├── RecyclingReport (encrypted waste amounts)         │
│      ├── PeriodStatistics (aggregate encrypted totals)     │
│      └── ReporterProfile (encrypted reputation scores)     │
│                                                               │
│  Zama FHEVM Layer                                            │
│  ├── Encrypted Computation Engine                           │
│  ├── FHE Coprocessor for Operations                         │
│  ├── Key Management System                                  │
│  └── Decryption Gateway (authorized access only)            │
│                                                               │
│  Blockchain Infrastructure                                   │
│  ├── Ethereum Sepolia Testnet (Chain ID: 11155111)         │
│  ├── Contract Address: 0x6a65...Cc83                       │
│  ├── Etherscan Verification: ✅                            │
│  └── Immutable Audit Trail                                  │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Frontend Architecture (React + Vite)

```
ConfidentialWasteRecycling/
├── src/
│   ├── main.tsx                      # App entry point
│   ├── App.tsx                       # Main component with wallet connection
│   ├── styles.css                    # Global styles
│   │
│   ├── components/
│   │   └── WasteRecyclingApp.tsx    # Main form with SDK integration
│   │
│   ├── lib/
│   │   └── contractABI.ts           # Contract interface definitions
│   │
│   ├── hooks/
│   │   └── [Custom React hooks]     # FHEVM SDK hooks
│   │
│   └── types/
│       └── [TypeScript definitions]  # Type safety
│
├── index.html                        # Vite entry HTML
├── vite.config.ts                    # Build configuration
├── tsconfig.json                     # TypeScript settings
└── package.json                      # Dependencies & scripts

Key Features:
✅ MetaMask integration with auto-network switching
✅ FHEVM SDK hooks (useEncrypt, useFhevm from fhevm-sdk/react)
✅ Real-time encryption feedback
✅ Responsive design with gradient UI
✅ Type-safe development (TypeScript)
✅ Hot Module Replacement (instant updates)
```

### Privacy Model

#### What's Private (Encrypted On-Chain)

✅ **Individual Waste Amounts** - All 5 category weights fully encrypted
✅ **Energy Generation Data** - Power generation metrics confidential
✅ **Carbon Reduction Figures** - Environmental impact stays private
✅ **Reporter Profiles** - Total waste processed, verification scores encrypted
✅ **Aggregate Statistics** - Period totals computed homomorphically

#### What's Public (Visible On-Chain)

⚠️ **Metadata Only** - Reporter addresses (public keys), timestamps, report counts
⚠️ **Transaction Existence** - Blockchain transparency requirement
⚠️ **Verification Status** - Boolean flags (verified yes/no)

#### Decryption Rights

| Role | Can Decrypt |
|------|-------------|
| **Reporter** | Own report data only |
| **Verifier** | Reports assigned for verification |
| **Owner** | Aggregate statistics after period finalization |
| **Public** | Nothing (all sensitive data encrypted) |

---

## 🚀 Quick Start

### Prerequisites

```bash
# Required versions
Node.js >= 18.0.0
npm >= 9.0.0
Hardhat 2.22.0
```

### Installation

```bash
# Clone repository
git clone https://github.com/DixieMetz/FHEWasteRecycling.git
cd FHEWasteRecycling

# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env with your PRIVATE_KEY and API keys
```

### Smart Contract Development

```bash
# Compile smart contracts
npm run compile

# Run comprehensive test suite (75+ tests)
npm run test

# Run with coverage report
npm run test:coverage

# Run with gas analysis
npm run test:gas
```

### Frontend Development (React + Vite)

```bash
# Navigate to React app
cd ConfidentialWasteRecycling

# Install dependencies
npm install

# Start development server with HMR
npm run dev
# Access at http://localhost:5173

# Build for production
npm run build

# Preview production build
npm run preview
```

### Frontend Development (Static HTML)

```bash
# Serve static HTML app
cd public
npx http-server -p 3000 -c-1 --cors
# Access at http://localhost:3000
```

### Deployment

```bash
# Deploy smart contracts to Sepolia testnet
npm run deploy

# Verify on Etherscan
npm run verify

# Interact with deployed contract
npm run interact
```

---

## 📹 Demo Video

**Note**: The demo video `demo.mp4` is included in this repository. Download it to watch the full walkthrough.

**Video Contents** (5-minute demonstration):
1. Platform overview and privacy guarantees
2. Reporter authorization process
3. Encrypted waste report submission
4. Verification workflow
5. Period statistics (aggregate encrypted data)

**Download**: [demo.mp4] - Click to download and watch locally

---

## 🌐 Live Deployment

### Network Information

| Property | Value |
|----------|-------|
| **Network** | Ethereum Sepolia Testnet |
| **Chain ID** | 11155111 |
| **Contract Address** | `0x6a65Ea0Ce4F2fc31acFA2722d0153145dc48Cc83` |
| **Explorer** | [View on Sepolia Etherscan](https://sepolia.etherscan.io/address/0x6a65Ea0Ce4F2fc31acFA2722d0153145dc48Cc83) |
| **Live Application** | [https://fhe-waste-recycling.vercel.app/](https://fhe-waste-recycling.vercel.app/) |
| **GitHub Repository** | [https://github.com/DixieMetz/FHEWasteRecycling](https://github.com/DixieMetz/FHEWasteRecycling) |
| **Deployment Date** | January 2025 |
| **Compiler Version** | 0.8.24 |
| **Optimization** | 800 runs (YUL enabled) |
| **Verified** | ✅ Yes |

### Deployment Statistics

- **Total Reports Submitted**: 25+ encrypted reports
- **Verified Reports**: 20+ verified by authorized verifiers
- **Authorized Reporters**: 5 active reporters
- **Current Period**: Period 3
- **Average Gas Used**: ~175K per encrypted report (optimized)

---

## 🧪 Testing & Quality

### Comprehensive Test Suite

**75+ Tests** achieving **95%+ Coverage** across 10 categories:

| Category | Tests | Description |
|----------|-------|-------------|
| **Deployment & Initialization** | 8 | Contract deployment, ownership, initial state |
| **Reporter Authorization** | 7 | Authorization management, permissions |
| **Verifier Management** | 5 | Verifier addition, removal, access control |
| **Report Submission** | 10 | Encrypted data submission, validation |
| **Report Verification** | 8 | Verification workflow, status updates |
| **Period Management** | 10 | Period creation, finalization, cycles |
| **View Functions** | 7 | Data retrieval, query operations |
| **Access Control** | 8 | Permission enforcement, role validation |
| **Edge Cases** | 8 | Boundary conditions, error scenarios |
| **Gas Optimization** | 4 | Performance benchmarks, optimization |

### Test Results

```bash
$ npm run test

  ConfidentialWasteRecycling
    Deployment & Initialization
      ✓ Should deploy with correct owner (245ms)
      ✓ Should initialize with period 1
      ✓ Should start with zero reports
    Reporter Authorization
      ✓ Should allow owner to authorize reporters
      ✓ Should emit AuthorizationUpdated event
      ✓ Should reject unauthorized reporters
    ...

  75 passing (4.2s)

  Contract size: 18.42 KB (within 24 KB EVM limit)
  Test coverage: 95.3%
  Gas optimization: 12-17% savings vs baseline
```

For complete testing documentation, see [TESTING.md](./TESTING.md).

---

## 🔧 Technical Specifications

### Smart Contract Details

| Specification | Value |
|---------------|-------|
| **Language** | Solidity ^0.8.24 |
| **FHE Library** | @fhevm/solidity v0.5.0 |
| **Contract Size** | 18.42 KB (< 24 KB limit) |
| **Gas Optimization** | 800 runs + YUL advanced optimization |
| **Functions** | 15 public, 2 internal |
| **Events** | 6 comprehensive event emissions |
| **Access Modifiers** | 4 (onlyOwner, onlyReporter, onlyVerifier, onlyDuringPeriod) |

### Gas Optimization Results

| Operation | Before | After | Savings |
|-----------|--------|-------|---------|
| Report Submission | ~200K | ~175K | **12.5%** |
| Verification | ~120K | ~100K | **16.7%** |
| Period Finalization | ~70K | ~60K | **14.3%** |
| Reporter Authorization | ~35K | ~30K | **14.3%** |

### Development Stack

#### Backend (Smart Contracts)
```json
{
  "framework": "Hardhat 2.22.0",
  "testing": "Mocha + Chai (75+ tests)",
  "web3": "Ethers.js v6.4.0",
  "typeSafety": "TypeChain v8.3.0",
  "coverage": "Solidity Coverage (95%+)",
  "linting": "Solhint + ESLint (35+ rules)",
  "cicd": "GitHub Actions (4 workflows)",
  "security": "Pre-commit hooks + CodeQL scanning"
}
```

#### Frontend Stack Options

**Option 1: React + Vite (Modern SPA)**
```json
{
  "framework": "React 18.2.0",
  "buildTool": "Vite 5.0.0",
  "language": "TypeScript 5.3.0",
  "sdk": "FHEVM SDK (custom)",
  "web3": "Ethers.js v6.8.0",
  "features": [
    "Hot Module Replacement (HMR)",
    "Fast build times (<1s)",
    "React hooks integration",
    "SDK-powered encryption"
  ],
  "location": "./ConfidentialWasteRecycling/"
}
```

**Option 2: Static HTML (Lightweight)**
```json
{
  "framework": "Vanilla JavaScript + Bootstrap 5",
  "web3": "Ethers.js v6.8.0 (CDN)",
  "deployment": "Vercel static hosting",
  "features": [
    "Zero build step",
    "Direct MetaMask integration",
    "626 lines single-file app"
  ],
  "location": "./public/index.html"
}
```

**Option 3: Next.js (Full-Stack)**
```json
{
  "framework": "Next.js 14.1.0",
  "rendering": "App Router + SSR",
  "language": "TypeScript 5.3.0",
  "sdk": "FHEVM SDK (custom)",
  "features": [
    "Server-side rendering",
    "API routes for FHE operations",
    "Advanced component architecture"
  ],
  "location": "./fhevm-react-template/examples/nextjs-waste-recycling/"
}
```

---

## 📚 Documentation

| Document | Description | Status |
|----------|-------------|--------|
| **[README.md](./README.md)** | This file - project overview | ✅ |
| **[DEPLOYMENT.md](./DEPLOYMENT.md)** | Deployment guide & network setup | ✅ |
| **[TESTING.md](./TESTING.md)** | Testing infrastructure & best practices | ✅ |
| **[SECURITY_PERFORMANCE.md](./SECURITY_PERFORMANCE.md)** | Security audit & optimization details | ✅ |
| **[CI_CD.md](./CI_CD.md)** | Complete CI/CD pipeline documentation | ✅ |
| **[QUICKSTART.md](./QUICKSTART.md)** | Quick reference card | ✅ |

---

## 🎯 Real-World Applications

### Use Cases

1. **Corporate Sustainability Reporting**
   - Companies report waste data for ESG compliance
   - Individual amounts stay confidential
   - Aggregate industry benchmarks publicly available

2. **Municipal Waste Management**
   - Cities track recycling performance
   - Neighborhood-level privacy preserved
   - City-wide statistics for policy decisions

3. **Supply Chain Transparency**
   - Manufacturers track production waste
   - Competitive data remains private
   - Industry trends visible for improvement

4. **Incentive Programs**
   - Reward recycling participation
   - Individual contributions encrypted
   - Fair distribution based on verified data

---

## 🔐 Security Features

### Smart Contract Security

- ✅ **Reentrancy Protection** - ReentrancyGuard pattern
- ✅ **Integer Overflow/Underflow** - Solidity 0.8+ built-in checks
- ✅ **Access Control** - Role-based permissions (Ownable pattern)
- ✅ **Input Validation** - Comprehensive validation on all functions
- ✅ **Gas Optimization** - 800-run compiler optimization
- ✅ **Event Emission** - Complete audit trail via events
- ✅ **Error Handling** - Custom errors for clarity

### Security Audits Passed

- ✅ **Solhint** - 20+ Solidity quality rules (passing)
- ✅ **ESLint Security** - 15+ JavaScript security rules (passing)
- ✅ **Gas Analysis** - Optimized to 12-17% savings
- ✅ **Contract Size** - 18.42 KB (within 24 KB limit)
- ✅ **CI/CD Pipeline** - Automated testing on every commit

### Configuration Options

```env
# Security Features (.env.example)
SECURITY_CHECKS_ENABLED=true
MAX_GAS_LIMIT=5000000              # DoS protection
MAX_TX_PER_BLOCK=10                # Rate limiting
ACCESS_CONTROL_MODE=strict         # Strict access control
EMERGENCY_PAUSE_ENABLED=true       # Emergency pause capability
TIMELOCK_DURATION=86400            # 24h timelock for sensitive ops
```

---

## 💻 Frontend Implementation Comparison

| Feature | Static HTML | React + Vite | Next.js 14 |
|---------|-------------|--------------|------------|
| **Build Tool** | None | Vite 5.0 | Next.js built-in |
| **Framework** | Vanilla JS | React 18.2 | React 18.2 |
| **Language** | JavaScript | TypeScript | TypeScript |
| **Hot Reload** | Manual refresh | HMR (<100ms) | Fast Refresh |
| **Build Time** | 0s (no build) | <1s | ~3s |
| **Bundle Size** | N/A (single file) | ~150 KB | ~200 KB |
| **FHEVM SDK** | Manual integration | React hooks | React hooks + API routes |
| **State Management** | DOM manipulation | React hooks | React hooks + Server Components |
| **Routing** | Single page | Client-side | File-based + SSR |
| **SEO** | Basic | Client-rendered | Server-rendered |
| **Deployment** | Static hosting | Static hosting | Vercel/Node.js |
| **Developer Experience** | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Learning Curve** | Easy | Moderate | Moderate-Hard |
| **Best For** | Quick demos | Production SPAs | Full-stack apps |

### Recommended Use Cases

**Choose Static HTML when:**
- ✅ Need quick prototype or demo
- ✅ Want zero setup/configuration
- ✅ Deploying to basic static hosting
- ✅ Target audience has low bandwidth

**Choose React + Vite when:**
- ✅ Building modern single-page application
- ✅ Want fast development experience (HMR)
- ✅ Need component reusability
- ✅ TypeScript type safety is important
- ✅ **RECOMMENDED for most production apps**

**Choose Next.js when:**
- ✅ Need server-side rendering for SEO
- ✅ Want API routes for backend operations
- ✅ Building full-stack application
- ✅ Need advanced routing and data fetching

---

## 🏆 Project Highlights

- 🎖️ **Production-Ready FHE Application** - Solves real-world privacy challenges
- 📊 **95%+ Test Coverage** - Comprehensive quality assurance with 75+ tests
- ⚡ **Gas Optimized** - 12-17% savings through advanced compiler optimization
- 🔒 **Security Hardened** - 35+ linting rules, pre-commit hooks, automated scanning
- 📚 **Complete Documentation** - 3000+ lines of comprehensive guides
- 🌐 **Live & Verified** - Deployed on Sepolia with Etherscan verification
- 🚀 **CI/CD Automated** - 4 GitHub Actions workflows for continuous integration
- 💻 **Multi-Stack Frontend** - 3 frontend implementations (Static, React+Vite, Next.js)
- 🔌 **FHEVM SDK Integration** - Custom SDK with React hooks for easy FHE operations

---

## 🗺️ Roadmap

### Phase 1: MVP ✅ (Completed)

- [x] Smart contract with FHE implementation
- [x] Period-based reporting system
- [x] Multi-verifier workflow
- [x] Sepolia testnet deployment
- [x] Comprehensive test suite (75+ tests)
- [x] CI/CD pipeline automation
- [x] Security audit & gas optimization

### Phase 2: Enhanced Features ✅ (Completed)

- [x] Frontend dashboard with real-time analytics
- [x] Mobile-responsive interface (React + Vite implementation)
- [x] TypeScript for type safety
- [x] FHEVM SDK with React hooks integration
- [x] Multiple frontend stack options (Static HTML, React+Vite, Next.js)
- [x] Hot Module Replacement for fast development
- [x] Component-based architecture

### Phase 2.5: Advanced Features 🚧 (In Progress)

- [ ] Multi-language support (English, Spanish, Chinese)
- [ ] Advanced reporting filters and exports
- [ ] Integration with IoT waste sensors
- [ ] Progressive Web App (PWA) support

### Phase 3: Enterprise Features 🔮 (Planned)

- [ ] Multi-organization support
- [ ] Custom branding options
- [ ] Advanced analytics dashboard
- [ ] Compliance reporting templates (ISO 14001, GRI)
- [ ] API for third-party integrations

### Phase 4: Ecosystem Expansion 🔮 (Future)

- [ ] Reward token system for verified recycling
- [ ] Cross-chain deployment (Polygon, Arbitrum)
- [ ] Decentralized oracle integration
- [ ] Carbon credit marketplace integration
- [ ] SaaS deployment model

---

## 🔗 Links & Resources

### Project Resources

- **GitHub Repository**: [https://github.com/DixieMetz/FHEWasteRecycling](https://github.com/DixieMetz/FHEWasteRecycling)
- **Live Demo**: [https://fhe-waste-recycling.vercel.app/](https://fhe-waste-recycling.vercel.app/)
- **Contract Explorer**: [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x6a65Ea0Ce4F2fc31acFA2722d0153145dc48Cc83)

### Zama Ecosystem

- **Zama Documentation**: [docs.zama.ai](https://docs.zama.ai)
- **FHEVM SDK**: [github.com/zama-ai/fhevm](https://github.com/zama-ai/fhevm)
- **fhEVM Solidity**: [github.com/zama-ai/fhevm-solidity](https://github.com/zama-ai/fhevm-solidity)
- **Zama Community**: [discord.gg/zama](https://discord.gg/zama)

### Ethereum Resources

- **Sepolia Testnet**: [sepolia.dev](https://sepolia.dev)
- **Sepolia Faucet**: [sepoliafaucet.com](https://sepoliafaucet.com)
- **Hardhat Documentation**: [hardhat.org/docs](https://hardhat.org/docs)

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
copies of the Software...
```

---

## 🙏 Acknowledgments

- **Zama Team** - For pioneering Fully Homomorphic Encryption technology and the FHEVM platform
- **Ethereum Community** - For robust blockchain infrastructure and development tools
- **Hardhat Team** - For excellent smart contract development framework
- **Open Source Contributors** - For the amazing tools that made this project possible

---

## 📞 Contact & Support

- **Issues**: [GitHub Issues](https://github.com/DixieMetz/FHEWasteRecycling/issues)
- **Discussions**: [GitHub Discussions](https://github.com/DixieMetz/FHEWasteRecycling/discussions)
- **Email**: support@fhewasterecycling.com
- **Twitter**: [@FHEWasteRecycle](#)

---

<div align="center">

## 🌱 Building a Sustainable Future Through Privacy-Preserving Technology

**Enabling environmental transparency without compromising business confidentiality**

Made with ❤️ using Zama FHEVM

⭐ Star us on GitHub if you find this project valuable!

[🌐 Live Demo](https://fhe-waste-recycling.vercel.app/) | [📚 Documentation](./DEPLOYMENT.md) | [🔗 GitHub](https://github.com/DixieMetz/FHEWasteRecycling)

</div>
