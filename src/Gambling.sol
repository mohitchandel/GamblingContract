// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract GamblingGame {
    IERC20 public token;
    uint256 public round;

    struct RoundDetails {
        uint256 totalAmount;
        address[] players;
    }
    mapping(uint256 => RoundDetails) public roundDetails;

    mapping(address => uint256) public playerDeposit;
    mapping(uint256 => address) public roundWinner;
    mapping(address => uint256) public rewards;
    mapping(address => bool) public hasDepositedInCurrentRound;

    event Deposit(address indexed user, uint256 amount, uint256 round);
    event WinnerChosen(address indexed winner, uint256 amount, uint256 round);

    constructor(IERC20 _token) {
        token = _token;
        round = 1;
    }

    function deposit(uint256 amount) external {
        require(
            amount > 0,
            "deposit::Deposit amount must be greater than zero"
        );
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "deposit::Token deposit failed"
        );

        if (!hasDepositedInCurrentRound[msg.sender]) {
            roundDetails[round].players.push(msg.sender);
            hasDepositedInCurrentRound[msg.sender] = true;
        }
        roundDetails[round].totalAmount += amount;
        playerDeposit[msg.sender] += amount;

        emit Deposit(msg.sender, amount, round);

        if (roundDetails[round].players.length == 10) {
            _chooseWinner();
        }
    }

    function _chooseWinner() private {
        uint256 randomIndex = random();
        address winner = roundDetails[round].players[randomIndex];

        roundWinner[round] = winner;
        rewards[winner] = roundDetails[round].totalAmount;

        emit WinnerChosen(winner, roundDetails[round].totalAmount, round);
        round++;
    }

    function claimRewards() external {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "claimRewards::No rewards to claim");
        rewards[msg.sender] = 0;
        token.transfer(msg.sender, reward);
    }

    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        blockhash(block.number - 1),
                        block.timestamp
                    )
                )
            ) % 9;
    }
}
