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