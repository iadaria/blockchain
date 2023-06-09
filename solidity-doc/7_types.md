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
Можно корректировать подаваемый газ с помощью модификатора газа:
```java
address(nameReg).call{gas: 1000000}(abi.encodeWithSignature("register(string)", "MyName"));
```
Аналогичным образом можно управлять и значением поставляемого эфира:
```java
address(nameReg).call{value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));
```
Наконец, эти модификаторы можно комбинировать. Их порядок не имеет значения:
```java
address(nameReg).call{gas: 1000000, value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));
```

EN
In a similar way, the function delegatecall can be used: the difference is that only the code of the given address is used, all other aspects (storage, balance, …) are taken from the current contract. The purpose of delegatecall is to use library code which is stored in another contract. The user has to ensure that the layout of storage in both contracts is suitable for delegatecall to be used.

RU
Аналогичным образом можно использовать функцию `delegatecall`: разница в том, что используется только код заданного адреса, все остальные аспекты(хранение, баланс, ...) берутся из текущего контракта. Назначение `delegatecall` - использовать код библиотеки, который хранится в другом контракте. Пользователь должен убедиться, что расположение хранилищ в обоих контрактах подходит для использования `delegatecall`.

EN
Note
Prior to homestead, only a limited variant called callcode was available that did not provide access to the original msg.sender and msg.value values. This function was removed in version 0.5.0.

RU
> <c>ℹ️ Примечание</c>
___
До homestead версии был доступен только ограниченный вариант функции `callcode`, которая не предоставляла доступ к исходным значениям `msg.sender` и `msg.value`. Эта функция была удалена начиная с версии 0.5.0.
___

EN
Since byzantium staticcall can be used as well. This is basically the same as call, but will revert if the called function modifies the state in any way.

All three functions call, delegatecall and staticcall are very low-level functions and should only be used as a last resort as they break the type-safety of Solidity.

The gas option is available on all three methods, while the value option is only available on call.

RU
Начиная с версии byzantium можно так же использовать `staticcall`. По сути, это то же самое, что и `call`, но она будет возвращена(?), если вызванная функция каким-либо образом изменит состояние.

Все три функции `call`, `delegatecall` и `staticcall` являются сильно низкоуровневыми функциями и должны использоваться только в крайних случаях, так как они нарушают безопасность типов Solidity.

Опция `gas` доступна для всех трех методов, а опция `value` - только для `call`.

EN
Note
It is best to avoid relying on hardcoded gas values in your smart contract code, regardless of whether state is read from or written to, as this can have many pitfalls. Also, access to gas might change in the future.

RU
> <c>ℹ️ Примечание</c>
___
Лучше не полагаться на жестко закодированные значения газа в коде вашего смарт-контракта, независимо от того, считывается ли состояние или записывается в него, так как здесь может быть много подводных камней. Кроме того, в будущем может измениться предоставление доступа к газу.
___

> `code` и `codehash`

EN
You can query the deployed code for any smart contract. Use .code to get the EVM bytecode as a bytes memory, which might be empty. Use .codehash to get the Keccak-256 hash of that code (as a bytes32). Note that addr.codehash is cheaper than using keccak256(addr.code).

RU
Вы можете запросить опубликованный код для любого смарт-контракта. Используйте `.code` для получения байткода EVM в виде `bytes memory`, который может быть пустым. Используйте `.codehash`, чтобы получить хэш Keccak-256 этого кода(в виде `bytes32`). Обратите внимание, что `addr.codehash` дешевле, чем использование `keccak256(addr.code)`.

EN
Note
All contracts can be converted to address type, so it is possible to query the balance of the current contract using address(this).balance.

RU
> <c>ℹ️ Примечание</c>
___
Все контракты могут быть преобразован к типу `address`, поэтому можно запросить баланс текущего контракта, используя `address(this).balance`.
___

### Contract types
### Типы контрактов

EN
Every contract defines its own type. You can implicitly convert contracts to contracts they inherit from. Contracts can be explicitly converted to and from the address type.

RU
Каждый контракт определяется своим собственным типом. Вы можете неявно конвертировать одни контракты в другие путем наследования (?). Контракты можно явно конвертировать как в тип `address`, так и обратно.

EN
Explicit conversion to and from the address payable type is only possible if the contract type has a receive or payable fallback function. The conversion is still performed using address(x). If the contract type does not have a receive or payable fallback function, the conversion to address payable can be done using payable(address(x)). You can find more information in the section about the address type.

RU
Явное преобразование в тип `address payable` и обратно, возможно только в том случае, если контракт имеет функцию receive или  функцию payable fallback. Преобразование по-прежнему выполняется с помощью `address(x)`. Если данный тип контракта не имеет функции receive или payable fallback функции, преобразование в `address payable` может быть выполнено с помощью `payable(address(x))`. Более подробную информацию вы можете найти в разеделе об "Адресном типе".

EN
Note
Before version 0.5.0, contracts directly derived from the address type and there was no distinction between address and address payable.

RU
> <c>ℹ️ Примечание</c>
___
До версии 0.5.0 контракты напрямую происходили/наследовались от типа `address` и не было различия между `address` и `address payable`.
___

EN
If you declare a local variable of contract type (MyContract c), you can call functions on that contract. Take care to assign it from somewhere that is the same contract type.

RU
Если вы объявите локальную переменную типа контракт (`MyContract c`), вы соответственно сможете вызвать функции этого контракта. Позаботьтесь, чтобы присвоить ему тот же тип контракта.(?)

EN
You can also instantiate contracts (which means they are newly created). You can find more details in the ‘Contracts via new’ section.

RU
Вы также можете создавать экземпляры контрактов (т.е. создавать новые). Более подробную информацию вы можете найти в разделе "Контракты с помощью `new`".

EN
The data representation of a contract is identical to that of the address type and this type is also used in the ABI.

RU
Представление данных контракта идентично представлению данных типа `address`, и этот тип также используется в ABI.

EM
Contracts do not support any operators.

RU
Контракты не поддерживают никаких операторов (? т/е с контрактами нельзя выполнять никакие операции - задействовать в выражениях)

EN
The members of contract types are the external functions of the contract including any state variables marked as public.

RU
Членами(? составляющими элементами) элементов типа Контракт являются внешние функции контракта, включая любые переменные состояния, обозначенные как `public`.

EN
For a contract C you can use type(C) to access type information about the contract.

RU
Для любого контракта `C` вы можете использовать `type(C)`, чтобы получить"информацию о типе" этого контракта.

### Fixed-size byte arrays
### Бинарные массивы(Массивы байтов) фиксированного размера

EN
The value types bytes1, bytes2, bytes3, …, bytes32 hold a sequence of bytes from one to up to 32.

RU
Тип значений `bytes1`, `bytes2`, `bytes3`, ..., `bytes32` хранят последовательность байтов от одного до 32.

EN
Operators:
- Comparisons: <=, <, ==, !=, >=, > (evaluate to bool)
- Bit operators: &, |, ^ (bitwise exclusive or), ~ (bitwise negation)
- Shift operators: << (left shift), >> (right shift)
- Index access: If x is of type bytesI, then x[k] for 0 <= k < I returns the k th byte (read-only).

RU
Операторы:
- Сравнения: `<=`, `<`, `==`, `!=`, `>=`, `>` (возвращают bool)
- Побитовые операторы: `&`, `|`, `^`(побитовое исключающее "или"), `~` (побитовое отрицание)
- Побитовые операторы сдвига: `<<`(сдвиг влево), `>>` (сдвиг вправо)
- Доступ к индексы: Если `x` имеет тип `bytesI`, тогда `x[k]` для `0 <= k < I` возвращает `k`-ый байт (только для чтения).

EN
The shifting operator works with unsigned integer type as right operand (but returns the type of the left operand), which denotes the number of bits to shift by. Shifting by a signed type will produce a compilation error.

RU
Оператор сдвига работает с беззнаковым целым типом в качетсве правого операнда (но возвращает тип левого операнда), который обозначает количество битов, на которое нужно сдвинуть. Попытка сдвинуть на знаковый тип приведет к ошибке компиляции.

EN
Members:

RU
Переменные-члены/поля/атрибуты:

Поля:

EN
- .length yields the fixed length of the byte array (read-only).

RU
- `.length` выдает фиксированную длину массива байтов (только для чтения).

EN
Note
The type bytes1[] is an array of bytes, but due to padding rules, it wastes 31 bytes of space for each element (except in storage). It is better to use the bytes type instead.

RU
> <c>ℹ️ Примечание</c>
___
Тип bytes1[] - массив байтов, но из-за правил заполнения он тратит 31 байт области на каждый элемент (за исключением хранения). Вместо него лучше использовать тип `bytes`.
___

EN
Note
Prior to version 0.8.0, byte used to be an alias for bytes1.

RU
> <c>ℹ️ Примечание</c>
До 0.8.0 тип `byte` был псевдонимом для `bytes1`.

### Dynamically-sized byte array
### Массив байтов динамически изменяемого размера

EN
bytes:
Dynamically-sized byte array, see Arrays. Not a value-type!

string:
Dynamically-sized UTF-8-encoded string, see Arrays. Not a value-type!

RU
`bytes`:
Массив байтов динамического размера, см. раздел "Массивы". Не тип значения!

`string`:
Строка динамически изменяемого размера в кодировке UTF-8, см. раздел "Массивы". Не тип значения!

### Address Literals
###
EN
Hexadecimal literals that pass the address checksum test, for example 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF are of address type. Hexadecimal literals that are between 39 and 41 digits long and do not pass the checksum test produce an error. You can prepend (for integer types) or append (for bytesNN types) zeros to remove the error.
RU
Шестнадцатеричные литералы которые прошли проверку контрольной суммы адреса, например `0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF` имеют тип `address`. Шестнадцатеричные литералы длиной от 39 до 41 цифры, не прошедшие проверку контрольной суммы, выдают ошибку. Вы можете добавить в начало (для целочиселнных типов) или добавить в конец (для `bytesNN` типов) нули, чтобы устранить ошибку.

> Литерал https://ru.wikipedia.org/wiki/%D0%9B%D0%B8%D1%82%D0%B5%D1%80%D0%B0%D0%BB_(%D0%B8%D0%BD%D1%84%D0%BE%D1%80%D0%BC%D0%B0%D1%82%D0%B8%D0%BA%D0%B0)

EN
Note
The mixed-case address checksum format is defined in EIP-55.
RU
> <c>ℹ️ Примечание</c>
___
Контроль суммы адреса в смешанном регистре определен в EIP-55.
___

### Rational and Integer Literals
### Рациональные и целочисленные литералы

EN
Integer literals are formed from a sequence of digits in the range 0-9. They are interpreted as decimals. For example, 69 means sixty nine. Octal literals do not exist in Solidity and leading zeros are invalid.

RU
Целочисленные литералы формируются из последовательности цифр 0-9. Они интерпретируются как десятичные числа. Например, 69 означает шестьдесят девять. Восьмеричные литералы не существуют в Solidity, и ведущие нули недействительны.

EN
Decimal fractional literals are formed by a . with at least one number after the decimal point. Examples include .1 and 1.3 (but not 1.).

RU
Десятичные дробные литералы образуются с помощью символа `.` с хотябы одной цифрой после десятичной точки. Например, `.1` и `1.3` (но не `1.`).

EN
Scientific notation in the form of 2e10 is also supported, where the mantissa can be fractional but the exponent has to be an integer. The literal MeE is equivalent to M * 10**E. Examples include 2e10, -2e10, 2e-10, 2.5e1.

RU
Также поддерживается экспоненциальная нотация в виде `2e10`, где мантисса может быть дробной `MeE`, но экспонента должна быть целым числом. Литерал `MeE` эквивалентен `M * 10 ** E`. Примеры: 2e10, -2e10, 2e-10, 2.5e1.

> Мантисса https://en.wikipedia.org/wiki/Significand
> https://www.online-calculator.org/scientific-notation/2e10

EN
Underscores can be used to separate the digits of a numeric literal to aid readability. For example, decimal 123_000, hexadecimal 0x2eff_abde, scientific decimal notation 1_2e345_678 are all valid. Underscores are only allowed between two digits and only one consecutive underscore is allowed. There is no additional semantic meaning added to a number literal containing underscores, the underscores are ignored.

RU
Подчеркивания могут использоваться для разделения цифр числового литерала, чтобы облегчить чтение. Например, являются допустимыми: десятичное `123_000`, шестнадцатеричное `0x2eff_abde`, экспоненциальная десятичная система счисления `1_2e345_678`. Подчеркивание допускается только между двумя цифрами и только одно последовательное подчеркивание. Никакого дополнительного семантического значения не добавляется в числовой литерал содержащий подчеркивания, подчеркивания игнорируются.

EN
Number literal expressions retain arbitrary precision until they are converted to a non-literal type (i.e. by using them together with anything other than a number literal expression (like boolean literals) or by explicit conversion). This means that computations do not overflow and divisions do not truncate in number literal expressions.

RU
Числовые литеральные выражения сохраняют произвольную точность до тех пор, пока они не буду преобразованы к нелитеральному типу (т.е. при использовании их вместе с чем-либо, не являющимся числовым литеральным выражением(например, с булевыми литералами) или при явном преобразовании). Это означает, что вычисления не переполняются, а деления не усекаются в числовых литеральных выражениях.

> Арифметика произвольной точности - относится к арифметике, в которой длина чисел ограничена только объемом доступной памяти. https://ru.wikipedia.org/wiki/%D0%94%D0%BB%D0%B8%D0%BD%D0%BD%D0%B0%D1%8F_%D0%B0%D1%80%D0%B8%D1%84%D0%BC%D0%B5%D1%82%D0%B8%D0%BA%D0%B0

EN
For example, (2**800 + 1) - 2**800 results in the constant 1 (of type uint8) although intermediate results would not even fit the machine word size. Furthermore, .5 * 8 results in the integer 4 (although non-integers were used in between).

RU
Например, `(2**80 + 1) - 2**800` приводит к константе `1`(типа `uint8`), хотя промежуточные результаты даже не помещаются в размер машинного слова. Кроме того, `.5 * 8` дает целое число `4` (хотя вычисление производилось между нецелыми числами).

EN
Warning
While most operators produce a literal expression when applied to literals, there are certain operators that do not follow this pattern:
- Ternary operator (... ? ... : ...),

- Array subscript (<array>[<index>]).

You might expect expressions like 255 + (true ? 1 : 0) or 255 + [1, 2, 3][0] to be equivalent to using the literal 256 directly, but in fact they are computed within the type uint8 and can overflow.

RU
> <o>⚠️ Предупреждение </o>
___
Тогда как большинство операторов при применении к литералам дают литеральное выражение, существуют некоторые операторы, которые не следуют этому правилу:
- Тернанрный оператор `(... ? ... : ...),
- Индекс массива `(<array>[<index>])`.
Вы можете ожидать, что выражение типа `255 + (true ? 1 : 0) or 255 + [1, 2, 3][0] будут эквиваленты прямому использованию летерала 256, но на самом деле они вычисляются с использованием типа `uint8` и могут вызывать переполнение.
___

EN
Any operator that can be applied to integers can also be applied to number literal expressions as long as the operands are integers. If any of the two is fractional, bit operations are disallowed and exponentiation is disallowed if the exponent is fractional (because that might result in a non-rational number).

RU
Любой оператор, который может быть применен к целым числам, также может быть применен к выражениям с литералами чисел, если операнды являются целыми числами. Если один из них дробный, то битовые операции запрещены, а возведение в степень запрещена, если показатель степени(экспонента) дробный (потому что это может привести к нерациональному числу).


EN
Shifts and exponentiation with literal numbers as left (or base) operand and integer types as the right (exponent) operand are always performed in the uint256 (for non-negative literals) or int256 (for a negative literals) type, regardless of the type of the right (exponent) operand.

RU
Побитовые сдвиги и возведение в степень с литеральными числами на месте левого(или базового) операнда и целыми типами на месте правого (возведение в степень) операнда, всегда выполняются в типе `uint256`(для неотрицательных литералов) или `int256` (для отрицательных литералов), независимо от типа правого (возведение в степень) операнда.


EN
Warning
Division on integer literals used to truncate in Solidity prior to version 0.4.0, but it now converts into a rational number, i.e. 5 / 2 is not equal to 2, but to 2.5.

RU
> <o>⚠️ Предупреждение </o>
В Solidity до версии 0.4.0 деление на целочисленные литералы усекалось, но теперь оно преобразуется в рациональное число, т.е. `5/2` равно не `2`, а `2.5`.

EN
Note
Solidity has a number literal type for each rational number. Integer literals and rational number literals belong to number literal types. Moreover, all number literal expressions (i.e. the expressions that contain only number literals and operators) belong to number literal types. So the number literal expressions 1 + 2 and 2 + 1 both belong to the same number literal type for the rational number three.

RU
> <c>ℹ️ Примечание</c>
В Solidity есть числовой литеральный тип для каждого рационального числа. Целочисленные литералы и литералы рациональных чисел принадлежат к типам числовых литералов. Более того, все числовые выражения (т.е. выражения, содержащие только числовые литералы и операторы) принадлежат к числовым литеральным типам. Так, числовое выражение `1 + 2` и `2 + 1` принадлежат одному и тому же числовому литеральному типу для рационального числа три.

EN
Note
Number literal expressions are converted into a non-literal type as soon as they are used with non-literal expressions. Disregarding types, the value of the expression assigned to b below evaluates to an integer. Because a is of type uint128, the expression 2.5 + a has to have a proper type, though. Since there is no common type for the type of 2.5 and uint128, the Solidity compiler does not accept this code.

```java
uint128 a = 1;
uint128 b = 2.5 + a + 0.5;
```
RU
> <c>ℹ️ Примечание</c>
Числовые литеальные выражения преобразуются в нелитеральный тип, как только они используются с нелитеральными выражениями. Если не принимать во внимание типы, то значение выражения, присвоенного `b`, оценивается как целое число. Поскольку `a` имеет тип `uint128`, выражение `2.5 + a` должно иметь соответствующий тип. Поскольку не существует общего типа для типов `2.5` и `uint128`, компилятор Solidity не принимает этот код.

```java
uint128 a = 1;
uint128 b = 2.5 + a + 0.5;
```

### String Literals and Types
### Строковые литералы и типы

EN
String literals are written with either double or single-quotes ("foo" or 'bar'), and they can also be split into multiple consecutive parts ("foo" "bar" is equivalent to "foobar") which can be helpful when dealing with long strings. They do not imply trailing zeroes as in C; "foo" represents three bytes, not four. As with integer literals, their type can vary, but they are implicitly convertible to bytes1, …, bytes32, if they fit, to bytes and to string.

RU
Строковые литералы записываются с двойными или одинарными кавычками(`"foo"` или `'bar'`), а также могут быть разбиты на несколько последовательных частей(`"foo"` `"bar"` эквивалентно `"foobar"`), что может быть полезно при работе с длинными строками. Они не подразумевают нули в конце строки, как в C; `"foo"` представляет три байта, а не четыре. Как и в случае целочисленных литералов, их тип может меняться, но они неявно преобразуются в `bytes1`, ..., `bytes32`, если они подходят, в `bytes` и в `string`.
 
EN
For example, with bytes32 samevar = "stringliteral" the string literal is interpreted in its raw byte form when assigned to a bytes32 type.

RU
Например, при `bytes32 samevar = "stringliteral"` строковвый литерал интерпретируется в своей необработанной байтовой форме, когда присваивается типу `bytes32`.

EN
String literals can only contain printable ASCII characters, which means the characters between and including 0x20 .. 0x7E.

RU
Строковые литералы могут содержать только печатные символы ASCII, то есть символы между 0x20...0x7E включительнь.

EN
Additionally, string literals also support the following escape characters:
- \<newline> (escapes an actual newline)
- \\ (backslash)
- \' (single quote)
- \" (double quote)
- \n (newline)
- \r (carriage return)
- \t (tab)
- \xNN (hex escape, see below)
- \uNNNN (unicode escape, see below)

RU
Кроме того, строковые литералы поддерживают следующие управляющие символы:
- `\<newline>` (экранируется новую строку)
- `\\` (обратная косая черта)
- `\'` (одинарная кавычка)
- `\"` (двойная кавычка)
- `\n` (новая строка)
- `\r` (возврат каретки)
- `\t` (табуляция)
- `\xNN` (шестнадцатеричный символ, см. ниже)
- `\uNNNN` (экранирование юникода, см. ниже)

EN
\xNN takes a hex value and inserts the appropriate byte, while \uNNNN takes a Unicode codepoint and inserts an UTF-8 sequence.

RU
`\xNN` принимает шестнадцатеричное значение и вставляет соответствующий байт, а `\uNNNN` принимает кодовую ? Юникода и вставляет последовательность UTF-8.

EN
Note
Until version 0.8.0 there were three additional escape sequences: \b, \f and \v. They are commonly available in other languages but rarely needed in practice. If you do need them, they can still be inserted via hexadecimal escapes, i.e. \x08, \x0c and \x0b, respectively, just as any other ASCII character.

RU
> <c>ℹ️ Примечание</c>
До версии 0.8.0 существовали три дополнительные управляющие последовательности: `\b`, `\f` и `\v`. Они широко распространены в других языках, но редко нужны на практике. Если они все же нужны, их можно вставить через шестнадцатеричные экранирующие символы, т.е `\x08` `\x0c` `\xob`, соотвественно, как и любой другой символ ASCII.

EN
The string in the following example has a length of ten bytes. It starts with a newline byte, followed by a double quote, a single quote a backslash character and then (without separator) the character sequence abcdef.
"\n\"\'\\abc\
def"

RU
Строка в следующем примере имеет длину десять байт. Она начинается с байта новой строки, затем следует двойная кавычка, затем одинарная, потом символ обратной косой черты и затем (без разделителя) последовательность символов `abcdef`. 
```java
"\n\"\'\\abc\
def"
```

EN
Any Unicode line terminator which is not a newline (i.e. LF, VF, FF, CR, NEL, LS, PS) is considered to terminate the string literal. Newline only terminates the string literal if it is not preceded by a \.

RU
Любой управляющий символ Unicode, не ялвяющийся новой строкой (т.е. LF, VF, FF, CR, NEL, LS, PS), завершает строковый литерал. Новая строка завершает строковый литерал, только если ей не предшествует `\`.

>Новая строка https://translated.turbopages.org/proxy_u/en-ru.ru.6c958fca-64836626-ad52f1ef-74722d776562/https/en.wikipedia.org/wiki/%5Cr%5Cn

### Unicode Literals
### Юникод литералы

EN
While regular string literals can only contain ASCII, Unicode literals – prefixed with the keyword unicode – can contain any valid UTF-8 sequence. They also support the very same escape sequences as regular string literals.

string memory a = unicode"Hello 😃";

RU
В то время как обычные строковые литералы могут содержать ASCII, Unicode литералы - с префиксом ключевого слова `unicode` - могут содержать любую допустимую последовательность UTF-8. 
```java
string memory a = unicode"Hello 😃";
```

### Hexadecimal Literals
### Шестнадцатеричные литералы

EN
Hexadecimal literals are prefixed with the keyword hex and are enclosed in double or single-quotes (hex"001122FF", hex'0011_22_FF'). Their content must be hexadecimal digits which can optionally use a single underscore as separator between byte boundaries. The value of the literal will be the binary representation of the hexadecimal sequence.

RU
Шестнадцатеричные литералы имеют префикс с ключевым словом `hex` и заключаются в двойные или одинарные кавычки(`hex"001122FF"`, `hex'0011_22_FF'`). Их содержимое должно быть шестнадцатеричные цифры, которые могут по желанию использовать одиночное подчеркивание в качестве разделения между границами байтов. Значением литерала будет двоичное представление шестнадцатеричной последовательност.

EN
Multiple hexadecimal literals separated by whitespace are concatenated into a single literal: hex"00112233" hex"44556677" is equivalent to hex"0011223344556677"

RU
Несколько шестнадцатеричных литералов, разделенным пробелами, объединяются в один литерал: `hex"00112233" hex"44556677"` эквивалентен `hex"0011223344556677"`

EN
Hexadecimal literals in some ways behave like string literals but are not implicitly convertible to the string type.

RU
Шестнадцатеричные литералы в некотором смысле ведут себя как строковые литералы, но неявно не могут преобразовываться к типу `string`.

### Enums
### Перечисления

EN
Enums are one way to create a user-defined type in Solidity. They are explicitly convertible to and from all integer types but implicit conversion is not allowed. The explicit conversion from integer checks at runtime that the value lies inside the range of the enum and causes a Panic error otherwise. Enums require at least one member, and its default value when declared is the first member. Enums cannot have more than 256 members.

RU
Перечисления - это один из способов создания пользовательского типа в Solidity. Они явно конвертируются во все целочисленные типы и обратно, но неявное преобразование не допускается. Явное преобразование из целого числа проверяется во время выполнения, что значение принадлежит диапазону перечисления, и в противном случае вызывает ошибку `Panic error`. Перечисления должны содержать хотя бы один элемент, а его значение по умолчанию при объявлении является первым элементом. Перечисления не могут иметь более 256 членов.

EN
The data representation is the same as for enums in C: The options are represented by subsequent unsigned integer values starting from 0.

RU
Представление данных такое же, как и для Перечислений в языке C: Параметры/элементы представлены последовательными беззнаковыми целыми значениями, начиная с 0.

EN
Using type(NameOfEnum).min and type(NameOfEnum).max you can get the smallest and respectively largest value of the given enum.

RU
С помощью `type(NameOfEnum).min` и `type(NameOfEnum).max` можно получить наименьшее и соответственно наибольшее значения данного перечисления.

```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.8;

contract test {
    enum ActionChoices { GoLeft, GoRight, GoStraight, SitStill }
    ActionChoices choice;
    ActionChoices constant defaultChoice = ActionChoices.GoStraight;

    function setGoStraight() public {
        choice = ActionChoices.GoStraight;
    }

    // Since enum types are not part of the ABI, the signature of "getChoice"
    // will automatically be changed to "getChoice() returns (uint8)"
    // for all matters external to Solidity.
    //
    //
    //
    function getChoice() public view returns (ActionChoices) {
        return choice;
    }

    function getDefaultChoice() public pure returns (uint) {
        return uint(defaultChoice);
    }

    function getLargestValue() public pure returns (ActionChoices) {
        return type(ActionChoices).max;
    }

    function getSmallestValue() public pure returns (ActionChoices) {
        return type(ActionChoices).min;
    }
}
```

EN
Note
Enums can also be declared on the file level, outside of contract or library definitions.

RU

### User-defined Value Types
###