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