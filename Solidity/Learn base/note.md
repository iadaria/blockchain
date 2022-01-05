https://www.theunitconverter.com/

# Оптимизация
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
- 

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