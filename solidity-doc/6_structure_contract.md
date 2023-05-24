v0.8.20

### Structure of a Contract
### Структура контракта

EN
Contracts in Solidity are similar to classes in object-oriented languages. Each contract can contain declarations of State Variables, Functions, Function Modifiers, Events, Errors, Struct Types and Enum Types. Furthermore, contracts can inherit from other contracts.

RU
Контракты в языке Solidity похожи на классы в объекто-ориентированных языках. Каждый контракт может содержать объявления Переменных Состояния, Функций, Модификаторов Функций, Событий, Ошибок, Структуры и Перечисления. Кроме того, контракты могут наследовать другие контракты.

EN
There are also special kinds of contracts called libraries and interfaces.

RU
Существуют также специальные виды контрактов, называемые библиотеками и интерфейсами.

EN
The section about contracts contains more details than this section, which serves to provide a quick overview.

RU
Раздел о контрактах содержит больше подробное описание. Этот раздел служит для краткого обзора.

### State Variables
### Переменные состояния

EN
State variables are variables whose values are permanently stored in contract storage.

RU
Переменные состояния - это переменные, значения которых постоянно хранятся в хранилище контракта(?).

```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract SimpleStorage {
    uint storedData; // Переменная состояния
    // ...
}
```
EN
See the Types section for valid state variable types and Visibility and Getters for possible choices for visibility.

RU
О допустимых типах переменных состояния см. в разеделе Типы, а о возможных вариантах видимости и Геттеров - в разделе Видимость(?).

### Functions
### Функции
 
EN
Functions are the executable units of code. Functions are usually defined inside a contract, but they can also be defined outside of contracts.

RU
Функции - это исполняемые блоки кода. Функции обычно определяются внутри контракта, но также могут быть определены и вне контракта.

```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.1 <0.9.0;

contract SimpleAuction {
    function bid() public payable { // Функция
        // ...
    }
}

// Helper function defined outside of a contract
// Функция `helper`, определена вне контракта
function helper(uint x) pure returns (uint) {
    return x * 2;
}
```
EN
Function Calls can happen internally or externally and have different levels of visibility towards other contracts. Functions accept parameters and return variables to pass parameters and values between them.

RU
Вызовы функций могут происходить внутри или снаружи контракта и иметь различные уровни видимости по отношению к другим контрктам. Функции принимают параметры и возвращают переменные для передачи параметром и значений между ними.

### Function Modifiers
### Модификаторы функций

EN
Function modifiers can be used to amend the semantics of functions in a declarative way (see Function Modifiers in the contracts section).

Overloading, that is, having the same modifier name with different parameters, is not possible.

Like functions, modifiers can be overridden.

RU
Модификаторы функций могут использоваться для изменения семантики функций декларативным способом (см. раздел "Модификаторы функций" в разделе "Контракты").

Перезагрузка модификатора, т.е. использование одного и того же имени модификатора с разными параметрами, невозможна.

```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

contract Purchase {
    address public seller;

    modifier onlySeller() { // Модификатор
        require(
            msg.sender == seller,
            "Only seller can call this."
        );
        _;
    }

    function abort() public view onlySeller { // Использование модификатора
        // ...
    }
}
```

### Events
### События

EN
Events are convenience interfaces with the EVM logging facilities.

RU
События - это удобные интерфейсы для работы со средствами протоколирования EVM.

```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.21 <0.9.0;

contract SimpleAuction {
    event HighestBidIncreased(address bidder, uint amount); // Событие

    function bid() public payable {
        // ...
        emit HighestBidIncreased(msg.sender, msg.value); // Запускаем/вызываем событие
    }
}
```
EN
See Events in contracts section for information on how events are declared and can be used from within a dapp.

RU
Смотрите События в разделе контрактов для получения информации о том, как они объявляются и могут быть использованы внутри dapp.

### Errors
### Ошибки

EN
Errors allow you to define descriptive names and data for failure situations. Errors can be used in revert statements. In comparison to string descriptions, errors are much cheaper and allow you to encode additional data. You can use NatSpec to describe the error to the user.

RU
Ошибки позволяют определять описательные имена и данные при ситуациях сбоя. Ошибки можно использовать в операциях возврата. По сравнению со строковыми описаниями, ошибки намного дешевле и позволяют кодировать дополнительные данные. Вы можете использовать NatSpec для описания ошибки пользователю.
```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

/// Недостаточно для перевода. Запрошено `requested`,
/// но доступно только `available`.
error NotEnoughFunds(uint requested, uint available);

contract Token {
    mapping(address => uint) balances;
    function transfer(address to, uint amount) public {
        uint balance = balances[msg.sender];
        if (balance < amount)
            revert NotEnoughFunds(amount, balance);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        // ...
    }
}
```
EN
See Errors and the Revert Statement in the contracts section for more information.

RU
Дополнительную информацию см. в разделе "Ошибки и оператор возврата" в разделе "Контракты".

### Struct Types
### Стукртуры

EN
Structs are custom defined types that can group several variables (see Structs in types section).

RU
Структуры - это определяемые пользователем типы, которые могут группировать несколько переменных(см. раздел Структуры в разделе типов).

```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract Ballot {
    struct Voter { // Структура
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
}
```

### Enum Types
### Перечисления

EN
Enums can be used to create custom types with a finite set of ‘constant values’ (see Enums in types section).

RU
Enums можно использовать для создания пользовательских типов с конечным набором "постоянных значений" (см. Enums в разделе типов).

```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract Purchase {
    enum State { Created, Locked, Inactive } // Перечисления
}
```
