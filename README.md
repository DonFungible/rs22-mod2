# Hardhat

## Differences between `safeTransferFrom` and `transferFrom`

1. `safeTransferFrom` allows `bytes data` as an input, `transferFrom` does not.
2. `_safeTransfer` calls `_transfer` but has an additional `require(_checkOnERC721Received(...))`. If recipient is a contract, `_checkOnERC721Received` calls `onERC721Received`, else `_safeTransfer` is identical to `_transfer`.
3. `safeTransferFrom` is identical to `transferFrom` IFF caller is EOA and `data` input is empty

## Free mint contract:

Polygonscan: https://mumbai.polygonscan.com/address/0x963b907f0820Fe92b4deFF2C72053e5F9B3b49a9#readContract
OpenSea: https://testnets.opensea.io/collection/freemint-iia6lpbxxj
