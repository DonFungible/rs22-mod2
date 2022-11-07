// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {ERC721Enumerable, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Enumerable is ERC721Enumerable, Ownable {
    // using Counters for Counters.Counter;
    // Counters.Counter public tokenId;
    uint256 counter;

    uint256 public constant MAX_SUPPLY = 20;
    string public baseTokenURI;

    event Minted(address indexed receiver, uint256 amount);

    constructor() ERC721("Enumerable", "ENUM") {}

    /*-------------------------------ADMIN--------------------------------*/
    function setBaseURI(string calldata _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }
}
