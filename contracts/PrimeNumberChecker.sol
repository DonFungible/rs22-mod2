// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {IERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

contract PrimeNumberChecker {
    IERC721Enumerable public checker;

    constructor(IERC721Enumerable _enumerable) {
        checker = _enumerable;
    }

    function getOwnedTokens(address tokenOwnerAddr)
        public
        view
        returns (uint256[] memory)
    {
        uint256 numTokensOwned = checker.balanceOf(tokenOwnerAddr);
        uint256[] memory ownedTokens = new uint256[](numTokensOwned);

        for (uint256 i; i < numTokensOwned; ) {
            ownedTokens[i] = checker.tokenOfOwnerByIndex(tokenOwnerAddr, i);
            ++i;
        }
        return ownedTokens;
    }

    function isPrime(uint256 n) public pure returns (bool) {
        if (n == 1) return false;

        for (uint256 i = 2; i < n; ) {
            if (n % i == 0) {
                return false;
            }
            ++i;
        }
        return true;
    }

    function getTotalPrimes(address tokenOwnerAddr)
        external
        view
        returns (uint256)
    {
        uint256[] memory ownedTokens = getOwnedTokens(tokenOwnerAddr);
        // uint256[] memory primes = new uint256[]();
        // uint256[] storage primes;

        uint256 counter;

        unchecked {
            for (uint256 i; i < ownedTokens.length; ) {
                if (isPrime(ownedTokens[i])) {
                    ++counter;
                    // primes[counter] = ownedTokens[i];
                    // primes.push(ownedTokens[i]);
                }
                ++i;
            }
        }

        return counter;
    }
}
