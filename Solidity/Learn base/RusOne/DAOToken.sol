// SPDX-License-Identifier: GPL-3.0

/* Реалзиовать смарт-контакт ДАО в котором с помощью голосования была бы возможность устанавливать цену токна на ICO */
/* Задеплоить все смарт-контракты в Rinkeby и попробовать устроить голослование за стоимость токена */

pragma solidity >=0.7.0 <0.9.0;

// Контракт для установки прав
contract OwnableWithDAO {

  // Переменная для хранения владельца контракта
  address public owner;
  // Переменная для хранения адреса ДАО
  address public daoContract;
  // Конструктор, который при создании инициализирует переменную с владельцем
  constructor() {
    owner = msg.sender;
  }
  // Модификатор для защиты от вызовов не создателя контракта
  modifier onlyOwner() {
    require(msg.sender == owner, "Can not continue executing this function sender isn't a owner!");
    // Дальше продолжаем выполнение функции - нижнее подчеркивание - это обязательное условие
    _;
  }
  // Модификатор для защиты от вызовов не со стороны ДАО
  modifier onlyDAO() {
    require(msg.sender == daoContract, "A function is called not from DAOContract");
    _;
  }
  // Функция для защиты владельца
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0), "Owner' address cannot be 0");
    owner = newOwner;
  }
  // Функция для установки / замены контракта ДАО
  function setDAOContract(address newDAO) onlyOwner public {
    daoContract = newDAO;
  }
}

// Контракт для остановки некоторых операций
contract Stoppable is OwnableWithDAO {
  // Переменная для хранения состояния
  bool public stopped;
  // Модификатор для проверки возможности выполнения смарт-контракта
  modifier stoppable {
    require(!stopped, "Contract was stopped");
    _;
  }

  // Функция для установки переменной в состояние остановки
  function stop() public onlyDAO {
    stopped = true;
  }

  // Функция для установки переменной в состояние работы
  function start() public onlyDAO {
    stopped = false;
  }
}

// Инициализация контракта
contract DAOToken is OwnableWithDAO, Stoppable {
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
    decimals = 0;
    // Объявляем общее число токенов, которое будет создано при инициалзиации
    // У нас будет всего десять токенов
    totalSupply = 10 * (10 ** uint256(decimals)); // 10 в степени 8
    // Отправляем все токены на баланс того, кто инициализировал создание контракта токена
    // Все токены оказываются у создателя
    balanceOf[msg.sender] = totalSupply;
    // Укзаываем название токена
    name = "DAO Token";
    // Указываем символ токена
    symbol = "DAO";
  }

  // Внутренняя функция для перевода 
  // stoppable - (не возможно будет поттасовать значения) возможность заблокировать отправку токена на время проведения голосования
  // 1 пользователь проголосовал, перевел свои токены на другой кошелек, проголосовал с этого кошелька и так далее
  function _transfer(address _from, address _to, uint256 _value) stoppable internal {
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
  function transfer(address _to, uint256 _value) public {
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

  // Функция для смены названия токена
  function changeSymbol(string memory _symbol) onlyDAO public {
    symbol = _symbol;
  }
}