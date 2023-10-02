// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Wallet {
    mapping (address => uint) public userbalance;
    uint256 public balance = address(this).balance;
    mapping(address => uint256) public blockofpay;

    function pay() public payable{
        address user = msg.sender;
        userbalance[user] += msg.value;
        balance += msg.value;
        blockofpay[msg.sender] = block.number;
    }

    function withdraw(uint256 _amountToWithdraw) public{
        require(_amountToWithdraw <= userbalance[msg.sender], "Insufficient funds");

        uint256 amount = _amountToWithdraw / 95 * 100;

        address user = msg.sender;
        userbalance[user] -= _amountToWithdraw;
        balance -= amount;

        payable(user).transfer(amount);
    }

    function withdrawWithDelay(uint256 _amountToWithdraw) public{
        require(blockofpay[msg.sender] > blockofpay, "Too early");

        address user = msg.sender;
        userbalance[user] -= _amountToWithdraw;
        balance -= _amountToWithdraw;

        payable(user).transfer(_amountToWithdraw);
    }
}
