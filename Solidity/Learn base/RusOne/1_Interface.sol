// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.11;

interface Token {
    function transfer(address _to, uint _value) public;
}

contract TokenTransferer {
    Token token;

    function simpleInterfaceCall(address _to) internal {
        token.transfer(_to, 2);
    }
}