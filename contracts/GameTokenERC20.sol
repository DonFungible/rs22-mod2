// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract GameTokenERC20 is ERC20 {
    constructor() ERC20("GameToken", "GT") {}

    function mint(uint256 nMints) external {
        _mint(msg.sender, nMints);
    }
}
