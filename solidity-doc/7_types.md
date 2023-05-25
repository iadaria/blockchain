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