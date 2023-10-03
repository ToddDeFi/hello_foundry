// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Wallet {
    mapping(address => uint256) public userbalance;
    uint256 public balance;
    mapping(address => uint256) public blockofpay;
    uint256 private constant DELAY = 120;

    constructor() {
        balance = address(this).balance;
    }

    function pay() public payable {
        address user = msg.sender;
        userbalance[user] += msg.value;
        balance += msg.value;
        blockofpay[user] = block.number;
    }

    function withdraw(uint256 _amountToWithdraw) public {
        require(_amountToWithdraw <= userbalance[msg.sender], "Insufficient funds");

        uint256 fee = (_amountToWithdraw * 5) / 100;
        uint256 amountToReceive = _amountToWithdraw - fee;

        address user = msg.sender;
        userbalance[user] -= _amountToWithdraw;
        balance -= fee;

        payable(user).transfer(amountToReceive);
    }


    function withdrawWithDelay(uint256 _amountToWithdraw) public {
        require(block.number > blockofpay[msg.sender] + 120, "Too early");

        address user = msg.sender;
        userbalance[user] -= _amountToWithdraw;
        balance -= _amountToWithdraw;

        payable(user).transfer(_amountToWithdraw);
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
}
