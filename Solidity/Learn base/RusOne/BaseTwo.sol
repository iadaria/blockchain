// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.4.11;

// Первая опция - перевести деньги и запомнить время перевода
// Вторая опция - поставить какое-то значение, за какую-то сумму после этого заблокировать эту
// переменную на 120 секунд, блокировать переменную на запись, после того как заплатили за ее
// размещение

// owner - кто задеплоил смарт-контракт
// Функция для приема эфиров с payable
  // Проверяем, что переведено достаточное число эфиров

// Функция  для приема эфиров и установки значения

contract BaseTwo {

  address public donator;
  address public owner;

  uint public value;

  uint public lastTimeForDonate;
  uint public lastTimeForValue;

  uint timeOut = 120 seconds;

  function BaseTwo() public {
    owner = msg.sender;
  }

  function () external payable {
    require(msg.value > 1 finney);
    // Чтобы газ второго не сжегся
    require(lastTimeForDonate + timeOut < now);
    setDonator(msg.sender);
  }

  function buyValue(uint _value) public payable {
    require(msg.value > 1 finney);
    require(lastTimeForDonate + timeOut < now);
    setValue(_value);
  }

  function setValue(uint _value) internal {
    value = _value;
    lastTimeForValue = now;
  }

  function setDonator(address _donator) internal {
    donator = _donator;
    lastTimeForDonate = now;
  }

}