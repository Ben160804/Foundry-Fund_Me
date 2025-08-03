# Foundry Fund Me

A decentralized crowdfunding smart contract built with Foundry and Solidity. This project allows users to fund a contract with ETH and enables the contract owner to withdraw funds once a minimum funding threshold is met.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Smart Contract Functions](#smart-contract-functions)
- [Testing](#testing)
- [Deployment](#deployment)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## Overview

This project demonstrates a basic crowdfunding mechanism on the Ethereum blockchain. Users can send ETH to the contract, and the owner can withdraw funds once the minimum funding goal is reached. The contract uses Chainlink Price Feeds to convert ETH amounts to USD for accurate minimum funding calculations.

## Features

- **Crowdfunding Mechanism**: Accept ETH donations from multiple users
- **Minimum Funding**: Set a minimum USD amount required for funding
- **Price Feed Integration**: Uses Chainlink oracles for ETH/USD conversion
- **Owner Controls**: Only contract owner can withdraw funds
- **Funder Tracking**: Keep track of all funders and their contributions
- **Withdraw Functionality**: Secure fund withdrawal with proper access controls

## Prerequisites

Before running this project, make sure you have:

- [Git](https://git-scm.com/)
- [Foundry](https://getfoundry.sh/) installed
- Basic understanding of Solidity and smart contracts

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ben160804/Foundry-Fund_Me.git
   cd Foundry-Fund_Me
   ```

2. **Install dependencies**
   ```bash
   forge install
   ```

3. **Build the project**
   ```bash
   forge build
   ```

## Usage

### Local Development

1. **Start a local blockchain**
   ```bash
   anvil
   ```

2. **Deploy to local network**
   ```bash
   forge script script/DeployFundMe.s.sol --rpc-url http://localhost:8545 --private-key <your_private_key> --broadcast
   ```

### Interacting with the Contract

```bash
# Fund the contract (send ETH)
cast send <CONTRACT_ADDRESS> "fund()" --value 1000000000000000000 --rpc-url <RPC_URL> --private-key <PRIVATE_KEY>

# Check contract balance
cast balance <CONTRACT_ADDRESS> --rpc-url <RPC_URL>

# Withdraw funds (owner only)
cast send <CONTRACT_ADDRESS> "withdraw()" --rpc-url <RPC_URL> --private-key <OWNER_PRIVATE_KEY>
```

## Smart Contract Functions

### Main Functions

- **`fund()`**: Send ETH to the contract (must meet minimum USD requirement)
- **`withdraw()`**: Withdraw all funds from the contract (owner only)
- **`getVersion()`**: Get the version of the Chainlink price feed
- **`getPrice()`**: Get current ETH price in USD
- **`getConversionRate(uint256 ethAmount)`**: Convert ETH amount to USD

### View Functions

- **`getAddressToAmountFunded(address)`**: Get funding amount for a specific address
- **`getFunder(uint256 index)`**: Get funder address by index
- **`getOwner()`**: Get contract owner address

## Testing

Run the test suite:

```bash
# Run all tests
forge test

# Run tests with verbosity
forge test -vvv

# Run specific test file
forge test --match-path test/FundMeTest.t.sol

# Check test coverage
forge coverage
```

## Deployment

### Sepolia Testnet Deployment

1. **Set up environment variables**
   ```bash
   export SEPOLIA_RPC_URL=<your_sepolia_rpc_url>
   export PRIVATE_KEY=<your_private_key>
   export ETHERSCAN_API_KEY=<your_etherscan_api_key>
   ```

2. **Deploy to Sepolia**
   ```bash
   forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
   ```

### Mainnet Deployment

**Warning**: Deploying to mainnet costs real ETH. Make sure you understand the implications.

```bash
forge script script/DeployFundMe.s.sol --rpc-url $MAINNET_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## Project Structure

```
foundry-fund-me/
├── lib/                    # Dependencies
├── script/                 # Deployment scripts
│   └── DeployFundMe.s.sol
├── src/                    # Smart contracts
│   ├── FundMe.sol
│   └── PriceConverter.sol
├── test/                   # Test files
│   └── FundMeTest.t.sol
├── foundry.toml           # Foundry configuration
├── Makefile              # Build commands
└── README.md
```

## Configuration

The project uses Foundry's configuration file `foundry.toml`:

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
solc_version = "0.8.19"
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Foundry](https://github.com/foundry-rs/foundry) - Ethereum development toolkit
- [Chainlink](https://chain.link/) - Decentralized oracle network
- [OpenZeppelin](https://openzeppelin.com/) - Secure smart contract libraries

## Contact

- **GitHub**: [@Ben160804](https://github.com/Ben160804)
- **Project Link**: [https://github.com/Ben160804/Foundry-Fund_Me](https://github.com/Ben160804/Foundry-Fund_Me)

---

If you found this project helpful, please give it a star.
