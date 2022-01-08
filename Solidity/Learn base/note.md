https://www.theunitconverter.com/

# Токены
Токен - цифровой актив, простроенный поверх какой-либо криптовалюты, который может служить как средство обмена
Типы токенов:
- usage tokens - ведут как внутренняя валюта нашего приложения Заплатив их вызываем ту или иную функцию
- work tokens - идентифицируют владельца как того кому принадлежит какая-то часть функционала, или принадлежит право
голоса, от того какой у вас процент токенов у вас есть такая же доля функционала приложения, права количество голосов
DAO - есть возможность голосования

## Базовые токены - обязательные моменты
1. mapping(address=>uint) Хранение баланса - используется mapping (ассоциативный массив)
0x3528b07D1e561b9a51c9f094a00482c70E531251 -> 20 eth
0xdAC17F958D2ee523a2206206994597C13D831ec7 -> 0.1 eth
2. f(адрес - кому перечислять, число) Функция отправки средств - она изменяет значения в mapping для хранения баланса
В стандартной реалзиации она списывает N токенов с адреса того, кото вызывает функцию, и  отправляет это N
тому, кого указал отправитель
У нас есть 3 параметра в функции:
message.sender - отправитель
20 eth - 1 -> 0.1 eth + 1

# Библиотеки
Расширить стандартную функциональность и добавить новые типы
Подключение:
- с помощью исходного кода
- github
Использование:
- использовать 'using for' после нашего типа данных
Например для работы с типом map, мы не можем просто пройтись поэтому используем специальные библиотеки

# Ораклайзеры
Сервисы, которые предоставляют возможность забрать какие-либо данные из интернета, которые найти в блокчейне эффириуме у вас
не получится
- Например, необходимо узнать курс доллара к рублю или эфиру
Поэтому в эфириуме нельзя реализовать алгоритм случайных чисел - для проверки блока
1 Архитектура Oracles
Например www.oraclize.it - серверу нужен адреса смарт-контракта и сам запрос на действие
2 Использование
- генерация случайных чисел
- сложные матетматические вычисления, с точки зрения математики(выносим на внешний сервис), как правила пишем сами свой 
ораклайзер
- информация о курсе валют

# Оптимизация платы
1 State modifictions - изменения состояния стоить газ
- запись в state variables - стоит газа, когда данные перезаписываем, добавляем в массив, 
создание переменных(когда инициализируем) - т/к увеличиваем количество данных и меняем состояние блокчейна
- emitting events - вызов событий, стоит средств т/к хранится в блокчейне Ивенты позволяют не заходить постоянно
в etherscan, а сразу получать данные об изменениях
- .selfdesctruct() - уничтожить смарт-контракт, т/е чтобы по этому адресу не хранилось больше ничего - уничтожить все данные
Вызов тоже стоит газа
- отправка эфиров - тоже стоит средств(транзакция)
- создание других smart-contrac-ов внутри другого - стоит газа
- любые функции без pure или view - платим газ, EVM не знает меняет ли эти функции состояния, поэтому заранее выделяет газ
то за вызов этих функций(без) платим газ
2 Оптимизация - Constant
- т/е переменная не будет изменяться - будем экономно использовать ресурсы
3 Оптимизация - View
- говорим EVM что мы никаких действию по изменению производить не будем
4 Pure

# Оптимизация разработки
1 Abstract contracts
2 Interfaces
- Cannot define constructor
- Cannot define structs
- Cannot define enums
- Cannot inherit other contracts or interfaces
Дешевле и меньше кода

# Smart-contract
После деплоя через Remix создаем наблюдение за контрактом на https://wallet.ethereum.org/
И копируем туда его адрес и abi

# Обработка ошибок

### assert(bool condition)
Используется, когда часть контракта уже выполнена, но логика нарушено и нужно откатить все назад
Будто функция никогда не вызывалась

### require(bool condition) throws if the condition is not met to be used for errors in inputs or external components
Проверка ввода данных пользователя
Лучше газ вернуть
Состояние тоже откатывается
assert в пустую сгорит весь газ

### revert() - abort executioin and revert state changes
По максимуму вернуть газ пользователю и откатить изменения
До активации функции
В случае наступления условий откаываем и возвращаем газ пользователю

function ... {
    require()
    ...
    ...
    assort()
    ...
    if ...
    if ...
    else { revert(); }
}

# pay

1 fineey = 0.001 Ether

# time
1 == 1 seconds
1 minutes == 60 seconds
1 hours == 60 minutes
1 days == 24 hours
1 weeks == 7 days
1 years == 365 days

# Данные транзакций
### msg.data(bytes): complete calldata
Входящие данные, которые нам пересылаются для нашей транзации

### msg.gas(unit): remaining gas
Сколько газа осталось для обработки сообщения

### msg.sender(address): sender of the message(current call)
Адрес того, кто отправил транзакцию

### msg.sig(bytes4): first four bytes of the calldata(i.e function identifier)
Первые 4 байта из транзакции; чтобы индентифицировать ту функцию которая вызывается
И проверить есть ли у пользователя права на вызов этой функции

### msg.value(uint): number of wei sent with the message
Вернет количестов wei которое было отрпавлено вместе с транзакцией
Количество wei

# Данные из блокчейна

Через solidity получить не можем, получаем через web3 например

### block.blockhash(uint blockNumber) returns(byte32) hash of the given block
only works for 256 most recent blocks excluding current
Посмотреть хэш 256 раз

### block.coinbase(address): current block miner's address
Вернет адрес майнера текущего блока

### block.difficulty(uint): current block difficulty
Сложность блока. Насколько сложно смайнить этот блок

### block.gaslimit(uint): current block gaslimit
Сколько у блока есть газа, 
из-за маленького лимита газа
транзакция забирает много газа сама
Можно посмотреть лимит газа и транзакцию не вызывать, и мы знаем, что транзакция 
не выполнится. Транзакция съедаем много газа сама.

### block.number(uint): current block number
Получаем номер текущего блока

### block.timestamp(uint): current block timestamp as seconds since unix epoch(now)