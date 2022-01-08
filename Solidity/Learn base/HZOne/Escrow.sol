// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

contract Escrow {
    address agent;
    mapping(address => uint256) public deposits;
    
    modifier onlyAgent() {
        require(msg.sender == agent);
        _;
    }
    
    constructor() {
        agent = msg.sender; // get address by deploy default
    }
    
    function deposit(address payee) public onlyAgent payable {
        uint256 amount = msg.value; // contain ether value
        deposits[payee] = deposits[payee] + amount;
    }
    
    function withdraw(address payable payee) public onlyAgent {
        uint256 payment = deposits[payee];
        deposits[payee] = 0;
        payee.transfer(payment);
    }
}