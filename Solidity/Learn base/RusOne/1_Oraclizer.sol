// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.11;

// Деплой в Ринкиби

// Подключаем библиотеку
import 'github.com/oraclize/ethereum-api/oraclizeAPI.sol';

// Объявляем контракт

contract DollarCost is usingOraclize {

  // Объявляем переменную для хранения стоимости доллара
  uint public dollarCost;

  // В эту функцию отдадут результат
  function __callback(bytes32 myid, string result) {
    // Проверяем, что эту функцию вызвал ораклайзер
    if (msg.sender != oraclize_cbAddress()) throw;
    // Обновляем переменную со стоимостью доллара
    dollarCost = parseInt(result, 3); // 1, 001 => 1001
  }



  // Функция вызова ораклайзера
  function updatePrice() public payable {
    // Проверить есть ли у нас газ для вызова ораклайзера
    if (oraclize_getPrice("URL") > this.balance) {
      // Если средств не хватило - просто завершаем выполнение
      return;
    } else {
      // Если средств хватает - отправляем запрос в API
      oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.[0]");
    }
  }
}

/** */