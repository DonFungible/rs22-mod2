// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "hardhat/console.sol";

import {ERC721, IERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

contract ItemERC721 is ERC721, Ownable {
    // using Counters for Counters.Counter;
    // Counters.Counter public tokenId;
    uint256 public constant MAX_SUPPLY = 10;
    string public baseTokenURI;
    uint256 counter;

    event Minted(address indexed receiver, uint256 amount);

    constructor() ERC721("Item", "ITEM") {
        // _mint(msg.sender, 10);
    }

    function mint(uint256 numMints) external {
        for (uint256 i; i < numMints; ) {
            counter++;
            _mint(msg.sender, counter);
            ++i;
        }
    }

    /*-------------------------------ADMIN--------------------------------*/
    function setBaseURI(string calldata _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }
}
