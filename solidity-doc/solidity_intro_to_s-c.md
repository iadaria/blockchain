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

### Пример криптовалюты

Следующий контрак представляет собой самую простой вид криптовалюты. Только создатель контракта может выпускать новые монеты (возможны также другие схемы выпуска). Любые желающие могут отправлять манеты друг другу без необходимости регистрации с указанием имени и пароля пользователя, вам нужно только пара ключей Ethereum.

```javascript
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Coin {
    // Ключевое слово "public" делает переменные доступными из других контрактов
    address public minter;
    mapping (address => uint) public balances;

    // События позволяют клиентам реагировать на определенные изменения, которые вы объявляете
    event Sent(address from, address to, uint amount);


    // Код в конструкторе запускается только только один раз - при создании контракта
    constructor() {
        minter = msg.sender;
    }

    /*
    Отправляем вновь созданные монеты в количестве amount на адрес - receiver
    Данная функция может вызываться только владельцем контракта
    */
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter, "You are not the minter");
        balances[receiver] += amount;
    }

    /*
    Ошибки позволяют вам предоставить информацию о причинах сбоя операции.
    Ошибки возвращатеся клиенту, вызывающему функцию. 
    */
    error InsufficientBalance(uint requested, uint available);

    /*
    Отправляем существующие монеты в количетсве amount 
    Функция может быть вызвана кем угодно
    Монеты могут быть отправлены на любой адрес receiver
    */
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
[Посмотреть данный контракт в Redmix](https://remix.ethereum.org/?language=solidity&version=0.8.10&code=Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0zLjAKcHJhZ21hIHNvbGlkaXR5IF4wLjguNDsKCmNvbnRyYWN0IENvaW4gewogICAgLy8gVGhlIGtleXdvcmQgInB1YmxpYyIgbWFrZXMgdmFyaWFibGVzCiAgICAvLyBhY2Nlc3NpYmxlIGZyb20gb3RoZXIgY29udHJhY3RzCiAgICBhZGRyZXNzIHB1YmxpYyBtaW50ZXI7CiAgICBtYXBwaW5nIChhZGRyZXNzID0+IHVpbnQpIHB1YmxpYyBiYWxhbmNlczsKCiAgICAvLyBFdmVudHMgYWxsb3cgY2xpZW50cyB0byByZWFjdCB0byBzcGVjaWZpYwogICAgLy8gY29udHJhY3QgY2hhbmdlcyB5b3UgZGVjbGFyZQogICAgZXZlbnQgU2VudChhZGRyZXNzIGZyb20sIGFkZHJlc3MgdG8sIHVpbnQgYW1vdW50KTsKCiAgICAvLyBDb25zdHJ1Y3RvciBjb2RlIGlzIG9ubHkgcnVuIHdoZW4gdGhlIGNvbnRyYWN0CiAgICAvLyBpcyBjcmVhdGVkCiAgICBjb25zdHJ1Y3RvcigpIHsKICAgICAgICBtaW50ZXIgPSBtc2cuc2VuZGVyOwogICAgfQoKICAgIC8vIFNlbmRzIGFuIGFtb3VudCBvZiBuZXdseSBjcmVhdGVkIGNvaW5zIHRvIGFuIGFkZHJlc3MKICAgIC8vIENhbiBvbmx5IGJlIGNhbGxlZCBieSB0aGUgY29udHJhY3QgY3JlYXRvcgogICAgZnVuY3Rpb24gbWludChhZGRyZXNzIHJlY2VpdmVyLCB1aW50IGFtb3VudCkgcHVibGljIHsKICAgICAgICByZXF1aXJlKG1zZy5zZW5kZXIgPT0gbWludGVyKTsKICAgICAgICBiYWxhbmNlc1tyZWNlaXZlcl0gKz0gYW1vdW50OwogICAgfQoKICAgIC8vIEVycm9ycyBhbGxvdyB5b3UgdG8gcHJvdmlkZSBpbmZvcm1hdGlvbiBhYm91dAogICAgLy8gd2h5IGFuIG9wZXJhdGlvbiBmYWlsZWQuIFRoZXkgYXJlIHJldHVybmVkCiAgICAvLyB0byB0aGUgY2FsbGVyIG9mIHRoZSBmdW5jdGlvbi4KICAgIGVycm9yIEluc3VmZmljaWVudEJhbGFuY2UodWludCByZXF1ZXN0ZWQsIHVpbnQgYXZhaWxhYmxlKTsKCiAgICAvLyBTZW5kcyBhbiBhbW91bnQgb2YgZXhpc3RpbmcgY29pbnMKICAgIC8vIGZyb20gYW55IGNhbGxlciB0byBhbiBhZGRyZXNzCiAgICBmdW5jdGlvbiBzZW5kKGFkZHJlc3MgcmVjZWl2ZXIsIHVpbnQgYW1vdW50KSBwdWJsaWMgewogICAgICAgIGlmIChhbW91bnQgPiBiYWxhbmNlc1ttc2cuc2VuZGVyXSkKICAgICAgICAgICAgcmV2ZXJ0IEluc3VmZmljaWVudEJhbGFuY2UoewogICAgICAgICAgICAgICAgcmVxdWVzdGVkOiBhbW91bnQsCiAgICAgICAgICAgICAgICBhdmFpbGFibGU6IGJhbGFuY2VzW21zZy5zZW5kZXJdCiAgICAgICAgICAgIH0pOwoKICAgICAgICBiYWxhbmNlc1ttc2cuc2VuZGVyXSAtPSBhbW91bnQ7CiAgICAgICAgYmFsYW5jZXNbcmVjZWl2ZXJdICs9IGFtb3VudDsKICAgICAgICBlbWl0IFNlbnQobXNnLnNlbmRlciwgcmVjZWl2ZXIsIGFtb3VudCk7CiAgICB9Cn0=)

На примере данного контракта, мы можем ознакомиться с новыми понятиями, давайте рассмотрим их по
по порядку \

### _public_

Строка `address public minter;` объявляет переменную состояния типа **address**. Тип
[***address***](https://docs.soliditylang.org/en/v0.8.10/types.html#address) представляет собой 160-битовое значение, которое не допускает никаких арифметических операций. Этот тип
переменной подходит для хранения адресов контрактов или хэша открытого ключа [внешнего аккаунта](https://docs.soliditylang.org/en/v0.8.10/introduction-to-smart-contracts.html#accounts).

Ключевое слово ```public``` автоматически создает функцию, которая позволяет получить досутп к текущему значению переменной состояния публично - т.е за пределами контракта. Без этого ключевого слова, другие контракты не смогут получить доступ к такой переменной. Созданный компилятором код функции, эквивалентен следующему (пока не обращайте внимания на ключевые слова ```external``` и ```view```)
```solidity
function minter() external view returns (address) { return minter; }
```
Т.е вы бы могли самостоятельно создать такую функцию, но в таком случае у вас была бы и функция и переменная состояния с тем же именем. Поэтому не нужно этого делать, компилятор сделает этого за нас.

### _mapping_

Следующая строка нашего кода - `mapping (address => uint) public balances;`, также создает переменную
состояния, но это более сложный тип данных. Тип 
[mapping](https://docs.soliditylang.org/en/v0.8.10/types.html#mapping-types) используется для работы с
адресами в формате
[беззнакового целого числа](https://docs.soliditylang.org/en/v0.8.10/types.html#integers).
 ***Mappings*** пожно рассматривать как [хэш-таблицы](https://en.wikipedia.org/wiki/Hash_table), которые виртуально инициализируются таким образом, что каждый возможный ключ существует с самого начала и сопоставляется с значению, байтовое представление которого(значения) состоит из всех нулей. Однако невозможно получить ни список всех ключей переменной типа ***mapping***, ни список всех его значений. Записывайте отдельно то, что вы добавили в ***mapping***, или используйте **mapping** в случает, если в этом нет необходимости. А лучше используйте более подходящий вам тип данных, например список.

Для переменной типа ***mapping***, get-функция, созданная с помощью ключевого слова ```public``` более
сложная. Она выглядить следующим образом:
```solidity
function balances(address _account) external view returns (uint) {
    return balances[_account];
}
```
Вы можете с помощью этой функции запросить баланс для отдельного аккаунта.

Строка `event Sent(address from, address to, uint amount);` объявляет `событие`, которое будет
срабатывать(вызываться) в последней строке кода нашей функции 'send'. Клиентская часть работы с Ethereum, как например веб-приложение, может прослушивать эти события блокчейна без особых затрат. Как только событие сработало, слушатель получает следующие аргументы: `from`, `to`, and `amount`, что позволяет отслеживать транзакцию.

Для прослушивания события Sent из нашего примера, можно использовать следующий JavaScript код на основе библиотеки web3.js, которая используется для создания объекта контракта `Coin`, и ***любые вызовы пользовательского интерфейса*** автоматически сгенерированной функции `balances`
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

Конструктор - это специальная функция, которая выполняется один раз при создании контракта и не может быть вызвана уже после его создания. В данном случае, в конструкторе как правило сохраняется адрес лица, создавшего контракт. Переменная `msg` (наряду с tx и block) - это `специальные глобальные переменные` которые содержат свойства, позволяющие получить доступ к блокчейну. `msg.sender` - это всегда адрес, с которого сделан текущий (внешний) вызов функции.

Функции `mint` и `send` составляют контракт и могут быть выполнены пользователями или другими контрактами.

Функция `mint`:
- отправляет вновь созданные монеты в количестве anmount на другой адрес;
- функция `request` определяет условия, невыолнение которых приводит к отмене всех изменений; В рассматриваемом примере, `request(msg.sender == minter);` гарантирует, что данную функцию может выполнить только владелец контракта. В общем, владелец может выпускать столько токенов, сколько ему захочется, но в какой-то момент это приведет к эффекту, который называется "переполнением". Обратите внимание, что т/к по умолчанию происходит `проврка арифметических вычислений` в результате которых транзакция может быть отменена, если выражение `balances[receiver] += amount;` приведет к переполнению, т.е. когда `balances[receiver] += amount` в арифметических расчетах произвольной точности, становится больше чем максимально возможное значение, `uint` а именно`(2 ** 256 - 1)`.  Это также верно и для выражения `balances[receiver] += amount;` в функции `send`.

`Errors` позволяют предоставить вызывающей стороне больше информации о том, почему условие или операция не сработали. Ошибки используются в вместе с оператором `revert`. Оператор `revert` безаговорочно прерывает выполенение функции и отменяет все изменения аналогично функции `require`, но он также прозволяет вам указать наименование ошибки и дополнитедльные данные, которые будут предоставлены вызывающей стороне(в конечном итоге, front-end приложению или обозревателю блокчейн-блоков), чтобы можно было легче отладить или отреагировать на сбой.

`send` функция может быть вызывана любым (у кого уже есть некоторое количество этих монет) для отправки монет кому-нибудь другомую. Если у отправителя недостаточно монет для отправки(т/е amount указано больше чем у него есть), условие `if` - истинно. Как результат, функция `revert` приведет к неудачной операции, предоставив отправителю монет информацию об ошибке с помощью `InsufficientBalance error` 

---
> **_Примечание:_**
В случае, когда вы используете приведенный в примере контракт для отправки монет на какой-то адрес, вы ничего не увидите при просмотре этого адреса в обозревателе блокчейна, поскольку запись о том, что вы отправили монеты и измененные балансы хранятся только в хранилище данных этого конкретного контракта `Coin`. Используя события, вы можете создать "обозреватель блокчейна", который отслеживает транзакции и балансы вашей новой монеты, но при этом вы должны просматривать адрес контракта `Coin`, а не адреса владельцев монет.
---

## Blockchain Basics

## Основы блокчейна

Blockchains as a concept are not too hard to understand for programmers. The reason is that most of the complications (mining, hashing, elliptic-curve cryptography, peer-to-peer networks, etc.) are just there to provide a certain set of features and promises for the platform. Once you accept these features as given, you do not have to worry about the underlying technology - or do you have to know how Amazon’s AWS works internally in order to use it?

Концепция блокчейна не слишком сложна для понимания программистами. Причина в том, что большинство сложных составляющих (майнинг, хэширование, криптография с эллиптическими кривыми, одноранговые сети и т.д.) просто необходимы для обеспечения определенного набора функций и обязательств для платформы. Как только вы принимаете эти функции как данность, вам не нужно беспокоиться о фундаментальной технологии - или вам нужно знать, как работает AWS от Amazon, чтобы использовать его?

### Transactions
### Транзакции

EN
A blockchain is a globally shared, transactional database. This means that everyone can read entries in the database just by participating in the network. If you want to change something in the database, you have to create a so-called transaction which has to be accepted by all others. The word transaction implies that the change you want to make (assume you want to change two values at the same time) is either not done at all or completely applied. Furthermore, while your transaction is being applied to the database, no other transaction can alter it.
RU
Блокчейн - это глобально общедоступная база данных транзакций. Т.е. каждый участник сети может читать записи этой в базе данных. Если вы хотите внести изменения в базу данных, вы должны создать так называемую транзакцию, которая должна быть принята всеми остальными участниками. Слово транзакция подразумевает, что изменение, которое вы хотите сделать(предположим, вы хотите изменить два значения одновременно), либо не будет сделано совсем, либо будет полностью применено.
Более того, пока ваша транзакция будет вноситься в базу данных, никакая другая транзакция не может ее изменить.

EN
As an example, imagine a table that lists the balances of all accounts in an electronic currency. If a transfer from one account to another is requested, the transactional nature of the database ensures that if the amount is subtracted from one account, it is always added to the other account. If due to whatever reason, adding the amount to the target account is not possible, the source account is also not modified.
RU
В качестве примера представьте себе таблицу, в которой перечислены остатки на всех счетах в электронной валюте. Если требуется перевести средства с одного счета на другой, транзакционная cущность базы данных гарантирует, что если сумма вычитается из одного счета, она всегда добавляется к другому счету. Если по какой-либо причине добавление суммы на целевой счет невозможно, исходный счет также не изменяется.

EN
Furthermore, a transaction is always cryptographically signed by the sender (creator). This makes it straightforward to guard access to specific modifications of the database. In the example of the electronic currency, a simple check ensures that only the person holding the keys to the account can transfer money from it.
RU
Кроме того, транзакция всегда криптографически подписывается отправителем (создателем). Это позволяет легко защитить возможность определенной модификации базы данных. В приведенном примере с электронной валютой, простая проверка гарантирует, что только человек, владеющий ключами от счета, может перевести с него деньги.

### Blocks
### Блоки

EN
One major obstacle to overcome is what (in Bitcoin terms) is called a “double-spend attack”: What happens if two transactions exist in the network that both want to empty an account? Only one of the transactions can be valid, typically the one that is accepted first. The problem is that “first” is not an objective term in a peer-to-peer network.
RU
Одним из основных трудносей, которое необходимо преодолеть, является то, что (в терминах Биткоина) называется "атакой двойного расходования". Что происходит, если в сети существуют две транзакции, которые обе хотят использовать один аккаунт? Только одна из этих транзакций может быть действительной, обычно эта та, которая принимается первой. Проблема в том, что "первая" не является объективным понятием в одноранговой сети.

EN
The abstract answer to this is that you do not have to care. A globally accepted order of the transactions will be selected for you, solving the conflict. The transactions will be bundled into what is called a “block” and then they will be executed and distributed among all participating nodes. If two transactions contradict each other, the one that ends up being second will be rejected and not become part of the block.
RU
Простым ответом на данный вопрос будет то, что вас это не должно волновать. Общий порядок подтверждения транзакций будет выбран за вас, разрешая конфликт. Транзакции будут объединены в так называемый "блок" и затем выполнены и распределены между всему участвующими нодами. Если две транзакции протеворечат друг другу, то та которая окажется второй, будет отклонена и не станет частью блока.
 
EN
These blocks form a linear sequence in time, and that is where the word “blockchain” derives from. Blocks are added to the chain at regular intervals, although these intervals may be subject to change in the future. For the most up-to-date information, it is recommended to monitor the network, for example, on Etherscan.
RU
Эти блоки образуют линейную последовательность во времени, и именно отсюда и происходит слово "блокчейн". Блоки добавляются в цепочку через регулярные промежутки времени, хотя эти промежутки могут быть изменены в будущем. Для получения наиболее актуальной информации, рекомендуется следить за сетью, например, с помощью Etherscan.

EN
As part of the “order selection mechanism” (which is called “mining”) it may happen that blocks are reverted from time to time, but only at the “tip” of the chain. The more blocks are added on top of a particular block, the less likely this block will be reverted. So it might be that your transactions are reverted and even removed from the blockchain, but the longer you wait, the less likely it will be.
RU
В рамках "закономерность порядка отбора" (который называется "майнинг")

EN
Note
Transactions are not guaranteed to be included in the next block or any specific future block, since it is not up to the submitter of a transaction, but up to the miners to determine in which block the transaction is included.
If you want to schedule future calls of your contract, you can use a smart contract automation tool or an oracle service.
RU