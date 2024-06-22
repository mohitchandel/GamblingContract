// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract GambelToken is ERC20 {
    constructor() ERC20("GambelToken", "GTK") {}

    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }
}
