// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;
import "hardhat/console.sol";

contract C {
    function f(uint len) public view {
        uint[] memory a = new uint[](7);
        bytes memory b = new bytes(len);
        assert(a.length == 7);
        assert(b.length == len);
        a[6] = 8;
        for(uint i=0; i < a.length; i++) {
            console.log(a[i]);
        }
    }
}