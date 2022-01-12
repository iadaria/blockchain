// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.11;

contract SimpleToken {
  
  // Создаем mapping для балансов пользователей
  mapping (address => uint256) public balanceOf;

  // Функция для инициализации смарт-контракта (принимат общее число токенов)
  constructor(uint256 _supply) public {
    
    // Создаем все токены на кошелько того, когда создал смарт-контракт
    balanceOf[msg.sender] = _supply;
  }
  // Функция для отправки токенов
  // Принимает адрес того, кому ты отправляем и число токенов для отправки
  function transfer(address _to, uint256 _value) public {  

    // Проверяем, что у отправителя хватает токенов
    // require вернет газ в случае неполадок
    require(balanceOf[msg.sender] >= _value);

    // Проверяем, что не произошло переполенения
    require(balanceOf[_to] + _value >= balanceOf[_to]);

    // Забираем токены у отправителя
    balanceOf[msg.sender] -= _value;

    // Передаем токены тому, кто их должен получить
    balanceOf[_to] += _value;
  }
}