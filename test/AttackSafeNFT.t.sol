// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {AttackSafeNFT} from "../src/AttackSafeNFT.sol";
import {SafeNFT} from "../src/SafeNFT.sol";

contract AttackSafeNFTTest is Test {
    SafeNFT safenft;
    AttackSafeNFT attacksafenft;

    uint256 price = 0.01 ether;

    function setUp() public {
        safenft = new SafeNFT("SAGE NFT", "SNFT", price);
        attacksafenft = new AttackSafeNFT(address(safenft));
        vm.deal(address(attacksafenft), 2 ether);
    }

    function test_attackNFT() external {
        vm.startPrank(address(attacksafenft));
        attacksafenft.attack(price);
        if (11 != safenft.balanceOf(address(attacksafenft))) revert();

        vm.stopPrank();
    }
}
