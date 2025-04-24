# TEST Bitxel Roads Token (BTRD)

TEST ERC20 token implementation for the Bitxel Roads ecosystem on Base Sepolia network.

## Overview

- **Name**: Bitxel Roads Token
- **Symbol**: BTRD
- **Total Supply**: 40,000,000,000 BTRD
- **Decimals**: 18

## Features

- TEST ERC20 standard implementation
- Ownable for secure administration
- Pausable for emergency situations
- Burning capability
- Game contract integration
- Vesting contract integration

## Security Features

- Ownership management (transfer to cold wallet)
- Emergency pause mechanism
- Restricted burning permissions
- Event tracking for all important actions
- Disabled ownership renouncement

## Contract Functions

### Admin Functions
- `setGameContract`: Set the game contract address
- `setVestingContract`: Set the vesting contract address
- `pause`: Pause all token transfers
- `unpause`: Resume token transfers
- `burnFrom`: Burn tokens from an address (owner or game contract only)

### Standard ERC20 Functions
- `transfer`: Transfer tokens to another address
- `transferFrom`: Transfer tokens on behalf of another address
- `approve`: Approve spending allowance
- `balanceOf`: Check token balance
- `allowance`: Check spending allowance

## Events

- `GameContractUpdated`: Emitted when game contract is updated
- `VestingContractUpdated`: Emitted when vesting contract is updated
- `TokensBurned`: Emitted when tokens are burned
- Standard ERC20 events (`Transfer`, `Approval`)

## Development

```bash
# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy to Base Sepolia
npx hardhat run scripts/deploy.js --network baseSepolia
```

## License

MIT
