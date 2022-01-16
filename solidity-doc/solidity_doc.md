// language https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
https://www.markdownguide.org/basic-syntax/ \
https://www.freecodecamp.org/news/how-to-format-code-in-markdown/

# Solidity
Solidity это объектно-ориентированный, высокоуровневый язык программирования для создания смарт-контрактов. Смарт-контракты это программы которые (управляют поведением аккаунтов/управляют счетами внутри состояния Ethereum)?

Язык Solidity похож/позаимствовал на C++, Python & JavaScript и спроектирван специально для EVM(Ethereum Virtual Machine/Виртуальной машины Ethereum)

Solidity имеет статическую типизацию, поддерживает наследование, подключение библиотек и сложные пользовательские типы помимо других возможностей языка.

Solidity позволяет создавать контракты для пользователей, такие как: голосование, краудфандинг, слепые аукционы, и кошельки с мультиподписью.

При развертывании контракта, нужно использовать самую последнюю версию Solidity. Это связано с постоянными основательнымии изменениями - добавляются новые возможности и исправляются ошибки.

_Внимание_
Последняя версия Solidity 0.8.x получила много критических изменений. [Ознакомьтесь с этими изменениями](https://docs.soliditylang.org/en/latest/080-breaking-changes.html) Можно ознакомится здесь.

## Solidity v0.8.7 Важные изменения 

## Введение
1. Базовые сведения о Смарт-контракте/Что из себя представлыет Смарт-контракт \
Если вы еще не знакомы с концепцией смарт-контрактов, то рекомендуем начать с секции "Ввод в понятие смарт-контрактов", в которых рассказывается:
* [Пример простого смарт-контракта](https://docs.soliditylang.org/en/latest/introduction-to-smart-contracts.html#simple-smart-contract) на Solidity;
* [Основы блокчейна](https://docs.soliditylang.org/en/latest/introduction-to-smart-contracts.html#blockchain-basics);
* [Виртуальная Машина Ethereum](https://docs.soliditylang.org/en/latest/introduction-to-smart-contracts.html#the-ethereum-virtual-machine);

2. Ознакомление с Solidity \
После ознакомления с базовыми принципами смарт-контрактов, рекомендуем ознакомиться с разделами: ["Solidity на примере"](https://docs.soliditylang.org/en/latest/solidity-by-example.html) и "Описание языка", чтобы понять ключевые концепции языка.

3. Установка Solidity-компилятора \
Установить Solidity компилятор можно несколькими способами, просто выберите нужный вариант и следуйте иструкциям, описанным на [странице устаровки](https://docs.soliditylang.org/en/latest/installing-solidity.html#installing-solidity)

#### Подсказка
Используя [Remix IDE](https://remix.ethereum.org) вы можете запустить примеры кода прямо в браузере. Remix это IDE на базе веб-браузера, которая позволяет вам писать, развертывать и администрировать смарт-контракты Solidity без необходимости локально устанавливать Solidity.

#### Предупреждение
В прогрммном коде, который написан человеком, могут встречаться ошибки. Поэтому при разрбаотке смарт-контрактов вы должны соблюдать установленные рекомендации по разрбаотке - лучшие практики, что подразумевает: проверку кода, тестирование, подтверждение работоспособности на практике. Случается, что пользователи смарт-контрактов безоговорочно доверяют коду, тогда как технологии блокчейн и смарт-контракты имеют специфичные для данной области проблемы, на которые следует обратить внимание. Поэтому перед выпуском продукта для конечного пользователя, обязательно изучите раздел ["Из соображений безопасности"](https://docs.soliditylang.org/en/latest/security-considerations.html#security-considerations)

4. Более подробное изучение Solidity

### Первое знакомство со смарт-контрактом
#### Простой смарт-контракт
Начнем с простого примера - присвоим значение переменной и сделаем ее доступной для использования
другими контрактами. Ничего страшного, если будет что-то не понятно с первого раза, в следующих разделах 
мы рассмотрим все более детально

Пример сохранения

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
```
На первой строке указываем, что код под лицензией GPL версии 3.0 Важно указывать машинночитаемые спецификаторы лицензий,
если настроенна публикация исходного кода по умолчанию

На следующей строке указывается версия языка Solidity для исходного кода, которая будет использоваться. В данном случает это 
версия от 0.4.16 до 0.9.0(не включительно), т/е не для 0.9.0. Это гарантирует, что контракт не скомпилируется компилятором
для новой версии(с значительными изменениями), которая может привести к незапланированному поведению контракта. Ключевое
слово [pragma](https://docs.soliditylang.org/en/v0.8.9/layout-of-source-files.html#pragma) является общей инструкцией для всех версий компиляторов, которая указывает как обрабатывать исходный код
(например, [pragma once](https://en.wikipedia.org/wiki/Pragma_once)).


Любой _контракт_ представляет собой исходный код(в виде функций) и данные(состояние), который постоянно находится по определенному адресу в блокчейне Эфириума. \
Строка ```uint storedDate;``` объявляет переменную состояния с именем ```storedData``` тип ```uint```(беззнаковое цело число длиной 256 бит) Это как слот/ячейка в базе данных, значение которой вы пожете получать и изменять с помощью вызова функций в
программном коде, который управляет этой базой данных. В данном примере, контракт определяет функции: ```set``` и ```get```, с помощью которых мы может, изменить или извлечь значение переменной ```storedData```

>256 бит - это 2^256 различных значений, для беззнакового числа это максимум 2^256 - 1, записанное в десятичной форме как 115,792,089,237,316,195,423,570,985,008,687,907,853,269,984,665,640,564,039,457,584,007,913,129,639,935 или в 16-ичной 
FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF(64 позиции)

Для получения доступа к любому члену контракта(например, переменной состояния) текущего контракта, не нужно добавлять, обычно используемый в других языках программирования, префикс ```this```, мы можете получить доступ к свойству напрямую, просто указав
имя. Данное отличие от других языков программирования, заключается не простов в стиле, а в совершенно другом способе доступа к членам/свойствам, но более подробно мы разберем это далее.

Данный контракт имеет небольшой функционал, помимо того(из-за инфраструктуры созданной Эфириумом) он позволяет любому сохранить произвольное публичное значение - число, без возможности скрыть его от общего доступа. Кто-угодно может вызвать функцию ```set``` 
повторно с другим значением и переписать данные, но при этом все изменения данных сохраняются в истории блокчейна. Позже, мы рассмотрим как можно ограничить доступ к данным, так чтобы только вы смогли изменять значение данного числа.

*** 
#### Предупреждение
Будьте осторожны при использовании текста в кодировке [Unicode](https://ru.wikipedia.org/wiki/%D0%AE%D0%BD%D0%B8%D0%BA%D0%BE%D0%B4), т/к похожие символы могут иметь разные кодовые позиции и кодируются как разный массив байтов
***
#### Примечание
Все идентификаторы(имена контрактов, функций и переменных) должны иметь [ASCII](https://ru.wikipedia.org/wiki/ASCII) кодировку символов. Значения строковых переменных можно хранить в кодировке [UTF-8](https://ru.wikipedia.org/wiki/UTF-8).

### Пример валюты Ethereum

Следующий контрак представляет собой самую простую форму валюты. Только разработчик может создать новые монеты (возможны также другие схемы выпуска). Кто угодно может отправлять манеты друг другу без необходимости регистрации с использованием имени и 
пароля пользователя, вам нужно только пара ключей Ethereum.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Coin {
    // Ключевое слово "public" делает переменные доступными для других контрактов
    address public minter;
    mapping (address => uint) public balances;

    // События позволяют клиентам реагировать на определенные изменения, которые вы объявляете
    event Sent(address from, address to, uint amount);


    // Код в конструкторе запускается только только один раз - при создании контракта
    constructor() {
        minter = msg.sender;
    }
    // Отправляет только что созданные монеты в размере - amount на адрес - receiver
    // Данная функция может вызываться только владельцем/создателем контракта
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter, "You are not the minter");
        balances[receiver] += amount;
    }

    // Errors позволяют отображать информацию о том, почему операция закончилась с ошибкой
    // Ошибки возвращатеся пользователю, который вызывал функцию.
    error InsufficientBalance(uint requested, uint available);

    // Отправляем имеющиеся монеты в количестве - amount
    // Отправителем может быть любой на любой адрес
    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}

```
[Посмотреть данные контракт в Redmix](https://remix.ethereum.org/?language=solidity&version=0.8.10&code=Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0zLjAKcHJhZ21hIHNvbGlkaXR5IF4wLjguNDsKCmNvbnRyYWN0IENvaW4gewogICAgLy8gVGhlIGtleXdvcmQgInB1YmxpYyIgbWFrZXMgdmFyaWFibGVzCiAgICAvLyBhY2Nlc3NpYmxlIGZyb20gb3RoZXIgY29udHJhY3RzCiAgICBhZGRyZXNzIHB1YmxpYyBtaW50ZXI7CiAgICBtYXBwaW5nIChhZGRyZXNzID0+IHVpbnQpIHB1YmxpYyBiYWxhbmNlczsKCiAgICAvLyBFdmVudHMgYWxsb3cgY2xpZW50cyB0byByZWFjdCB0byBzcGVjaWZpYwogICAgLy8gY29udHJhY3QgY2hhbmdlcyB5b3UgZGVjbGFyZQogICAgZXZlbnQgU2VudChhZGRyZXNzIGZyb20sIGFkZHJlc3MgdG8sIHVpbnQgYW1vdW50KTsKCiAgICAvLyBDb25zdHJ1Y3RvciBjb2RlIGlzIG9ubHkgcnVuIHdoZW4gdGhlIGNvbnRyYWN0CiAgICAvLyBpcyBjcmVhdGVkCiAgICBjb25zdHJ1Y3RvcigpIHsKICAgICAgICBtaW50ZXIgPSBtc2cuc2VuZGVyOwogICAgfQoKICAgIC8vIFNlbmRzIGFuIGFtb3VudCBvZiBuZXdseSBjcmVhdGVkIGNvaW5zIHRvIGFuIGFkZHJlc3MKICAgIC8vIENhbiBvbmx5IGJlIGNhbGxlZCBieSB0aGUgY29udHJhY3QgY3JlYXRvcgogICAgZnVuY3Rpb24gbWludChhZGRyZXNzIHJlY2VpdmVyLCB1aW50IGFtb3VudCkgcHVibGljIHsKICAgICAgICByZXF1aXJlKG1zZy5zZW5kZXIgPT0gbWludGVyKTsKICAgICAgICBiYWxhbmNlc1tyZWNlaXZlcl0gKz0gYW1vdW50OwogICAgfQoKICAgIC8vIEVycm9ycyBhbGxvdyB5b3UgdG8gcHJvdmlkZSBpbmZvcm1hdGlvbiBhYm91dAogICAgLy8gd2h5IGFuIG9wZXJhdGlvbiBmYWlsZWQuIFRoZXkgYXJlIHJldHVybmVkCiAgICAvLyB0byB0aGUgY2FsbGVyIG9mIHRoZSBmdW5jdGlvbi4KICAgIGVycm9yIEluc3VmZmljaWVudEJhbGFuY2UodWludCByZXF1ZXN0ZWQsIHVpbnQgYXZhaWxhYmxlKTsKCiAgICAvLyBTZW5kcyBhbiBhbW91bnQgb2YgZXhpc3RpbmcgY29pbnMKICAgIC8vIGZyb20gYW55IGNhbGxlciB0byBhbiBhZGRyZXNzCiAgICBmdW5jdGlvbiBzZW5kKGFkZHJlc3MgcmVjZWl2ZXIsIHVpbnQgYW1vdW50KSBwdWJsaWMgewogICAgICAgIGlmIChhbW91bnQgPiBiYWxhbmNlc1ttc2cuc2VuZGVyXSkKICAgICAgICAgICAgcmV2ZXJ0IEluc3VmZmljaWVudEJhbGFuY2UoewogICAgICAgICAgICAgICAgcmVxdWVzdGVkOiBhbW91bnQsCiAgICAgICAgICAgICAgICBhdmFpbGFibGU6IGJhbGFuY2VzW21zZy5zZW5kZXJdCiAgICAgICAgICAgIH0pOwoKICAgICAgICBiYWxhbmNlc1ttc2cuc2VuZGVyXSAtPSBhbW91bnQ7CiAgICAgICAgYmFsYW5jZXNbcmVjZWl2ZXJdICs9IGFtb3VudDsKICAgICAgICBlbWl0IFNlbnQobXNnLnNlbmRlciwgcmVjZWl2ZXIsIGFtb3VudCk7CiAgICB9Cn0=)

На примере данного контракта, мы можем ознакомиться с новыми понятиями, давайте рассмотрим их по
по порядку \

### _public_

Строка `address public minter;` объявляет переменную состояния с типом **address**. Тип
[***address***](https://docs.soliditylang.org/en/v0.8.10/types.html#address) - это 160-битовое значение, которое не допускает никаких арифметических операций. Этот тип
переменной подходит для хранения адресов контрактов или хэша открытого ключа [внешнего аккаунта](https://docs.soliditylang.org/en/v0.8.10/introduction-to-smart-contracts.html#accounts).
Ключевое слово ```public``` автоматически создает функцию, которая позволяет получить досутп к текущему
значению переменной состояния публично - извне контракта. Без этого ключевого слова, другие контракты
не смогут получить доступ к переменной. Созданный компилятором код функции, эквивалентен следующему
(пока не обращайте внимания на ключевые слова ```external``` и ```view```)
```solidity
function minter() external view returns (address) { return minter; }
```
Т/е вы бы могли самостоятельно создать такую функцию, но в таком случае у вас была бы функция и переменная 
состояния с тем же именем. Не нужно этого делать, компилятор сделает этого за нас.

### _mapping_

Следующая строка нашего кода - `mapping (address => uint) public balances;`, также создает переменную
состояния, но это более сложный тип данных. Тип 
[mapping](https://docs.soliditylang.org/en/v0.8.10/types.html#mapping-types) используется для работы с
адресами в формате
[беззнакового целого числа](https://docs.soliditylang.org/en/v0.8.10/types.html#integers).
 ***Mapings*** помжно представить в виде [хэш-таблицы](https://en.wikipedia.org/wiki/Hash_table), которая
инициализируется таким образом, что каждый возможный ключ добавляется с начала и сопоставляется
со значением, байтовое представление которого(значения) инициированно нулями. 
Однако невозможно получить ни список
всех ключей переменной типа ***mapping***, ни список всех его значений. Записывайте отдельно то, что вы
добавили в ***mapping***, или используйти этот тип в контексте, где в получении значений ***mapping** нет
необходимости. А лучше используйте более подходящий вам тип данных, например список.

Для переменной типа ***mapping***, get-функция, созданная с помощью ключевого слова ```public``` более
сложная. Она выглядить следующим образом:
```solidity
function balances(address _account) external view returns (uint) {
    return balances[_account];
}
```
Вы можете с помощью этой функции запросить баланс для отдельного аккаунта.

Строка кода `event Sent(address from, address to, uint amount);` объявляет одно `событие`, которое будет
срабатывать(вызывается) на последней строке нашей функции 'send'. Клиентская часть работы с Ethereum, как
например веб-приложение, может прослушивать эти события из блокчейна без необходимости платить за транзакцию,
чтобы получить ту же информацию. Как только событие сработало, слушатель получает следующие аргументы:
`from`, `to`, and `amount`, что позволяет отслеживать транзакцию.

Для прослушивания данного события, можно использовать следующий JavaScript код, в котором используется
библиотека web3.js для создания контракта `Coin`,
```javascript
Coin.Sent().watch({}, '', function(error, result) {
    if (!error) {
        console.log("Coin transfer: " + result.args.amount +
            " coins were sent from " + result.args.from +
            " to " + result.args.to + ".");
        console.log("Balances now:\n" +
            "Sender: " + Coin.balances.call(result.args.from) +
            "Receiver: " + Coin.balances.call(result.args.to));
    }
})
```