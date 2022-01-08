// SPDX-License-Identifier: GPL-3.0

// Пишем библиотеку для поиска элемента в массиве

pragma solidity ^0.5.11;

// Объявляем название библиотеки
library SimpleSearch {
  // Создаем функцию для прохода по массиву
  function searchFor(uint[] storage self, uint _value) public view returns (uint) {
    // Проходимся по массиву
    for (uint i = 0; i < self.length; i++) {
      // Если нашли число - возвращаем его индекс
      if (self[i] == _value) return i;
      // Если число не нашли - вернем uint(-1)
    }
    return uint(-1);
  }


}

// Создаем простеньки контрак
contract ContractWithArrays {  
  // Указываем что будем использовать библиотеку для массива uint
  using SimpleSearch for uint[]; 
  // Объявляем наш массив
  uint[] public bigArrayOfNumbers;
  
  // Функция для добавления числа в массив
  function push(uint _value) public {
    bigArrayOfNumbers.push(_value);
  }
  // 1,9 => [9,2,3,4,5,9]
  function replace(uint _old, uint _new) public {
    // Ищем индекс с помощью библиотеки
    uint position = bigArrayOfNumbers.searchFor(_old);
    // Если мы нашли индекс элемента то заменяем
    if (position == uint(-1)) {
      bigArrayOfNumbers.push(_new);
      // Если нет то добавляем в массив еще один элемент
    } else {
      bigArrayOfNumbers[position] = _new;
    }
  }
}