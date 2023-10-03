// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

contract WalletTest is Test {
    Wallet public wallet;

    address public self = address(this);
    address user = makeAddr("user");
    uint256 amount = 1000;
    
    function setUp() public {
        wallet = new Wallet();
    }

    function testGetBalance() public{
        assertEq(wallet.getBalance(), 0);
    }

    function testPay() public{
        wallet.pay{value: amount}();
        assertEq(wallet.getBalance(), amount);
    }

    function testPayFromUser() public{
        // Sets up a prank from an address that has some ether.
        hoax(user);
        wallet.pay{value: amount}();
        assertEq(wallet.getBalance(), amount);
    }

    function testWithdrawReject() public {
        vm.expectRevert(bytes("Insufficient funds"));
        wallet.withdraw(amount);
    }

    function testWithdrawRejectFromUser() public {
        // Sets msg.sender to the specified address 
        vm.prank(user);
        vm.expectRevert(bytes("Insufficient funds"));
        wallet.withdraw(amount);
    }

    function testWithdraw() public { 
        wallet.pay{value: amount}();

        uint256 balance = amount - (amount * 5) / 100;
        console.log(wallet.getBalance());
        wallet.withdraw(amount);

        assertEq(wallet.getBalance(), amount - balance);
    }

    function testWithdrawWithDelay() public {
        uint256 startBalance = wallet.getBalance();
        wallet.pay{value: amount}();
        // Sets block.number
        vm.roll(block.number + 130);

        wallet.withdrawWithDelay(amount);

        assertEq(wallet.getBalance(), startBalance);
    }

    receive() external payable {}

    fallback() external payable {}
}