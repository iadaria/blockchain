// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import 'hardhat/console.sol';

contract WrongICO {
  // Объявляем переменную в которой будет название токена
  string public name;

  // Объявляем переменную в которй будет символ токена
  string public symbol;


  // Объявляем переменную в которй будет число нулей токена
  uint8 public decimals;

  // Добавить переменную для хранения стоимости токена
  uint public buyPrice;

  // Объявляем переменную в которой будет храниться общее число токенов
  uint256 public totalSupply;

  address owner;

  // Объявляем маппинг для хранения балансво пользователей
  mapping (address => uint256) public balanceOf;

  // Объявляем маппинг для хранения одобренных транзакций
  mapping (address => mapping(address => uint256)) public allowance;

  // Объявляем эвент для логгирования события перевода токена
  event Transfer(address from, address to, uint256 value);

  // Объявляем эвент для логгирования события одобрения перевода токенов
  event Approve(address from, address to, uint256 value);

  // Функция инициации контракта
  constructor () {

    owner = msg.sender;

    // Указать число нулей
    decimals = 8;

    // Объявляем общее число токенов, которое будет создано при инициалзиации
    totalSupply = 1000000 * (10 ** uint256(decimals)); // 10 в степени 8

    // Указать значение стоимости токена
    // Это не количество токенов, это стоймости нашей капейки токена
    // Соответственно один токен будет стоить 1000 и еще 10 нулей
    buyPrice = 1000; // 1000 wei

    // Отправляем все токены на баланс того, кто инициализировал создание контракта токена
    // Все токены оказываются у создателя
    balanceOf[msg.sender] = totalSupply;

    // Укзаываем название токена
    name = "WrongICO";

    // Указываем символ токена
    symbol = "WICO";
  }

      // Функция для отправки эфира на контракт
  fallback() external payable {
    _buy(msg.sender, msg.value);
    // Вызов внутренней функции
  }

  // Внутренняя функция для перевода токена
  function _transfer(address _from, address _to, uint256 _value) internal {
    console.log('[_transfer] from', _from);
    console.log('[_transfer] owner', owner);
    console.log('[_transfer] to', _to);
    console.log('[_transfer] value', _value);

    // Проверка на пустой адрес
    require(_to != address(0x0), "Recipent address is required");

    // Проверка того, что отправителю хватает токенов для перевода
    //require(balanceOf[_from] >= _value, "The sender has insufficient funds");
    require(balanceOf[owner] >= _value, "The sender has insufficient funds");
    console.log('[_transfer] balance from', balanceOf[_from]);
    console.log('[_transfer] balance owner', balanceOf[owner]);

    // Проверка на переполнение
    require(balanceOf[_to] + _value >= balanceOf[_to], "Stack overflow");

    // Токены списываются у отправителя
    //balanceOf[_from] -= _value;
    balanceOf[owner] -= _value;

    // Токены прибавляются получателю
    balanceOf[_to] += _value;

    // Эвент перевода токенов
    // emit Transfer(_from, _to, _value);
    emit Transfer(owner, _to, _value);
  }


  // Функция для перевода токена
  function transfer(address _to, uint256 _value) public {

    // Вызов внутренней функции перевода
    _transfer(msg.sender, _to, _value);
  }

    // Функция для обработки вызова
  function buy() public payable {
    // Вызов внутренней функции
    _buy(msg.sender, msg.value);
  }
   // Внутрення функция
  function _buy(address _from, uint _value) internal {
    console.log('[_buy()] _from', _from);
    console.log('[_buy()] _value', _value);
    
    // Рассчитать количество токенов по курсу
    uint256 amount = _value / buyPrice;
    console.log('[_buy()] amount', amount);

    // Вызво внутрнней функции для перевода токнов
    _transfer(address(this), _from, amount);
  }

  // Функция для перевода "одобренных" токенов
  function transferFrom(address _from, address _to, uint256 _value) public {

    // Проверка, что токены были выделены аккаунтом _from для аккаунта _to
    require(_value <= allowance[_from][_to], "The tokens had not booked yet");

    // Уменьшаем число "одобренных" токенов
    allowance[_from][_to] -= _value;

    // Отправка токенов
    _transfer(_from, _to, _value);
  }
  // Функция для "одобрения" перевода токенов
  function approve(address _to, uint256 _value) public {

    // Записываем в маппинг число "одобренных" токенов
    allowance[msg.sender][_to] = _value;

    // Вызов эвента для логгирования события одобрения перевода токенов
    emit Approve(msg.sender, _to, _value);
  }
}