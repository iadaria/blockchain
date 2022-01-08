// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.11;

contract AbstractContract {
  function test() public returns (uint);
}

contract RealContract is AbstractContract {
  function test() public returns (uint) {
    return 42;
  }
}