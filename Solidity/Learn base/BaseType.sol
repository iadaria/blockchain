// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.8.0;

contract Test {

  // Time
  function getSeconds(uint a) public returns(uint) {
    return a * 1 seconds;
  }
  function getMinutes(uint a) public returns(uint) {
    return a * 1 minutes;
  }
  function getHours(uint a) public returns(uint) {
    return a * 1 hours;
  }
  function getDays(uint a) public returns(uint) {
    return a * 1 days;
  }
  function getWeeks(uint a) public returns(uint) {
    return a * 1 weeks;
  }
  function getYears(uint a) public returns(uint) {
    return a * 1 years;
  }

  // Ethers
  uint public onWei =  1 wei; // 20 * 1 wei
  uint public oneFinney = 1 finney;
  uint public oneSzabo = 1 szabo;
  uint public oneEther = 1 ether;

  // Mapping
  mapping(uint => uint) public simpleMapping;

  function add(uint _key, uint _value) public {
    simpleMapping[_key] = _value;
  }

  // Message
    bytes public msgData;
    address public msgSender;
    bytes4 public msgSig;
    uint public msgGas;
    uint public msgValue;
    uint public value;

    function setMessageValues(uint _test) public payable {
        value = _test;

        msgData = msg.data;
        msgSender = msg.sender;
        msgSig = msg.sig;
        msgGas = msg.gas;
        msgValue = msg.value;
    }
}