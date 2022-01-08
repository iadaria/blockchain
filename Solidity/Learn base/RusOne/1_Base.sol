// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.8.0;

contract Test {

    string public value;
    address payable public donator;

    function setValues(string memory _value) public {
        value = _value;
    }

    function detectAddress() public payable {
      donator = msg.sender;
    }
}