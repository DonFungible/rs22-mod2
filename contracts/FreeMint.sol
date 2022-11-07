// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "hardhat/console.sol";

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

contract FreeMint is ERC721, Ownable {
    // using Counters for Counters.Counter;
    // Counters.Counter public tokenId;
    uint256 public constant MAX_SUPPLY = 10;
    string public baseTokenURI;
    uint256 counter;

    event Minted(address indexed receiver, uint256 amount);

    constructor() ERC721("FreeMint", "FREE") {}

    function mintFree(uint256 nMints) external {
        require(msg.sender == tx.origin, "Can't mint from another contract");
        require(counter + nMints <= MAX_SUPPLY, "Exceeds max supply");
        unchecked {
            for (uint256 i = 0; i < nMints; ) {
                _safeMint(msg.sender, counter++);
                console.log(counter);
                ++i;
            }
        }

        emit Minted(msg.sender, nMints);
    }

    function setBaseURI(string calldata _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }
}
