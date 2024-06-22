// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GamblingGame} from "../src/GamblingGame.sol";
import {GambelToken} from "../src/GambelToken.sol";

contract CounterTest is Test {
    address public playerOne = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address public playerTwo = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    address public playerThree = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
    address public playerFour = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;
    address public playerFive = 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65;
    address public playerSix = 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc;
    address public playerSeven = 0x976EA74026E726554dB657fA54763abd0C3a0aa9;
    address public playerEight = 0x14dC79964da2C08b23698B3D3cc7Ca32193d9955;
    address public playerNine = 0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f;
    address public playerTen = 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;

    GamblingGame public gamblingGame;
    GambelToken public gambelToken;

    function setUp() public {
        gambelToken = new GambelToken();
        gamblingGame = new GamblingGame(gambelToken);
    }

    function test_TokenMint() public {
        vm.prank(playerOne);
        gambelToken.mint(1000 ether);
        uint256 playerOneBalance = gambelToken.balanceOf(playerOne);
        assertEq(playerOneBalance, 1000 ether);
    }

    function test_TokenApprove() public {
        test_TokenMint();
        vm.prank(playerOne);
        gambelToken.approve(address(gamblingGame), 10000000000 ether);
        uint256 allowance = gambelToken.allowance(
            playerOne,
            address(gamblingGame)
        );
        assertEq(allowance, 10000000000 ether);
    }

    function test_Deposit() public {
        test_TokenApprove();
        vm.prank(playerOne);
        gamblingGame.deposit(10 ether);
        uint256 playerDeposit = gamblingGame.playerDeposit(playerOne);
        assertEq(playerDeposit, 10 ether);
    }

    function test_MultipleDeposit() public {
        test_Deposit();
        vm.prank(playerOne);
        gamblingGame.deposit(10 ether);
        uint256 playerDeposit = gamblingGame.playerDeposit(playerOne);
        assertEq(playerDeposit, 20 ether);
    }

    function mintByAll() public {
        vm.prank(playerOne);
        gambelToken.mint(1000 ether);
        vm.prank(playerTwo);
        gambelToken.mint(1000 ether);
        vm.prank(playerThree);
        gambelToken.mint(1000 ether);
        vm.prank(playerFour);
        gambelToken.mint(1000 ether);
        vm.prank(playerFive);
        gambelToken.mint(1000 ether);
        vm.prank(playerSix);
        gambelToken.mint(1000 ether);
        vm.prank(playerSeven);
        gambelToken.mint(1000 ether);
        vm.prank(playerEight);
        gambelToken.mint(1000 ether);
        vm.prank(playerNine);
        gambelToken.mint(1000 ether);
        vm.prank(playerTen);
        gambelToken.mint(1000 ether);
    }

    function approveByAll() public {
        vm.prank(playerOne);
        gambelToken.approve(address(gamblingGame), 10000000000 ether);
        vm.prank(playerTwo);
        gambelToken.approve(address(gamblingGame), 10000000000 ether);
        vm.prank(playerThree);
        gambelToken.approve(address(gamblingGame), 10000000000 ether);
        vm.prank(playerFour);
        gambelToken.approve(address(gamblingGame), 10000000000 ether);
        vm.prank(playerFive);
        gambelToken.approve(address(gamblingGame), 10000000000 ether);
        vm.prank(playerSix);
        gambelToken.approve(address(gamblingGame), 10000000000 ether);
        vm.prank(playerSeven);
        gambelToken.approve(address(gamblingGame), 10000000000 ether);
        vm.prank(playerEight);
        gambelToken.approve(address(gamblingGame), 10000000000 ether);
        vm.prank(playerNine);
        gambelToken.approve(address(gamblingGame), 10000000000 ether);
        vm.prank(playerTen);
        gambelToken.approve(address(gamblingGame), 10000000000 ether);
    }

    function depositByAll() public {
        vm.prank(playerOne);
        gamblingGame.deposit(10 ether);
        vm.prank(playerTwo);
        gamblingGame.deposit(12 ether);
        vm.prank(playerThree);
        gamblingGame.deposit(9 ether);
        vm.prank(playerFour);
        gamblingGame.deposit(15 ether);
        vm.prank(playerFive);
        gamblingGame.deposit(17 ether);
        vm.prank(playerSix);
        gamblingGame.deposit(10 ether);
        vm.prank(playerSeven);
        gamblingGame.deposit(20 ether);
        vm.prank(playerEight);
        gamblingGame.deposit(8 ether);
        vm.prank(playerNine);
        gamblingGame.deposit(15 ether);
        vm.prank(playerTen);
        gamblingGame.deposit(13 ether);
    }

    function test_GetWinnerAndClaim() public {
        mintByAll();
        approveByAll();
        depositByAll();
        address winner = gamblingGame.roundWinner(1);
        uint256 winnerPrevBalance = gambelToken.balanceOf(winner);
        uint256 reward = gamblingGame.rewards(winner);

        vm.prank(winner);
        gamblingGame.claimRewards();
        uint256 winnerBalanceAftrClaim = gambelToken.balanceOf(winner);

        assertEq(winnerBalanceAftrClaim, winnerPrevBalance + reward);
    }

    /* Tests for reverts */

    function test_ZeroDeposit() public {
        test_TokenApprove();
        vm.prank(playerOne);
        vm.expectRevert(
            bytes("deposit::Deposit amount must be greater than zero")
        );
        gamblingGame.deposit(0 ether);
    }

    function test_NoAllowanceDeposit() public {
        test_TokenMint();
        vm.prank(playerOne);
        vm.expectRevert();
        gamblingGame.deposit(10 ether);
    }

    function test_WrongClaim() public {
        mintByAll();
        approveByAll();
        depositByAll();
        vm.expectRevert(bytes("claimRewards::No rewards to claim"));
        address reandomAddress = 0xc0ffee254729296a45a3885639AC7E10F9d54979;
        vm.prank(reandomAddress);
        gamblingGame.claimRewards();
    }

    function test_MultipleClaim() public {
        mintByAll();
        approveByAll();
        depositByAll();
        address winner = gamblingGame.roundWinner(1);
        uint256 winnerPrevBalance = gambelToken.balanceOf(winner);
        uint256 reward = gamblingGame.rewards(winner);

        vm.prank(winner);
        gamblingGame.claimRewards();
        uint256 winnerBalanceAftrClaim = gambelToken.balanceOf(winner);

        assertEq(winnerBalanceAftrClaim, winnerPrevBalance + reward);
        vm.expectRevert(bytes("claimRewards::No rewards to claim"));
        gamblingGame.claimRewards();
    }
}
