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
В рамках "механизма отбора порядка"(?) (который называется "майнинг") время от времени может происходить откатывание(отмена) блоков, но только в конце(?) цепочки. Чем больше блоков добавляется поверх определенного блока, тем меньше вероятность того, что этот блок будет не принят. Поэтому может случится так, что ваши транзакции будут отменены и даже удален из блокчейна, но чем дольше вы ждете, тем меньше вероятность что это произойдет.

EN
Note
Transactions are not guaranteed to be included in the next block or any specific future block, since it is not up to the submitter of a transaction, but up to the miners to determine in which block the transaction is included.
If you want to schedule future calls of your contract, you can use a smart contract automation tool or an oracle service.
RU
---
> **_Примечание:_**
Нет гарантии, что транзакции будут включены в следующий блок или любой конкретный блок в будущем, поскольку не отправитель транзакции, а майнеры определяют, в какой блок будет включена транзакция.
Если вы хотите запланировать в будущем вызывать функции вашего контракта(?), вы можете использовать инструменты автоматизации смарт-контракта или службу oracle.
___

EN
### The Ethereum Virtual Machine
#### Overview
RU
## Виртуальная машина Ethereum
### Обзор

EN
The Ethereum Virtual Machine or EVM is the runtime environment for smart contracts in Ethereum. It is not only sandboxed but actually completely isolated, which means that code running inside the EVM has no access to network, filesystem or other processes. Smart contracts even have limited access to other smart contracts.
Accounts
\
RU
Виртуальная машина Ethereum или EVM - это среда выполнения смарт-контрактов в Ethereum. Это не только "песочница", но и полностью изолированная среда, что означает, что код запускается внутри EVM, не имея доступа к сети, файловой системе или другим процессам. И смарт-контракты имеют ограниченный доступ к другим смарт-контрактам.

EN
There are two kinds of accounts in Ethereum which share the same address space: External accounts that are controlled by public-private key pairs (i.e. humans) and contract accounts which are controlled by the code stored together with the account.
\
RU
В Ethereum существует два вида аккаунтов, которые разделяют одно и то же адресное пространство: внешние аккаунты, которые управляются парами открытых и закрытых ключей(т.е. людьми) и аккаунты контрактов, которые управляются кодом, хранящимся вместе с аккаунтом.

EN
The address of an external account is determined from the public key while the address of a contract is determined at the time the contract is created (it is derived from the creator address and the number of transactions sent from that address, the so-called “nonce”).
\
RU
Адрес внешнего аккаунта задается из открытого ключа, в то время как адрес контракта задается в момент его создания (он выводится из адреса создателя контракта и количества транзакций, отправленных с этого адреса, так называемого "nonce")
___
Nonce - порядковый номер транзакций, отправленных с данного адреса. При каждой отправке транзакции значение Nonce увеличивается на единицу. Кроме того, Nonce предотвращает повторную атаку: злоумышленник может захотеть исполнить подписанную транзакцию еще раз, однако при валидации Nonce транзакции и текущий Nonce аккаунта будут не совпадать и транзакция будет считаться не валидной.
___

EN
Regardless of whether or not the account stores code, the two types are treated equally by the EVM.
\
RU
Независимо от того, хранит ли аккаунт код или нет, эти два типа аккаунтов рассматриваются EVM одинаково.

EN
Every account has a persistent key-value store mapping 256-bit words to 256-bit words called storage.
\
RU
Каждая учетная запись имеет постоянное хранилище значений ключа, сопоставляющее 256-битные слова с 256-битными словами, называемыми хранилищем.


EN
Furthermore, every account has a balance in Ether (in “Wei” to be exact, 1 ether is 10**18 wei) which can be modified by sending transactions that include Ether.
\
RU
Кроме того, каждый аккаунт имеет баланс в Эфире (точнее, в "вэях", 1 эфир равен 10 ** 18 wei), который может быть изменен путем отправки тразакций, включающих Эфир.

### Transactions
### Транзакции

EN
A transaction is a message that is sent from one account to another account (which might be the same or empty, see below). It can include binary data (which is called “payload”) and Ether.
\
RU
Транзакция - это информация, которая отправляется с одного аккаунта на другой (аккаунт может быть одним и тем же или пустым, см. ниже). Транзакциия может включать двоичные данные (котоыре называются "полежной нагрузкой") и Эфир.

EN
If the target account contains code, that code is executed and the payload is provided as input data.
\
RU
Если целевой аккаунт содержит код, то этот код выполняется и `payload` передается в качестве входных данных.

EN
If the target account is not set (the transaction does not have a recipient or the recipient is set to null), the transaction creates a new contract. As already mentioned, the address of that contract is not the zero address but an address derived from the sender and its number of transactions sent (the “nonce”). The payload of such a contract creation transaction is taken to be EVM bytecode and executed. The output data of this execution is permanently stored as the code of the contract. This means that in order to create a contract, you do not send the actual code of the contract, but in fact code that returns that code when executed.
\
RU
Если целевой аккаунт не указан (у транзакции нет получателя или получателю присовено null), транзакция создает новый контракт. Как уже упоминалось, адресом этого контракта является не нулеовй дарес, а адрес, полученный из адреса отправителя и номера количества отправленных им транзакций ("nonce"). `payload` такой транзакции, создающей контракт, принимается EVM за байткод и исполняется. Выходные данные этого выполнения хранятся постоянно в виде кода контракта. Это означает, что для создания контракта вы отправляете не фактический код контракта, а код, который возвращает этот код при выполнении.

EN
Note

While a contract is being created, its code is still empty. Because of that, you should not call back into the contract under construction until its constructor has finished executing.
\
___
RU
#### Примечание
Пока контракт создается, его код еще пуст. Поэтому не следуюет обращаться к создаваемому контракту до тех пор, пока его конструктор не закончит выполнение.
___

### Gas
### Газ

EN
Upon creation, each transaction is charged with a certain amount of gas that has to be paid for by the originator of the transaction (tx.origin). While the EVM executes the transaction, the gas is gradually depleted according to specific rules. If the gas is used up at any point (i.e. it would be negative), an out-of-gas exception is triggered, which ends execution and reverts all modifications made to the state in the current call frame.
\
RU
При создании, c каждой транзакции взымается плата в виде определенного количества газа, который вносится инициатором транзакции (`tx.origin`). Пока EVM выполняет эту транзакцию, газ расходуется постепенно в соответсвии с определенными правилами. Если в какой-то момент газ израсходован (т.е. стал бы отрицательным), срабатывает исключение `газ-закончился`, которое завершает выполнение транзакции и откатываем все изменения, внесенные в состояние в рамках текущего вызова.

EN
This mechanism incentivizes economical use of EVM execution time and also compensates EVM executors (i.e. miners / stakers) for their work. Since each block has a maximum amount of gas, it also limits the amount of work needed to validate a block.
\
RU
Этот механизм стимулирует экономное использование ресурсов EVM, а также оплачивает работу исполнителей EVM (т.е. майнеров / стейкеров). Поскольку каждый блок имеет максимальное количество газа, это также ограничивает объем работы, необходимой для валидации блока(?).

EN
The gas price is a value set by the originator of the transaction, who has to pay gas_price * gas up front to the EVM executor. If some gas is left after execution, it is refunded to the transaction originator. In case of an exception that reverts changes, already used up gas is not refunded.
\
RU
Цена газа - значение, которое устанавливается инициатором транзакции, который должен заплатить вперед `gas_price * gas` исполнителю EVM. Если после выполнения транзакции остается какое-то количество газа, он возвращается инициатору транзакции.

EN
Since EVM executors can choose to include a transaction or not, transaction senders cannot abuse the system by setting a low gas price.
\
RU
Поскольку исполнители EVM могу выбирать принимать ли транзакцию в блок или нет, отправители транзакций не могут злоупотреблять системой, устанавливая низкую цену на газ.

### Storage, Memory and the Stack
### Хранение, Память и Стек

EN
The Ethereum Virtual Machine has three areas where it can store data: storage, memory and the stack.
\
RU
Виртуальная машина Ethereum имеет три области для хранения данных: хранилище, память и стек.

EN
Each account has a data area called storage, which is persistent between function calls and transactions. Storage is a key-value store that maps 256-bit words to 256-bit words. It is not possible to enumerate storage from within a contract, it is comparatively costly to read, and even more to initialise and modify storage. Because of this cost, you should minimize what you store in persistent storage to what the contract needs to run. Store data like derived calculations, caching, and aggregates outside of the contract. A contract can neither read nor write to any storage apart from its own.
\
RU
Каждый аккаунт имеет область данных, называемую **хранилищем**, которая сохраняется между вызовами функций и транзакциями. Хранилище представляет собой хранилище значений ключей, сопостовляющее 256-битные слова с 256-битными словами. Невозможно "перебрать" хранилище внутри контракта, и его стравнительно дорого читать и тем более инициализировать и изменять это хранилище. Из-за такой стоимости, вам следует свести к минимуму хранение данных в постоянном хранилище и использовать в работе контракта только самое необходимое. Храните такие данные, как производные вычисления, кэширование и совокупные элементы/агрегаты вне контракта(?). Контракт не может ни читать, ни записывать ни в какое другое хранилище, кроме своего собственного.

EN
The second data area is called memory, of which a contract obtains a freshly cleared instance for each message call. Memory is linear and can be addressed at byte level, but reads are limited to a width of 256 bits, while writes can be either 8 bits or 256 bits wide. Memory is expanded by a word (256-bit), when accessing (either reading or writing) a previously untouched memory word (i.e. any offset within a word). At the time of expansion, the cost in gas must be paid. Memory is more costly the larger it grows (it scales quadratically).
\
RU
Вторая область данных называется собственно **памятью**, из которой контракт получает только "очищенный" экземпляр объекта для каждого вызова сообщения. Память является линейной и может адресоваться на уровне байтов, но чтение ограничено шириной в 256 бит, тогда как запись может быть либо 8-битного, либо 256-битного формата. Память расширяется до одного слова (256-бит) при обращении (чтении или записи) к памяти ранее незатронутой, размером со слово (т.е. к любому смещению внутри слова). В момент расширения памяти, необходимо оплатить стоимость газа(?). Чем больше используется памяти, тем она обходится дороже (квадратичный рост).

EN
The EVM is not a register machine but a stack machine, so all computations are performed on a data area called the stack. It has a maximum size of 1024 elements and contains words of 256 bits. Access to the stack is limited to the top end in the following way: It is possible to copy one of the topmost 16 elements to the top of the stack or swap the topmost element with one of the 16 elements below it. All other operations take the topmost two (or one, or more, depending on the operation) elements from the stack and push the result onto the stack. Of course it is possible to move stack elements to storage or memory in order to get deeper access to the stack, but it is not possible to just access arbitrary elements deeper in the stack without first removing the top of the stack.
\
RU
EVM - это не регистровое, а стековое устройство, поэтому все вычисления выполняются в области данных, называемой **стеком**. Стек имеет максимальный размер - 1024 элемента и содержит слова из 256 бит. Доступ к стеку ограничивается верхней планкой следующим образом: возможно скопировать один из самых верхних 16 элементов в верхнюю часть стека или заменить верхний элемент одним из 16 элементов под ним. Все остальные операции берут верхние два (или один или более, в зависимости от операции) элемента из стека и помещают результат в стек. Конечно, можно перемещать элементы стека в хранилище или в память, дабы получить более глубокий доступ к стеку, но невозможно просто получить доступ к произвольным элементам глубоко в стеке, не удалив сначала верхнюю часть стека.

___
**Стек** представляет структуру данных, которая позволяет управлять регистрами между вызовами функций, а также управлять памятью в процессе вызова функции. Стек работает по принципу LIFO (last in first out - последний вошел, первый вышел). Это значит, что первым извлекается из стека тот элемент, который был добавлен последним. Стек подобен стопке тарелок - каждую новую тарелку кладут поверх предыдущей и, наоборот, сначала берут самую верхнюю тарелку.
___


### Instruction Set
### Набор инструкций

EN
The instruction set of the EVM is kept minimal in order to avoid incorrect or inconsistent implementations which could cause consensus problems.All instructions operate on the basic data type, 256-bit words or on slices of memory (or other byte arrays).The usual arithmetic, bit, logical and comparison operations are present. Conditional and unconditional jumps are possible. *Furthermore, contracts can access relevant properties of the current block like its number and timestamp.*

RU
Набор команд EVM сведен к минимуму, чтобы избежать неправильных и непоследовательных реализаций, которые могут вызвать проблемы с консенсусом. Все инструкции работают с базовым типом данных, то есть 256-битными словами или фрагментами памяти (или другими массивами байтов).Присутствуют обычные арифметические, битовые, логические операции и операции сравнения. Возможны условные и безусловные переходы. Кроме того, контракты могут получить к соответствующим свойствам текущего блока, таким как номер блока и отметка времени.

___
**Безусловные переходы** обеспечивают передачу управления по заданному адресу независимо от каких либо условий. Можно сравнить такие команды переходов с оператором GOTO, который редко можно встретить в современных программах, но который раньше применялся повсеместно. Языки высокого уровня стали структурированными, а вот о командах процессоров такого сказать нельзя. Поэтому команды безусловной передачи управления остаются необходимыми.

**Условные** переходы обеспечивают передачу управления в зависимости от соблюдения одного, или нескольких, условий. Их можно сравнить с оператором IF, хотя аналогия будет не полной. Машинные команды условного перехода обычно выполняют проверку флагов состояния и выполняют переход, если условия соблюдены. Если же условия не соблюдены, то переход не выполняется

[Ссылка на статью](https://dzen.ru/a/Xxk-dJUD1FzAk_jx)
___

EN
For a complete list, please see the list of opcodes as part of the inline assembly documentation.

RU
Полный перечень инструкций можно найти в списке кодов операций в составе документации по встроенному ассемблеру(?).

### Message Calls
### Вызовы сообщений (!?)

EN
Contracts can call other contracts or send Ether to non-contract accounts by the means of message calls. Message calls are similar to transactions, in that they have a source, a target, data payload, Ether, gas and return data. In fact, every transaction consists of a top-level message call which in turn can create further message calls.

RU
Контракты могут вызывать другие контракты или отправлять Эфир на аккаунты не относящиеся к контрактам, посредством вызовов сообщений(?). Вызовы сообщений(?) похожи на транзакции, поскольку они имеют источник, цель, полезную нагрузку `payload`, Эфир, газ и возвращают данные. Фактически, каждая транзакция состоит из вызова сообщения верхнего уровня, который, в свою очередь, может создавать другие вызовы сообщений(?).

EN
A contract can decide how much of its remaining **gas** should be sent with the inner message call and how much it wants to retain. If an out-of-gas exception happens in the inner call (or any other exception), this will be signaled by an error value put onto the stack. In this case, only the gas sent together with the call is used up. In Solidity, the calling contract causes a manual exception by default in such situations, so that exceptions “bubble up” the call stack.

RU
Контракт может определить, сколько оставшегося у него газа должно быть отправлено с внутренним вызовом сообщения и сколько он хочет оставить себе. Если во внутреннем вызове произойдет исключение газ-закончился(или любое другое исключение), об этом будет сигнализировать значение ошибки, помещенное в стек. В таком случае, расходуется только тот газ, который был отправлен вместе с вызовом сообещния(?). В Solidity, вызывающий контракт по умолчанию в таких ситуациях вызывает ручное исключение, так что исключения "всплывают" в стеке вызовов.(?)

EN
As already said, the called contract (which can be the same as the caller) will receive a freshly cleared instance of memory and has access to the call payload - which will be provided in a separate area called the **calldata**. After it has finished execution, it can return data which will be stored at a location in the caller’s memory preallocated by the caller. All such calls are fully synchronous.

RU - !? bad
Как уже было сказано, вызываемый контракт (который может быть таким же, что и вызывающий контракт) получит только что особожденный экземпляр памяти и будет иметь доступ к `payload` вызова - которая будет представлена в отдельной области, называемой **calldata**. После завершения выполнения контракта, он может вернуть данные которые будут сохранены в предварительно выделенной памяти на стороне исполнителя контракта. Все такие вызовы являются синхронными.


EN
Calls are **limited** to a depth of 1024, which means that for more complex operations, loops should be preferred over recursive calls. Furthermore, only 63/64th of the gas can be forwarded in a message call, which causes a depth limit of a little less than 1000 in practice.

RU (?)
Глубина вызовов ограничена 1024, что означает, что для более сложных операций, следует предпочесть циклы, а не рекурсивные вызовы. Кроме того, только 63/64-ая часть газа может быть отправлена в вызове сообщения, что на практике приводит к ограничению глубины чуть меньше 1000.(?)

### Delegatecall and Libraries
### Вызыовы делегатов и библиотеки

EN
There exists a special variant of a message call, named **delegatecall** which is identical to a message call apart from the fact that the code at the target address is executed in the context (i.e. at the address) of the calling contract and `msg.sender` and `msg.value` do not change their values.

RU ? Bad
Существует отдельный способ вызова сообщения, называемый **delegatecall**, *который идентичен вызову сообщения, за исключением того, что код по целевому адресу(адрес получателя, конечный адрес) выполняется в контексте (т.е. по адресу) вызывающего контракта*, а `msg.sender` и `msg.value` не меняют своих значений.

EN
This means that a contract can dynamically load code from a different address at runtime. Storage, current address and balance still refer to the calling contract, only the code is taken from the called address.

RU
Это означает, что контракт может динамически загрузить код с другого адреса во время выполнения. Хранилище, текущий адрес и баланс по-прежнему ссылаются на вызывающий контракт, только код будет браться из взятого вызываемого адреса.

EN
This makes it possible to implement the “library” feature in Solidity: Reusable library code that can be applied to a contract’s storage, e.g. in order to implement a complex data structure.

RU
Это позволяет реализовать в Solidity функцию "библиотеки": т.е. повторно использовать код библиотеки, который может быть применен к хранилищу контракта, например, для реализации сложной структуры данных.

EN
### Logs
### Логи

EN
It is possible to store data in a specially indexed data structure that maps all the way up to the block level. This feature called logs is used by Solidity in order to implement events. Contracts cannot access log data after it has been created, but they can be efficiently accessed from outside the blockchain. Since some part of the log data is stored in bloom filters, it is possible to search for this data in an efficient and cryptographically secure way, so network peers that do not download the whole blockchain (so-called “light clients”) can still find these logs.

RU
Существует возможность хранить данные в специальной индексированной структуре данных, которая отображается вплоть до уровня блока. Эта возможность, называемая журналами, используется Solidity для реализации событий. Контракты не могут получить доступ к журнальным данным после их создания, но к ним можно получить эффективный доступ извне блокчейна. Поскольку часть данных журнала хранится в фильтрах bloom, поиск этих данных можно осуществлять эффективным и криптографически безопасным способом, поэтому сетевые коллеги, которые не загружают весь блокчейн (так называемые "легкие клиенты"), все равно могут найти эти журналы.

### Create
### Создавать

EN
Contracts can even create other contracts using a special opcode (i.e. they do not simply call the zero address as a transaction would). The only difference between these create calls and normal message calls is that the payload data is executed and the result stored as code and the caller / creator receives the address of the new contract on the stack.

RU +
Контракты могут даже создавать другие контракты, используя специальный опкод (т.е. они не просто вызывают нулевой адрес, как это сделала бы транзакция). Единственная разница между этими вызовами создания и обычными вызовами сообщений заключается в том, что `payload` данные выполняются и результат сохраняется в виде кода, а вызывающий/создающий контракт получает адрес нового контракта в стеке.

### Deactivate and Self-destruct
### Деактивация и самоуничтожение

EN
The only way to remove code from the blockchain is when a contract at that address performs the `selfdestruct` operation. The remaining Ether stored at that address is sent to a designated target and then the storage and code is removed from the state. Removing the contract in theory sounds like a good idea, but it is potentially dangerous, as if someone sends Ether to removed contracts, the Ether is forever lost.

RU ?
Единственный способ удалить код из блокчейна - это когда контракт по этому адресу выполняет операцию `selfdestruct`. Оставшийся Эфир, хранящийся по этому адресу, отправялется на предусмотренный разработчиком адрес, а затем само хранилище и код удаляются из состояни(?). Теоретически вроде бы удаление контракта хорошая идея, но небезопасная, так как если кто-то отправит Эфир на удаленные контракт, этот Эфир будет навсегда потерян.

EN
Warning

From version 0.8.18 and up, the use of `selfdestruct` in both Solidity and Yul will trigger a deprecation warning, since the `SELFDESTRUCT` opcode will eventually undergo breaking changes in behaviour as stated in EIP-6049.

RU
> <o>⚠️ Предупреждение</o>
___
Начиная с версии 0.8.18 и выше, использование `selfdestruct` как в Solidity так и в Yul вызовет предупреждение, что операция устарела, поскольку код операции `SELFDESTRCUT` со временем претерпел серьезные изменения в поведении, как указано в EIP-6049.
___

EN
Warning

Even if a contract is removed by `selfdestruct`, it is still part of the history of the blockchain and probably retained by most Ethereum nodes. So using `selfdestruct` is not the same as deleting data from a hard disk.

RU
> <o>⚠️ Предупреждение</o>
___
Если даже контракт удаляетя инструкцией `selfdestruct`, он все равно остается частью истории блокчейна и, вероятно, сохраняется на большенстве узлов Ethereum. Поэтому использование `selfdestruct` - это не то же самое, что удаление данных с жесткого диска.
___

EN
Note

Even if a contract’s code does not contain a call to `selfdestruct`, it can still perform that operation using `delegatecall` or `callcode`.

If you want to deactivate your contracts, you should instead **disable** them by changing some internal state which causes all functions to revert. This makes it impossible to use the contract, as it returns Ether immediately.

RU
> <c>ℹ️ Примечание</c>
___
Даже если код контракта не содержит вызова `selfdestruct`,  он все равно может выполнить эту операцию с помощью `delegatecall` или `callcode`.

Если Вы хотите деактивировать свои контракты, то вместо этого вам следует **отключения** их путем изменения некоторого внутреннего состояния, которое вызывает возврат всех функций. Это делает невозможным использование контракта, так как он немедленно возвращает Эфир.
___

### Precompiled Contracts
### Предварительно скомпилированные контракты

EN
There is a small set of contract addresses that are special: The address range between `1` and (including) `8` contains “precompiled contracts” that can be called as any other contract but their behaviour (and their gas consumption) is not defined by EVM code stored at that address (they do not contain code) but instead is implemented in the EVM execution environment itself.

RU
Сущевстует небольшой набор адресов контрактов, которые имеют специальное назначение: Диапазон адресов между `1` и `8`(включительно) содержит "предкомпилированные контракты", которые могут быть вызваны как любой другой контракт, но их поведение (и расход газа) не определяется кодом EVM, хранящимся по этому адресу (они не содержать кода), а реализуется в самой среде выполнения EVM.

EN
Different EVM-compatible chains might use a different set of precompiled contracts. It might also be possible that new precompiled contracts are added to the Ethereum main chain in the future, but you can reasonably expect them to always be in the range between `1` and `0xffff` (inclusive).

RU
Различные EVM-совместимые цепочки могут использовать разный набор предварительно скомпилированных контрактов. Также возможно, что в будущем в гавную цепочку Ethereum будут добавлены еще новые предваретльно скомпилированные контракты, но вы можете обоснованно ожидать, что они всегда буду находиться в диапазоне от `1` до `0xffff` (включительно).


${\color{green}GREEN}$
${\color{red}Red}$
${\color{lightgreen}Light Green}$
${\color{blue}Blue}$
${\color{cyan}Cyan}$
${\color{#ffffff}White}$
${\color{lightblue}Light Blue}$
${\color{black}Black}$
${\color{white}White}$
${\color{yellow}Yellow}$
${\color{orange}Orange}$
