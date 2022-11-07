// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC20GameToken {
    function mint(uint256 nMints) external;

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function transfer(address from, uint256 amount) external returns (bool);
}

contract Staking is IERC721Receiver {
    uint256 public constant twentyFourHours = 24 * 60 * 60;
    IERC721 public immutable itemNFT;
    IERC20GameToken public gameToken;
    address public gameTokenAddress;

    mapping(uint256 => address) public originalOwner;
    mapping(uint256 => uint256) public timeStaked;
    mapping(uint256 => uint256) public rewardsClaimed;

    constructor(IERC721 _itemNFT, IERC20GameToken _gameToken) {
        itemNFT = _itemNFT;
        gameToken = _gameToken;
        gameToken.mint(1e8);
    }

    function withdrawNFT(uint256 tokenId) external {
        require(originalOwner[tokenId] == msg.sender, "Not original owner");
        itemNFT.safeTransferFrom(address(this), msg.sender, tokenId);

        // Reset rewards for future staker
        timeStaked[tokenId] = 0;
        rewardsClaimed[tokenId] = 0;
    }

    function claimStakingRewards(uint256 tokenId) external {
        require(originalOwner[tokenId] == msg.sender, "Not original owner");
        require(timeStaked[tokenId] != 0, "Token not staked");
        uint256 rewards = computeRewards(tokenId);
        require(rewards > rewardsClaimed[tokenId], "Rewards already claimed");

        rewardsClaimed[tokenId] = rewards;
        // gameToken.transferFrom(address(this), msg.sender, rewards);
        bool success = gameToken.transfer(msg.sender, rewards);
    }

    function checkHasClaimedDailyReward(uint256 tokenId, address staker)
        public
        view
        returns (bool)
    {
        // if (hasClaimedDailyReward[tokenId]) return true;
    }

    function computeRewards(uint256 tokenId) public view returns (uint256) {
        require(timeStaked[tokenId] != 0, "Not staked");

        // Create step function y = |x| with 24 hour interval
        uint256 rewardsTotal = 10 *
            ((block.timestamp - timeStaked[tokenId]) / twentyFourHours);

        return rewardsTotal - rewardsClaimed[tokenId];
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        // originalOwner[tokenId] = msg.sender;
        originalOwner[tokenId] = from;
        timeStaked[tokenId] = block.timestamp;
        console.log("STAKED");
        return IERC721Receiver.onERC721Received.selector;
    }
}
