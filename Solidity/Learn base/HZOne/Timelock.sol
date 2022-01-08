// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

contract Timelock {
    // who can withdrow ?
    // how mach ?
    // When ?
    address payable beneficiary;
    uint256 releaseTime;
    uint256 public balance;
    
    constructor(address payable _beneficiary, uint256 _releaseTime) {
        require(_releaseTime > block.timestamp);
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
    }
    
    function getBalance() public {
        balance = address(this).balance;
    }
    
    function release() public payable {
        require(block.timestamp >= releaseTime);
        beneficiary.transfer(address(this).balance);
    }
}