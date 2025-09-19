# Counter Contract Deployment

A simple Foundry project for deploying and verifying a Counter smart contract on Tenderly Virtual TestNet with comprehensive cost tracking and verification.

## 📋 Project Overview

This project demonstrates:
- Smart contract deployment using Foundry
- Integration with Tenderly Virtual TestNet
- Automatic contract verification
- Deployment cost tracking and analysis
- Professional deployment scripts with error handling

## 🏗️ Project Structure

```
├── script/
│   └── Counter.s.sol          # Deployment script with cost tracking
├── src/
│   └── Counter.sol           # Simple counter smart contract
├── test/
│   └── Counter.t.sol         # Contract tests
├── lib/
│   └── forge-std/            # Foundry standard library
├── deploy-counter.sh         # Enhanced deployment script
├── verify-counter.sh         # Contract verification script
├── analyze-cost.sh           # Cost analysis for past deployments
├── .env                      # Environment variables
├── foundry.toml              # Foundry configuration with Tenderly setup
└── README.md                 # This file
```

## 🚀 Quick Start

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- Tenderly account with Virtual TestNet access
- Basic knowledge of Solidity and command line

### 1. Clone and Setup

```bash
git clone <your-repo-url>
cd eik-deploy
forge install
```

### 2. Environment Configuration

Create or update your `.env` file with the following variables:

```bash
# Required: Your private key (with 0x prefix)
PRIVATE_KEY=0x<your_private_key>

# Required: Tenderly Virtual TestNet RPC URL
RPC_URL=https://virtual.mainnet.eu.rpc.tenderly.co/<your_project_id>

# Required: Tenderly Access Key for verification
TENDERLY_ACCESS_KEY=<your_tenderly_access_key>

# Auto-generated based on RPC_URL
TENDERLY_VIRTUAL_TESTNET_RPC_URL=https://virtual.mainnet.eu.rpc.tenderly.co/<your_project_id>
TENDERLY_VERIFIER_URL=https://virtual.mainnet.eu.rpc.tenderly.co/<your_project_id>/verify/etherscan
```

#### Getting Your Tenderly Access Key:
1. Go to [Tenderly Dashboard](https://dashboard.tenderly.co/account/authorization)
2. Generate a new access key
3. Add it to your `.env` file

### 3. Make Scripts Executable

```bash
chmod +x deploy-counter.sh verify-counter.sh analyze-cost.sh
```

## 📜 Smart Contract

The `Counter.sol` contract is a simple demonstration contract with:

```solidity
contract Counter {
    uint256 public number;
    
    function setNumber(uint256 newNumber) public;
    function increment() public;
}
```

## 🛠️ Available Commands

### Deploy Contract

Deploy the Counter contract with verification and cost tracking:

```bash
./deploy-counter.sh
```

**Features:**
- ✅ Automatic contract verification on Tenderly
- 💰 Real-time cost tracking
- 🔍 Detailed deployment logging
- ⚡ Uses `--slow` flag to prevent transaction batching
- 🛡️ Error handling and validation

### Verify Existing Contract

Verify a previously deployed contract:

```bash
./verify-counter.sh
```

### Analyze Deployment Costs

Analyze costs from previous deployments:

```bash
./analyze-cost.sh
```

**Shows:**
- Gas used and gas price
- Total cost in Wei and ETH
- Contract address and transaction hash
- Readable cost summary

### Manual Forge Commands

If you prefer using Forge directly:

```bash
# Deploy with verification
forge script script/Counter.s.sol:CounterScript \
  --slow \
  --verify \
  --verifier-url $TENDERLY_VERIFIER_URL \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  --etherscan-api-key $TENDERLY_ACCESS_KEY \
  --broadcast

# Verify existing contract
forge verify-contract <CONTRACT_ADDRESS> \
  Counter \
  --etherscan-api-key $TENDERLY_ACCESS_KEY \
  --verifier-url $TENDERLY_VERIFIER_URL \
  --watch

# Run tests
forge test

# Build contracts
forge build
```

## ⚙️ Configuration

### Foundry Configuration (`foundry.toml`)

The project is configured for Tenderly integration:

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]

[etherscan]
# Tenderly Virtual TestNet configuration for verification
unknown_chain = { key = "${TENDERLY_ACCESS_KEY}", chain = 1, url = "${TENDERLY_VERIFIER_URL}" }
```

### Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `PRIVATE_KEY` | Deployer private key (with 0x prefix) | ✅ |
| `RPC_URL` | Tenderly Virtual TestNet RPC URL | ✅ |
| `TENDERLY_ACCESS_KEY` | Tenderly API key for verification | ✅ |
| `TENDERLY_VERIFIER_URL` | Auto-generated verifier URL | Auto |

## 📊 Cost Analysis

### Recent Deployment Results

Latest deployment metrics:
- **Gas Used:** ~156,813 gas
- **Gas Price:** ~0.01 gwei
- **Total Cost:** ~0.0000016 ETH (≈ $0.004 USD)
- **Contract Size:** 481 bytes

### Cost Breakdown Features

The project provides detailed cost analysis:
- Pre and post-deployment balance tracking
- Gas usage optimization insights
- Historical cost comparison
- Multiple cost display formats (Wei, ETH, USD equivalent)

## 🔧 Development

### Testing

```bash
# Run all tests
forge test

# Run tests with verbosity
forge test -vvv

# Run specific test
forge test --match-test testIncrement
```

### Building

```bash
# Compile contracts
forge build

# Clean artifacts
forge clean
```

## 🚨 Troubleshooting

### Common Issues

1. **"Private key missing 0x prefix"**
   - Ensure your `PRIVATE_KEY` in `.env` starts with `0x`

2. **"Tenderly access key not set"**
   - Get your access key from [Tenderly Dashboard](https://dashboard.tenderly.co/account/authorization)
   - Update `TENDERLY_ACCESS_KEY` in `.env`

3. **"Contract verification failed"**
   - Check your `TENDERLY_VERIFIER_URL` matches your RPC URL + `/verify/etherscan`
   - Ensure your Tenderly access key has verification permissions

4. **"Insufficient funds"**
   - Use Tenderly's unlimited faucet for testing
   - Check your deployer address has ETH

### Debug Commands

```bash
# Check environment variables
source .env && echo $TENDERLY_ACCESS_KEY

# Test RPC connection
cast block-number --rpc-url $RPC_URL

# Check deployer balance
cast balance <DEPLOYER_ADDRESS> --rpc-url $RPC_URL
```



