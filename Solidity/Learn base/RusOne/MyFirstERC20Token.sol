// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MyFirstERC20Token {

  // Объявляем переменную в которой будет название токена
  string public name;

  // Объявляем переменную в которй будет символ токена
  string public symbol;

  // Объявляем переменную в которй будет число нулей токена
  uint8 public decimals;

  // Объявляем переменную в которой будет храниться общее число токенов
  uint256 public totalSupply;

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

    // Указать число нулей
    decimals = 8;

    // Объявляем общее число токенов, которое будет создано при инициалзиации
    totalSupply = 1000000 * (10 ** uint256(decimals)); // 10 в степени 8

    // Отправляем все токены на баланс того, кто инициализировал создание контракта токена
    // Все токены оказываются у создателя
    balanceOf[msg.sender] = totalSupply;

    // Укзаываем название токена
    name = "MyFirstERC20Coin";

    // Указываем символ токена
    symbol = "MFE";
  }

  // Внутренняя функция для перевода токена
  function _transfer(address _from, address _to, uint256 _value) internal {

    // Проверка на пустой адрес
    require(_to != address(0x0), "Recipent address is required");

    // Проверка того, что отправителю хватает токенов для перевода
    require(balanceOf[_from] >= _value, "The sender has insufficient funds");

    // Проверка на переполнение
    require(balanceOf[_to] + _value >= balanceOf[_to], "Stack overflow");

    // Токены списываются у отправителя
    balanceOf[_from] -= _value;

    // Токены прибавляются получателю
    balanceOf[_to] += _value;

    // Эвент перевода токенов
    emit Transfer(_from, _to, _value);
  }


  // Функция для перевода токена
  function transfer(address _to, uint256 _value) public payable {

    // Вызов внутренней функции перевода
    _transfer(msg.sender, _to, _value);
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