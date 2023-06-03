v0.8.20

## Types
## Типы

EN
Solidity is a statically typed language, which means that the type of each variable (state and local) needs to be specified. Solidity provides several elementary types which can be combined to form complex types.

RU
Solidity - статически типизованный язык, что означает, что тип каждый переменной(состояния или локальной) должен быть задан. Solidity предоставляет несколько элементарных типов, которые могут быть объединены в сложные типы.

EN
In addition, types can interact with each other in expressions containing operators. For a quick reference of the various operators, see Order of Precedence of Operators.

RU
Кроме того, типы могут взаимодействовать друг с другом в выражениях, содержащих операторы. Краткое описание различных операторов см. в разделе Порядок приоритета операторов.

EN
The concept of “undefined” or “null” values does not exist in Solidity, but newly declared variables always have a default value dependent on its type. To handle any unexpected values, you should use the revert function to revert the whole transaction, or return a tuple with a second bool value denoting success.

RU
Концепция "неопределенных"(undefined) и "null" значений не существуте в Solidity, но недавно объявленные переменные всегда имеют значение по умолчанию, зависящее от их типа. Для обработки любых неожиданных значений следует использовать функцию `revert` для отката всей транзакции, или возвращать кортеж со вторым значением типа `bool`, обозначающим успех.

## Value Types
## Типы значений

EN
The following are called value types because their variables will always be passed by value, i.e. they are always copied when they are used as function arguments or in assignments.

RU
Следующие типы называются типами значений, потому что их переменные всегда передаются по значению, то есть они всегда копируются, когда используются в качестве аргументов функций или в присваиваниях.

### Booleans
### Булевы

EN
bool: The possible values are constants true and false.

Operators:

- ! (logical negation)
- && (logical conjunction, “and”)
- || (logical disjunction, “or”)
- == (equality)
- != (inequality)

The operators || and && apply the common short-circuiting rules. This means that in the expression f(x) || g(y), if f(x) evaluates to true, g(y) will not be evaluated even if it may have side-effects.

RU
bool: Возможными значениями являются константы `true`и `false`.

Операторы:
- `!` (логическое отрицание)
- `&&` (логическая конъюнкция, "и")
- `||` (логическая дизъюнкция, "или")
- `==` (равенство)
- `!=` (неравенство)

Операторы `||` и `&&` применяют общие правила замыкания. Это означает, что в выражении `f(x) || g(y)`, если `f(x)` принимает значение `true`, `g(y)` не будет вычисляться, даже если оно может иметь побочные эффекты.

### Integers
### Целочисленные типы - Integers

EN
int / uint: Signed and unsigned integers of various sizes. Keywords uint8 to uint256 in steps of 8 (unsigned of 8 up to 256 bits) and int8 to int256. uint and int are aliases for uint256 and int256, respectively.

Operators:

- Comparisons: <=, <, ==, !=, >=, > (evaluate to bool)
- Bit operators: &, |, ^ (bitwise exclusive or), ~ (bitwise negation)
- Shift operators: << (left shift), >> (right shift)
- Arithmetic operators: +, -, unary - (only for signed integers), *, /, % (modulo), ** (exponentiation)

For an integer type X, you can use type(X).min and type(X).max to access the minimum and maximum value representable by the type.

RU
`int` / `unit`: Знаковые и беззнаковые целые числа различных размеров. Ключевые слова от `uint8` до `uint256` с шагом `8` (т.е. беззнаковые от 8 до 256 бит) и от `int8` до `int256`. `uint` и `int` - псевдонимы для `uint256` и `int256` соответственно.

Операторы:
- Сравнения: `<=`, `<`, `==`, `!=`, `>=`, `>` (возвращает тип bool)
- Побитовые операторы: `&`, `|`, `^`(побитовое исключающее "или"), `~` (побитовое отрицание)
- Побитовые операторы сдвига: `<<`(сдвиг влево), `>>` (сдвиг вправо)
- Арифметические операторы: `+`, `-`, унарный `-` (только для знаковых целых чисел) `*`, `/`, `%` (по модулю), `**` (возведение в степень)

Для целочисленного типа X можно использовать `type(X).min` и `type(X).max` для доступа к максимальному и минимальному значению, представляемому типом.

EN
> <o>⚠️ Warning</o>

Integers in Solidity are restricted to a certain range. For example, with uint32, this is 0 up to 2**32 - 1. There are two modes in which arithmetic is performed on these types: The “wrapping” or “unchecked” mode and the “checked” mode. By default, arithmetic is always “checked”, meaning that if an operation’s result falls outside the value range of the type, the call is reverted through a failing assertion. You can switch to “unchecked” mode using unchecked { ... }. More details can be found in the section about unchecked.

RU
> <o>⚠️ Предупреждение </o>
___
Целые числа в Solidity ограничены определенным диапазоном. Например, для `uint32` это диапазон от `0` до `2**32 - 1`. Существует два режима, в которых выполняются арифметические вычисления для этих типов: "оберточный"(?) или "непроверяемый" режим и "проверяемый" режим. По умолчанию арифметические действия всегда "проверяются", что означает, если результат операции выходит за пределы диапазона значений типа, вызов отменяется через ошибочное утверждение (assertion). Вы можете переключиться в режим "без проверки", используя `unchecked {...}`. Более подробную информацию можно найти в разеделе о `unchecked`.
___

### Comparisons
### Сравнения

EN
The value of a comparison is the one obtained by comparing the integer value.

RU
Значение сравнения - это значение, полученное при сравнении целочисленного значения. 

### Bit operations
### Побитовые операции

EN
Bit operations are performed on the two’s complement representation of the number. This means that, for example ~int256(0) == int256(-1).

RU
Побитовые операции выполняются над двоичным представлением числа. Это означает, что, например, `~int256(0) == int256(-1)`.

### Shifts
### Побитовые сдвиги

EN
The result of a shift operation has the type of the left operand, truncating the result to match the type. The right operand must be of unsigned type, trying to shift by a signed type will produce a compilation error.

Shifts can be “simulated” using multiplication by powers of two in the following way. Note that the truncation to the type of the left operand is always performed at the end, but not mentioned explicitly.

- x << y is equivalent to the mathematical expression x * 2**y.
- x >> y is equivalent to the mathematical expression x / 2**y, rounded towards negative infinity.

RU
Результат операции сдвига имеет тип левого операнда, при этом результат усекается, чтобы соответствовать типу. Правый операнд должен быть беззнакового типа, попытка сдвига на знаковый тип приведет к ошибке компиляции.

Свдиг можно "имитировать" с помощью умножения на степень двойки следующим образом. Обратите внимание, что усечение до типа левого операнда всегда выполняется в конце, но не упоминается в явном виде.

- `x << y` эквивалентно математическому выражению `x * 2**y`.
- `x >> y` равносильно математическому выражению `x / 2**y`, округленному с сторону отрицательной бесконечности.

EN
Warning

Before version 0.5.0 a right shift x >> y for negative x was equivalent to the mathematical expression x / 2**y rounded towards zero, i.e., right shifts used rounding up (towards zero) instead of rounding down (towards negative infinity).

RU
> <o>⚠️ Предупреждение </o>
___
До версии `0.5.0` свдиг вправо `x >>` для отрицательного `x` был эквивалентен математическому выражению `x / 2**y`, округленному в сторону нуля, т.е. свдиг вправо использовал округление вверх(в сторону нуля) вместо округления вниз(в сторону отрицательной бесконечности).
___


EN
Note

Overflow checks are never performed for shift operations as they are done for arithmetic operations. Instead, the result is always truncated.

RU
> <c>ℹ️ Примечание</c>
___
Проверка на переполнение никогда не выполняется для операций сдвига, как это делается для арифметических операций. Вместо этого результат всегда усекается.
___ 

### Addition, Subtraction and Multiplication
### Сложение, вычитание и умножение

EN
Addition, subtraction and multiplication have the usual semantics, with two different modes in regard to over- and underflow:

- By default, all arithmetic is checked for under- or overflow, but this can be disabled using the unchecked block, resulting in wrapping arithmetic. More details can be found in that section.

- The expression -x is equivalent to (T(0) - x) where T is the type of x. It can only be applied to signed types. The value of -x can be positive if x is negative. There is another caveat also resulting from two’s complement representation:
If you have int x = type(int).min;, then -x does not fit the positive range. This means that unchecked { assert(-x == x); } works, and the expression -x when used in checked mode will result in a failing assertion.

RU
Сложение, вычитание и умножение имеют обычную семантику/смысл, с двумя различными режимами в отношении переполнения и недозаполнения(?):
- По умолчанию все арифметические действия проверяются на недо- и переполнение, но это можно отключить с помощью блока `unchecked`, в результате чего арифметические вычисления будут обернуты. Более подробную информацию можно найти в этом(?) разделе.
- Выражение `-x` эквивалентно `(T(0) - x)` где `T` - тип `x`. Оно может применятся только к знаковым типам. Значение `-x` может положительным, если `x` отрицательно. Существует еще одна оговорка, также вытекающая из двоичного представления(?):
Если у вас `int x = type(int).min;`, то `-x` не входит в положительный диапазон. Это означает, что `unchecked { assert(-x == x); } работает, и выражение `-x` при использовании в проверенном режиме приведет к неудачному утверждению.

### Division
### Деление

EN
Since the type of the result of an operation is always the type of one of the operands, division on integers always results in an integer. In Solidity, division rounds towards zero. This means that int256(-5) / int256(2) == int256(-2).

Note that in contrast, division on literals results in fractional values of arbitrary precision.

RU
Поскольку тип результата операции всегда равен типу одного из операндов, при делении на целые числа всегда получается целое число. В Solidity деление округляется в сторону нуля. Это означает, что `int256(-5) / int256(2) == int256(-2)`.

Обратите внимание, что в отличие от этого, деление на литералы дает дробные значения произвольной точности.

EN
Note
Division by zero causes a Panic error. This check can not be disabled through unchecked { ... }.

RU
> <c>ℹ️ Примечание</c>
___
Деление на ноль вызывает ошибку `Panic`. Эта проверка не может быть отключена с помощью блока `unchecked {...}`.
___

EN
Note
The expression type(int).min / (-1) is the only case where division causes an overflow. In checked arithmetic mode, this will cause a failing assertion, while in wrapping mode, the value will be type(int).min.

RU
> <c>ℹ️ Примечание</c>
___
Выражение `type(int).min / (-1)` - единственный случай, когда деление вызывает переполнение. В режиме `checked` арифметический действий, это приведет к неудачному утверждению, а в режиме `wrapping`, значение будет `type(int).min`.
___

### Modulo
### Операция деление по модулю %

EN
The modulo operation a % n yields the remainder r after the division of the operand a by the operand n, where q = int(a / n) and r = a - (n * q). This means that modulo results in the same sign as its left operand (or zero) and a % n == -(-a % n) holds for negative a:

- int256(5) % int256(2) == int256(1)
- int256(5) % int256(-2) == int256(1)
- int256(-5) % int256(2) == int256(-1)
- int256(-5) % int256(-2) == int256(-1)

Note
Modulo with zero causes a Panic error. This check can not be disabled through unchecked { ... }.

RU
Операция деления по модулю `a % n` дает остаток `r` после деления операнда `a` на операнд `n`, где `q = int(a/n)` и `r = a - (n * q)`. Это означает, что при делении по модулю получается результат с тем же знаком, что и его левый операнд(или ноль), а для отрицательного `a` справедливо `a % n == -(-a % n)`:

- int256(5) % int256(2) == int256(1)
- int256(5) % int256(-2) == int256(1)
- int256(-5) % int256(2) == int256(-1)
- int256(-5) % int256(-2) == int256(-1)

> <c>ℹ️ Примечание</c>
___
Деление по модулю на ноль вызывает ошибку `Panic`. Эта проверка не может быть отключена с помощью блока `unchecked {...}`.
___

### Exponentiation
### Возведение в степень

EN
Exponentiation is only available for unsigned types in the exponent. The resulting type of an exponentiation is always equal to the type of the base. Please take care that it is large enough to hold the result and prepare for potential assertion failures or wrapping behaviour.

RU
Возведение в степень доступно только для беззнаковых типов через экспоненту. Тип результата возведения в степень всегда равен типу основания. Пожалуйста, позаботьтесь о том, чтобы он был достаточно большим для хранения результата, и приготовьтесь к возможным `assertion failures`(ошибкам утверждений) и `wrapping` поведению.

EN
Note
In checked mode, exponentiation only uses the comparatively cheap exp opcode for small bases. For the cases of x**3, the expression x*x*x might be cheaper. In any case, gas cost tests and the use of the optimizer are advisable.

RU
> <c>ℹ️ Примечание</c>
___
В режиме `checked`(проверки), возведение в степень использует сравнительно дешевый код операции `exp`, только для небольших оснований. Для случаев `x**3`, выражение `x*x*x` может быть дешевле. В любом случае, рекомендуется проводить тесты на стоимость газа и использовать оптимизатор.
___

EN
Note
Note that 0**0 is defined by the EVM as 1.

RU
> <c>ℹ️ Примечание</c>
___
Обратите внимание, что `0**0` определяется EVM как 1.
___

### Fixed Point Numbers
### Числа с фиксированной точкой(запятой)

EN
Warning
Fixed point numbers are not fully supported by Solidity yet. They can be declared, but cannot be assigned to or from.

fixed / ufixed: Signed and unsigned fixed point number of various sizes. Keywords ufixedMxN and fixedMxN, where M represents the number of bits taken by the type and N represents how many decimal points are available. M must be divisible by 8 and goes from 8 to 256 bits. N must be between 0 and 80, inclusive. ufixed and fixed are aliases for ufixed128x18 and fixed128x18, respectively.

Operators:

- Comparisons: <=, <, ==, !=, >=, > (evaluate to bool)
- Arithmetic operators: +, -, unary -, *, /, % (modulo)

RU
> <o>⚠️ Предупреждение </o>
___
Числа с фиксированной точкой еще не полностью поддерживаются Solidity. Они могут быть объявлены, но не могут присваиваться или извлекаться.
___

`fixed` / `ufixed`: знаковое и беззнаковое число с фиксированной точкой различных (типо)размеров. Ключевые слова `ufixedMxN` и `fixedMxN`, где `M` представляет количество бит, занимаемых типом, а `N` - количество десятичных точек. `M` должно быть крантно 8 и представляет собой число от 8 до 256 бит. `N` должно быть числом от 0 до 80 включительно. `ufixed` `fixed` псевдонимами для `ufixed128x18` и `fixed128x18`, соответственно.

Операторы:
- Сравнения: `<=`, `<`, `==`, `!=`, `>=`, `>` (возвращается тип bool)
- Арифметические операторы: `+`, `-`, унарный `-`, `*`, `/`, `%` (по модулю).

EN
Note
The main difference between floating point (float and double in many languages, more precisely IEEE 754 numbers) and fixed point numbers is that the number of bits used for the integer and the fractional part (the part after the decimal dot) is flexible in the former, while it is strictly defined in the latter. Generally, in floating point almost the entire space is used to represent the number, while only a small number of bits define where the decimal point is.

RU
> <c>ℹ️ Примечание</c>
___
Основые отличия между числами с плавающей точкой/запятой (float и double во многих языках, точнее, числами IEEE 754) и числами с фиксированной точкой/запятой заключаются в том, что количество байтов, используемых для целой и дробной частей(часть после десятичной точки), в превом случае является гибким, а во втором - строго определенным. Как правило, в числах с плавающей запятой для представления числа используется почти вся область, и только небольше количество байтов, определяет, где находится десятичная точка.
___

### Address
### Адрес

EN
The address type comes in two largely identical flavors:
- address: Holds a 20 byte value (size of an Ethereum address).
- address payable: Same as address, but with the additional members transfer and send.

RU
Тип адреса приходит в двух, практически идентичных, вариантах:
- `address`: Хранит значения размером 20 байт (размер Ethereum адреса).
- `address payable`: То же, что и `address`, но с дополнительными членами `transfer` и `send`.

EN
The idea behind this distinction is that address payable is an address you can send Ether to, while you are not supposed to send Ether to a plain address, for example because it might be a smart contract that was not built to accept Ether.

RU
Идея этого различия заключается в том, что `address payable` - это адрес, на который вы можете отправить Эфир, в то время как вы не должны отправлять Эфир на простой `address`, например, потому что это может быть смарт-контракт, который не был создан для приема Эфира.

EN
Type conversions:
- Implicit conversions from address payable to address are allowed, whereas conversions from address to address payable must be explicit via payable(<address>).
- Explicit conversions to and from address are allowed for uint160, integer literals, bytes20 and contract types.

RU
Преобразования типов:
- Неявные преобразования из `address payable` в `address` разрешены, тогда как преобразования из `address` в `address payable` должны быть явными через `payable(<address>)`.
- Явные преобразования в `address` и из `address` разрешены для `uint160`, целочисленных литералов, `bytes20` и типов контрактов(?).

EN
Only expressions of type address and contract-type can be converted to the type address payable via the explicit conversion payable(...). For contract-type, this conversion is only allowed if the contract can receive Ether, i.e., the contract either has a receive or a payable fallback function. Note that payable(0) is valid and is an exception to this rule.

RU
Только выражения типа `address` и тип-контракта(?) могут быть преобразованы к типу `address payable` через явное преобразование `payable(...)`. Для типа контракта это преобразование допустимо только в том случае, если контракт может получать Эфир, т.е. контракт либо имеет функцию получения, либо `payable` функцию возврата. Обратите внимание, что `payable(0)` допустимо и является исключением из этого правила.

EN
Note
If you need a variable of type address and plan to send Ether to it, then declare its type as address payable to make this requirement visible. Also, try to make this distinction or conversion as early as possible.\
The distinction between address and address payable was introduced with version 0.5.0. Also starting from that version, contracts are not implicitly convertible to the address type, but can still be explicitly converted to address or to address payable, if they have a receive or payable fallback function.

RU
> <c>ℹ️ Примечание</c>
___
Если вам нужна переменная типа `address` и вы планируете отправлять на нее Эфир, то объявите ее тип как `address payable`, чтобы сделать это требование явным/видимым. Кроме того, постарайте сделать это различие(свойство `payable`) или преобразование как можно раньше.

Различие между `address` и `address payable` было внесено в версии `0.5.0`.Также, начиная с этой версии, контракты неявно не конвертируются в тип `address`,но все еще могут быть конвертированы в тип `address` или `address payable` явно, если у них есть функция обратного получения или оплаты.
___

EN
Operators:
- <=, <, ==, !=, >= and >

Warning
If you convert a type that uses a larger byte size to an address, for example bytes32, then the address is truncated. To reduce conversion ambiguity, starting with version 0.4.24, the compiler will force you to make the truncation explicit in the conversion. Take for example the 32-byte value 0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC. \
You can use address(uint160(bytes20(b))), which results in 0x111122223333444455556666777788889999aAaa, or you can use address(uint160(uint256(b))), which results in 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc.

RU
Операторы:
- `<=`, `<`, `==`, `!=`, `>=` и `>`
> <o>⚠️ Предупреждение </o>
___
Если вы конвертируете тип, который больше в байтах по размеру, например `bytes32`, в `address`, то `address` будет усеченным/неполным. Чтобы уменьшить вероятность неоднозначного преобразования, начиная с версии 0.4.24, компилятор будет заствлять вас явно указывать усечении при преобразовании. Возьмем, например, 32-байтовое значение `0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC`.

Вы можете использовать `address(uint160(bytes20(b)))`, что даст результат `0x111122223333444455556666777788889999aAaa`, или вы можете использовать `address(uint160(uint256(b)))` и получить `0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc`.
___


EN
Note
Mixed-case hexadecimal numbers conforming to EIP-55 are automatically treated as literals of the address type. See Address Literals.

RU
> <c>ℹ️ Примечание</c>
___
Шестнадцатеричные числа в смешанном регистре, соответствующие EIP-55,  автоматически рассматриваются как литералы типа `address`. См. раздел адресные литералы.
___

### Members of Addresses
### Составляющие элементы адресов

EN
For a quick reference of all members of address, see Members of Address Types.
- `balance` and `transfer`

RU
Для быстрого ознакомления со всеми элементами адреса, обратитесь к списку 'Элементы `address` типов'
- `balance` и `transfer`

EN
It is possible to query the balance of an address using the property balance and to send Ether (in units of wei) to a payable address using the transfer function:


RU
Можно запросить баланс адреса с помощью свойства `balance` и отправить Эфир (в единицах `wei`) на `payable address` с помощью функции `transfer`:
```java
address payable x = payable(0x123);
address myAddress = address(this);
if (x.balance < 10 && myAddress.balance >= 10) x.transfer(10);
```

EN
The `transfer` function fails if the balance of the current contract is not large enough or if the Ether transfer is rejected by the receiving account. The `transfer` function reverts on failure.

RU
Функция `transfer`(перевода) завершается ошибкой, если балансе текущего контракта недостаточно средств или если `transfer`(перевод) Эфира отклонен принимающим аккаунтом(принимающей стороной).

EN
Note
If `x` is a contract address, its code (more specifically: its Receive Ether Function, if present, or otherwise its Fallback Function, if present) will be executed together with the `transfer` call (this is a feature of the EVM and cannot be prevented). If that execution runs out of gas or fails in any way, the Ether transfer will be reverted and the current contract will stop with an exception.

RU
> <c>ℹ️ Примечание</c>
Если `x` - это адрес контракта, то его код (точнее: его Функция Получения Эфира, если она есть, или, иначе, его `Fallback Function`(?)Резервная Функция/Функция отката, если она есть) будет выполнен вместе с вызовом `transfer`(это особенность EVM, и ее нельзя предотвратить(?)). Если в процессе выполнения закончится газ или произойдет какой-либо сбой, передача Эфира будет отменена, а текущий контракт будет остановлен с помощью ошибки-исключения.

- `send`

EN
`send` is the low-level counterpart of transfer. If the execution fails, the current contract will not stop with an exception, but send will return false.

RU
`send` - это низко-уровневый аналог `transfer`. При неудачном исходе перевода, текущий контракт не прервется с помощью исключения, а `send` вернет `false`.

EN
Warning
There are some dangers in using send: The transfer fails if the call stack depth is at 1024 (this can always be forced by the caller) and it also fails if the recipient runs out of gas. So in order to make safe Ether transfers, always check the return value of send, use transfer or even better: use a pattern where the recipient withdraws the money.

RU
> <o>⚠️ Предупреждение </o>
Использование `send` сопряжено с некоторыми рисками: Перевод не пройзойдет, если глубина стека вызовов будет равна 1024 (эта функция(?) всегда можеть быть принудительно выполнена вызывающей стороной), а также если у получателя закончится газ. Поэтому для безопасных переводов Эфира всегда проверяйте возвращаемое `send` значение, используйте `transfer` или даже лучше: используйте паттерн, в котором получатель выводит/забирает деньги.

EN
- `call`, `delegatecall` and `staticcall`

RU
- `call`, `delegatecall` и `staticcall`

EN
In order to interface with contracts that do not adhere to the ABI, or to get more direct control over the encoding, the functions call, delegatecall and staticcall are provided. They all take a single bytes memory parameter and return the success condition (as a bool) and the returned data (bytes memory). The functions abi.encode, abi.encodePacked, abi.encodeWithSelector and abi.encodeWithSignature can be used to encode structured data.

RU
Для взаимодействия с контрактами, которые не соответствуют/придерживаются ABI (?), или для получения прямого контроля над кодировкой предусмотрены функции `call`, `delegatecall` и `staticcall`. Все они принимают только один параметр типа `bytes memory` и возвращают состояние успешности операции (в виде bool) и данные(типа `bytes memory`). Функция `abi.encode`, `abi.encodePacked`, `abi.encodeWithSelector` и `abi.encodeWithSignature` могут быть использованы для кодирования структурированных данны.

Пример:
```java
bytes memory payload = abi.encodeWithSignature("register(string)", "MyName");
(bool success, bytes memory returnData) = address(nameReg).call(payload);
require(success);
```

EN
Warning
All these functions are low-level functions and should be used with care. Specifically, any unknown contract might be malicious and if you call it, you hand over control to that contract which could in turn call back into your contract, so be prepared for changes to your state variables when the call returns. The regular way to interact with other contracts is to call a function on a contract object (x.f()).

RU
> <o>⚠️ Предупреждение </o>
Все эти функции являются низкоуровневыми и должны использоваться с осторожностью. В частности, любой неизвестный контракт может быть вредоносным, и если вы вызываете его, вы тем самым передаете этому контракту управление, который в свою очередь может вызвать обратно ваш контракт, поэтому будьте готовы к изменениям в ваших переменных состояния после возварата вызова(?). Обычным способом взаимодействия с другими контрактами является вызов функции объекта контракта (`x.f()`).

EN
Note
Previous versions of Solidity allowed these functions to receive arbitrary arguments and would also handle a first argument of type bytes4 differently. These edge cases were removed in version 0.5.0.

RU
> <c>ℹ️ Примечание</c>
Предыдущие версии Solidity позволяли этим функциям принимать произвольные аргументы, а также по-разному обрабатывали первый аргумент типа `bytes4`. Эти случаи были устранены начиная с версии 0.5.0.

EN
It is possible to adjust the supplied gas with the gas modifier:
```java
address(nameReg).call{gas: 1000000}(abi.encodeWithSignature("register(string)", "MyName"));
```
Similarly, the supplied Ether value can be controlled too:
```java
address(nameReg).call{value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));
```
Lastly, these modifiers can be combined. Their order does not matter:
```java
address(nameReg).call{gas: 1000000, value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));
```

RU

EN
In a similar way, the function delegatecall can be used: the difference is that only the code of the given address is used, all other aspects (storage, balance, …) are taken from the current contract. The purpose of delegatecall is to use library code which is stored in another contract. The user has to ensure that the layout of storage in both contracts is suitable for delegatecall to be used.

RU
Аналогичным образом можно использовать

EN
Note
Prior to homestead, only a limited variant called callcode was available that did not provide access to the original msg.sender and msg.value values. This function was removed in version 0.5.0.

RU

EN
Since byzantium staticcall can be used as well. This is basically the same as call, but will revert if the called function modifies the state in any way.

All three functions call, delegatecall and staticcall are very low-level functions and should only be used as a last resort as they break the type-safety of Solidity.

The gas option is available on all three methods, while the value option is only available on call.

RU

EN
Note
It is best to avoid relying on hardcoded gas values in your smart contract code, regardless of whether state is read from or written to, as this can have many pitfalls. Also, access to gas might change in the future.

RU