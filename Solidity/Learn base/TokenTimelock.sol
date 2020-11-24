// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

import "./Token.sol";

/*
    For deploy
    First deploy Token
    Second copy token address for deploy
*/

contract TokenTimelock {
    Token public token;
    address public beneficiary;
    uint256 public releaseTime;
    
    constructor(Token _token, address _beneficiary, uint256 _releaseTime) {
        require(_releaseTime > block.timestamp);
        token = _token;
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
    }
    
    function release() public {
        require(block.timestamp > releaseTime);
        uint256 amount = token.balanceOf(address(this));
        require(amount > 0);
        token.transfer(beneficiary, amount);
    }
}