# Layout of a Solidity Source File
# Структура/разметка/макет/расположение (?) исходного Solidity-файла

EN
Source files can contain an arbitrary number of contract definitions, import , pragma and using for directives and struct, enum, function, error and constant variable definitions.

RU (!Добавить ссылки)
Исходные файлы могут содержать любое количество: определений контрактов, директив import, pragma и using for, а также определений переменных struct, enum, function, error и constant.

## SPDX License Identifier
## Идентификатор лицензии SPDX

EN
Trust in smart contracts can be better established if their source code is available. Since making source code available always touches on legal problems with regards to copyright, the Solidity compiler encourages the use of machine-readable SPDX license identifiers. Every source file should start with a comment indicating its license:

RU
Доверием к смарт-контрактам может быть лучше, если доступен их исходный код. Поскольку предоставление исходного кода всегда затрагивает юридические аспекты, связанные с авториским правом, Solidity компилятор способствует/(поддерживает) использованию машиночитаемых идентификаторов лицензии SPDX. Каждый исходный код должн начинаться с комментрария, указывающего на его лицензию

// SPDX-License-Identifier: MIT

EN
The compiler does not validate that the license is part of the list allowed by SPDX, but it does include the supplied string in the bytecode metadata.

RU
Компилятор не проверяет, что лицензия входит в список разрешенных SPDX, но включает указанную строку в методанные байт-кода.

EN
If you do not want to specify a license or if the source code is not open-source, please use the special value UNLICENSED. Note that UNLICENSED (no usage allowed, not present in SPDX license list) is different from UNLICENSE (grants all rights to everyone). Solidity follows the npm recommendation.

RU
Если вы не хотите указывать лицензию или если исходный код не явялется открытым, пожалуйста, используйте специальное значение `UNLICENSED`. Обратите внимание, что `UNLICENSED`(использование запрещено, отстутствует в списке лицензий SPDX) отличается от `UNLICENSE`(предоставляет любые права всем лицам). Solidity следует рекомендациям `npm`.

EN
Supplying this comment of course does not free you from other obligations related to licensing like having to mention a specific license header in each source file or the original copyright holder.

RU
Предоставление такого комментария, конечно, не особождает вас от других обязательств, связанных с лиценрзированием, например, от необходимост указывать специальный заголовок лицензии в каждом исходном файле или первоначального владельца авторских прав.

EN
The comment is recognized by the compiler anywhere in the file at the file level, but it is recommended to put it at the top of the file.

More information about how to use SPDX license identifiers can be found at the SPDX website.

RU
Комментарий распознается компилятором в любом местое файла на файловом уровне, но рекомендуется размещать его в начале файла.

Больше информации о том как использовать идентификаторы лицензий SPDX можно найти на сайте SPDX.

### Pragmas
### Директива `Pragma`/псевдокомментарий
### Директивы

EN
The pragma keyword is used to enable certain compiler features or checks. A pragma directive is always local to a source file, so you have to add the pragma to all your files if you want to enable it in your whole project. If you import another file, the pragma from that file does not automatically apply to the importing file.

RU
Ключевое слово `pragma` используется для того, чтобы задействовать определенные функции компилятора или провероки. Директива `pragma` всегда локальна для исходного файла, поэтому вы должны добавить `pragma` во все свои файлы, если хотите включить ее во всем проекте. Если вы импортируете другой файл, то `pragma` из этого файла не будет автоматически применяться к файлу который импортирует.

### Version Pragma
### Директива версии Solidity

EN
Source files can (and should) be annotated with a version pragma to reject compilation with future compiler versions that might introduce incompatible changes. We try to keep these to an absolute minimum and introduce them in a way that changes in semantics also require changes in the syntax, but this is not always possible. Because of this, it is always a good idea to read through the changelog at least for releases that contain breaking changes. These releases always have versions of the form 0.x.0 or x.0.0.


RU
Исходные файлы могут(и должны) быть снабжены директивой версии Solidity, чтобы запретить компиляцию с последующими версиями компилятора, которые могут внести несовместимые изменения. Мы стараемся свести их к абсолютному минимуму и вводить их таким образом, чтобы семантические изменения требовали также изменения в синтаксисе, но это не всегда возможно. Поэтому всегда полезно прочесть журнал изменений хотя бы тех релизом, которые содержать критические/серьезные изменения. Эти релизы всегда именю версии вида 0.x.0 или x.0.0.

EN
The version pragma is used as follows: pragma solidity ^0.5.2;

A source file with the line above does not compile with a compiler earlier than version 0.5.2, and it also does not work on a compiler starting from version 0.6.0 (this second condition is added by using ^). Because there will be no breaking changes until version 0.6.0, you can be sure that your code compiles the way you intended. The exact version of the compiler is not fixed, so that bugfix releases are still possible.

RU
Директива указания версии Solidity используется следующим образом: `pragma solidity ^0.5.2`;

Исходный файл в котором будет вышеуказанная строка, не cкомпилируется компилятором более ранней версии, чем 0.5.2, а также не работает на компиляторе, начиная с версии 0.6.0(такое второе условие добавляется с помощью `^`). Поскольку до версии 0.6.0 не будет никаких значительных изменений приводящих к некорректной работе, вы можете быть уверены, что ваш код компилируется так, как вы это задумали.  |Точная версия компилятора не фиксируется, так что выпуски с исправленными ошибками все еще возможны.(?)

EN
It is possible to specify more complex rules for the compiler version, these follow the same syntax used by npm.

RU
Можно указать более сложные правила для определенной версии компилятора, которые повторяют тот же синтаксис, что и `npm`.

**Note**

EN
Using the version pragma does not change the version of the compiler. It also does not enable or disable features of the compiler. It just instructs the compiler to check whether its version matches the one required by the pragma. If it does not match, the compiler issues an error.

RU
> <c>ℹ️ Примечание</c>
___
Использование директивы для указания версии не изменяет версию компилятора. Она также не включает и не отклаючает функции компилятора. Она просто указывает компилятору проверить, совпадает ли его версия с версией, требуемой `pragma`. Если версия не совпадает, компилятор выдает ошибку.
___