# Gambling Game Smart Contract

This is a Solidity smart contract for a gambling game built using Foundry. The game accepts custom ERC20 tokens and determines a winner every 10 unique deposits. The winner receives the total amount of tokens deposited in that round. The contract includes functions for depositing tokens and claiming rewards.

## Deployement

- Gambel Token => [0x837BA22c8a47c667bB44e75Bd799e782796Ddaab](https://sepolia.etherscan.io/address/0x837BA22c8a47c667bB44e75Bd799e782796Ddaab)

- Gambling Smart Contract => [0x8f8Ec5eBEc5F195bA6349BaAFdB3c9d93B481567](https://sepolia.etherscan.io/address/0x8f8Ec5eBEc5F195bA6349BaAFdB3c9d93B481567)

## Smart Contract Features

### Key Functions

- **Deposit Tokens**: Users can deposit ERC20 tokens. Only the first deposit counts towards the 10 unique deposits needed to determine a winner.
- **Claim Rewards**: Users can claim any rewards they have won.
- **Randomness**: Generates a pseudo-random number to select the winner, using blockhash and block timestamp.

### Events

The contract emits events for:

- Deposits
- Winner selection
- Reward claims

## Usage

### Build

```shell
$ forge build
```

### Test

Use Foundry's built-in testing framework run tests.

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot

```
