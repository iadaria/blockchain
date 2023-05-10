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

### ABI Coder Pragma
### Директива ABI Кодер (?)

> abi (application binary interface) двоичный (бинарный) интерфейс приложений

EN
By using pragma abicoder v1 or pragma abicoder v2 you can select between the two implementations of the ABI encoder and decoder.

RU
Используя `pragma abicoder v1` или `pragma abicoder v2`, мы можете выбирать между двумя реализациями кодера и декодера ABI.

>Кодер — одна из двух компонент кодека (пары кодер — декодер)

EN
The new ABI coder (v2) is able to encode and decode arbitrarily nested arrays and structs. Apart from supporting more types, it involves more extensive validation and safety checks, which may result in higher gas costs, but also heightened security. It is considered non-experimental as of Solidity 0.6.0 and it is enabled by default starting with Solidity 0.8.0. The old ABI coder can still be selected using pragma abicoder v1;.

RU
Новый ABI-кодер (v2) способен кодировать и декодировать массивы любой глубины вложенности и структуры. Помимо поддержки большого количества типов, он включает в себя больее широкие возможнсти проверки валидности и безопасности, что может привести к увеличению стоимости газа, но также и к повышению безопасности. Начиная с Solidity 0.6.0 он считается неэкспериментированным, а начинаю с Solidity 0.8.0 он включен по умолчанию. Старый ABI-кодер все еще может быть выбран с помощью `pragma abicoder v1;`.

EN
The set of types supported by the new encoder is a strict superset of the ones supported by the old one. Contracts that use it can interact with ones that do not without limitations. The reverse is possible only as long as the non-abicoder v2 contract does not try to make calls that would require decoding types only supported by the new encoder. The compiler can detect this and will issue an error. Simply enabling abicoder v2 for your contract is enough to make the error go away.

RU
Набор типов, поддерживаемых новым кодером, является строгим надмножеством типов, поддерживаемых старым кодером. | Контракты, которые используют новый кодировщик, могут взаимодействовать с такими (?)(типами) со своими ограничениями. Обратное взаимодействие возможно только до тех пор, пока контракт, не использующий `abicoder v2`, не попытается сделать вызовы, требующие декодирования типов, поддерживаемых только новым кодировщиком. Компилятор может обнаружить это и дывать ошибку. Простого включения `abicoder v2` для вашего контракта будет достаточно, чтобы ошибки исчезли.

EN
Note

This pragma applies to all the code defined in the file where it is activated, regardless of where that code ends up eventually. This means that a contract whose source file is selected to compile with ABI coder v1 can still contain code that uses the new encoder by inheriting it from another contract. This is allowed if the new types are only used internally and not in external function signatures.

RU
> <c>ℹ️ Примечание</c>
___
Эта директива применяется ко всему коду, определенному в файле, где она активирована, независимо от того, где этот код в итоге может использоваться. Это означает, что контракт, чей исходный файл
выбран для компиляции с ABI coder v1, все еще может содежрать код, использующий новый кодер, наследуя его от другого контракта. Это допустимо, если новые типы используются только внутри, а не во внешних сигнатурах функций.

>Сигнатура метода — это имя метода плюс параметры (причем порядок параметров имеет значение). В сигнатуру метода не входит возвращаемое значение, а также бросаемые им исключения. Весь код, который описывает метод, называется объявлением метода.
___

EN
Note

Up to Solidity 0.7.4, it was possible to select the ABI coder v2 by using pragma experimental ABIEncoderV2, but it was not possible to explicitly select coder v1 because it was the default.

RU
> <c>ℹ️ Примечание</c>
___
До версии Solidity 0.7.4 можно было выбрать ABI-кодер v2 с помощью `pragma experimental ABIEncoderV2`, но нельзя было явно выбрать кодер v1, поскольку он использовался по умолчанию.
___

### Experimental Pragma
### Экспериментальная Pragma

EN
The second pragma is the experimental pragma. It can be used to enable features of the compiler or language that are not yet enabled by default. The following experimental pragmas are currently supported:

RU
Вторая `pragma` - экспериментальная. Она может быть использована, чтобы задействовать возможности компилятора или языка, которые не включены по умолчанию. В настоящее время поддерживаются следующие экспериментальные `pragmas`:

### ABIEncoderV2
### ABIEncoderV2

EN
Because the ABI coder v2 is not considered experimental anymore, it can be selected via pragma abicoder v2 (please see above) since Solidity 0.7.4.

RU
Поскольку ABI coder v2 больше не считается экспериментальным, его можно выбрать указав `pragma abicoder v2;` (см. выше), начиная с версии Solidity 0.7.4.

### SMTChecker
### SMTChecker

EN
This component has to be enabled when the Solidity compiler is built and therefore it is not available in all Solidity binaries. The build instructions explain how to activate this option. It is activated for the Ubuntu PPA releases in most versions, but not for the Docker images, Windows binaries or the statically-built Linux binaries. It can be activated for solc-js via the smtCallback if you have an SMT solver installed locally and run solc-js via node (not via the browser).

RU
Этот компонент должен быть включен при сборке компилятора Solidity, поэтому он доступен не во всех двоичных файлах Solidity. В инструкции по сборке объясняется, как активировать эту опцию. Он активировать в большенстве версий для релизов Ubuntu PPA, но не для образов Docker, двоичных файлов Windows или статически собранных двоичных файлов Linux. Его можно активировать для `solc-js` через `smtCallback`, если у вас локально установлен SMT и вы запускаете `solc-js` через `node`(не через браузер).

EN
If you use pragma experimental SMTChecker;, then you get additional safety warnings which are obtained by querying an SMT solver. The component does not yet support all features of the Solidity language and likely outputs many warnings. In case it reports unsupported features, the analysis may not be fully sound.

RU
Если вы используете `pragma experimental SMTChecker;`, то вы получите дополнительные предупреждения о безопасности, которые приходят при запросе к SMT solver. Данный компонент еще не поддерживает все возможнсоти языка Solidity и, вероятно, выодить много предупреждений. В случае, если он сообщает о неподдреживаемых возможностях, анализ может быть не совсем корректным.

## Importing other Source Files
## Импорт других исходных файлов

### Syntax and Semantics
### Синтаксис и семантика

> Семантика языка - это смысловое значение слов. В программировании - начальное смысловое значение операторов, основных конструкций языка и т.п. \
> Первый код:  i=0; while(i<5){i++;} \
> Второй код: i=0; do{i++;} while(i<=4);\
> Логически эти два фрагмента кода выполняют одно и то же, результаты их работы идентичны. В то же время семантически это два разных цикла.
>(https://ru.wikipedia.org/wiki/%D0%A1%D0%B5%D0%BC%D0%B0%D0%BD%D1%82%D0%B8%D0%BA%D0%B0_(%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5))

EN
Solidity supports import statements to help modularise your code that are similar to those available in JavaScript (from ES6 on). However, Solidity does not support the concept of a default export.

RU
Solidity поддерживает операторы ипорта, помогающие вашему коду иметь модульную структуру(делают ваш код модульным), аналогичные тем, которые доступны в JavaScript (начиная с ES6). Однако, Solidity не поддерживает концепцию экспорта по умолчанию.

EN
At a global level, you can use import statements of the following form: `import "filename";`

RU
На глобальном уровне, вы можете использовать операторы импорта следующего вида:
```java 
import "filename";
```

EN
The filename part is called an import path. This statement imports all global symbols from “filename” (and symbols imported there) into the current global scope (different than in ES6 but backwards-compatible for Solidity). This form is not recommended for use, because it unpredictably pollutes the namespace. If you add new top-level items inside “filename”, they automatically appear in all files that import like this from “filename”. It is better to import specific symbols explicitly.

RU
Часть `filename` называется путем импорта(т.е. откуда импортируется и какой файл). Оператор `import` импортирует все глобальные идентификаторы из `filename` (также импортированные туда идентификаторы) в текущую глобальную область видимости (иначе, чем в ES6, но обратно совместимо с Solidity). Такой способ не рекоменндуется к использованию, поскольку он непредсказуемо "загрязняет" пространство имен. Если вы добавляете новые элементы верхнего уровня внутри "filename", они автоматически появляются во всех файлах, которые импортируют таким же образом "filename". Лучше импортировать конкретные идентификаторы явным образом.

>"Идентификаторы" или "символы" — это имена, задаваемые в программе для переменных, типов, функций и меток. Написание и регистр символов в именах идентификаторов должны отличаться от всех ключевых слов. Не допускается использовать ключевые слова (C или Microsoft) в качестве идентификаторов; они зарезервированы для специального применения.
>(https://docs.microsoft.com/ru-ru/cpp/c-language/c-identifiers?view=msvc-160#:~:text=%D0%98%D0%B4%D0%B5%D0%BD%D1%82%D0%B8%D1%84%D0%B8%D0%BA%D0%B0%D1%82%D0%BE%D1%80%D1%8B%22%20%D0%B8%D0%BB%D0%B8%20%22%D1%81%D0%B8%D0%BC%D0%B2%D0%BE%D0%BB%D1%8B%22%20%E2%80%94%20%D1%8D%D1%82%D0%BE,%D0%BE%D0%BD%D0%B8%20%D0%B7%D0%B0%D1%80%D0%B5%D0%B7%D0%B5%D1%80%D0%B2%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D1%8B%20%D0%B4%D0%BB%D1%8F%20%D1%81%D0%BF%D0%B5%D1%86%D0%B8%D0%B0%D0%BB%D1%8C%D0%BD%D0%BE%D0%B3%D0%BE%20%D0%BF%D1%80%D0%B8%D0%BC%D0%B5%D0%BD%D0%B5%D0%BD%D0%B8%D1%8F)

EN
The following example creates a new global symbol symbolName whose members are all the global symbols from "filename":`import * as symbolName from "filename";`
which results in all global symbols being available in the format symbolName.symbol.

RU
Следующий пример создает новый глобальный идентификатор `symbolName`, членами которого являются все глобальные идентификаторы из "filename":
```java
import * as symbolName from "filename";
```
в результате чего все глобальные идентификаторы из "filename" будут доступны в формате: `symbolName.symbol`.

EN
A variant of this syntax that is not part of ES6, but possibly useful is:
`import "filename" as symbolName;`
which is equivalent to import * as symbolName from "filename";.

RU
Еще один вариант синтаксиса, который не поддерживается в ES6, но может быть вам полезен:
```java
import "filename" as symbolName;
```
что эквивалентно `import * as symbolNames from "filename";`.

EN
If there is a naming collision, you can rename symbols while importing. For example, the code below creates new global symbols alias and symbol2 which reference symbol1 and symbol2 from inside "filename", respectively.
`import {symbol1 as alias, symbol2} from "filename";`

RU
При конфликте имен, можно переименовывать идентификаторы при импортировании. Например, приведенный ниже код создает новые глобальные идентификаторы `alias` и `symbol2` из "filename" соответственно.
```java
import {symbol1 as alias, symbol2} from "filename";
```
### Import Paths
### Пути импорта (?)

EN
In order to be able to support reproducible builds on all platforms, the Solidity compiler has to abstract away the details of the filesystem where source files are stored. For this reason import paths do not refer directly to files in the host filesystem. Instead the compiler maintains an internal database (virtual filesystem or VFS for short) where each source unit is assigned a unique source unit name which is an opaque and unstructured identifier. The import path specified in an import statement is translated into a source unit name and used to find the corresponding source unit in this database.

RU
Для того, чтобы иметь возможность реализовывать **воспроизводимые сборки**(см. определение ниже) на разных платформах, компилятор Solidity должен абстрагироваться от деталей реализации файловой сестемы, используемой для хранения исходных файлов. По этой причине указываемые пути для импорта файлов не ссылаются непосредственно на сами файлы в файловой системе, |носителя(диск), где они непосредственно храняться. Вместо этого компилятор ведет внутреннюю базу данных (виртуальную файловую систему, сокращенно VFS), где каждому (исходному блоку/блоку данных) присваивается уникальное имя, которое является бесмыссленым и произвольным идентификатором. Путь для импорта файла, указанный оператором `import`, преобразуется в имя блока данных и используется для поиска соответствующего блока данных во внутренней бд.

>**Сборка называется воспроизводимой**, если в результате её из одних и тех же исходников в одинаковом сборочном окружении и при одинаковых инструкциях к сборке получается идентичный результат. Воспроизводимость сборки является необходимым условием для доказательства того, что имеющееся скомпилированное программное обеспечение действительно получено из заявленных исходных кодов.
>(https://lvee.org/en/abstracts/272#:~:text=%D0%A1%D0%B1%D0%BE%D1%80%D0%BA%D0%B0%20%D0%BD%D0%B0%D0%B7%D1%8B%D0%B2%D0%B0%D0%B5%D1%82%D1%81%D1%8F%20%D0%B2%D0%BE%D1%81%D0%BF%D1%80%D0%BE%D0%B8%D0%B7%D0%B2%D0%BE%D0%B4%D0%B8%D0%BC%D0%BE%D0%B9%5B%23rb%5D%2C%20%D0%B5%D1%81%D0%BB%D0%B8%20%D0%B2,%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%BE%20%D0%B8%D0%B7%20%D0%B7%D0%B0%D1%8F%D0%B2%D0%BB%D0%B5%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B8%D1%81%D1%85%D0%BE%D0%B4%D0%BD%D1%8B%D1%85%20%D0%BA%D0%BE%D0%B4%D0%BE%D0%B2)\
>(https://translated.turbopages.org/proxy_u/en-ru.ru.9fecfae1-6457b41e-fc89728c-74722d776562/https/en.wikipedia.org/wiki/Reproducible_builds)

EN
Using the Standard JSON API it is possible to directly provide the names and content of all the source files as a part of the compiler input. In this case source unit names are truly arbitrary. If, however, you want the compiler to automatically find and load source code into the VFS, your source unit names need to be structured in a way that makes it possible for an import callback to locate them. When using the command-line compiler the default import callback supports only loading source code from the host filesystem, which means that your source unit names must be paths. Some environments provide custom callbacks that are more versatile. For example the Remix IDE provides one that lets you import files from HTTP, IPFS and Swarm URLs or refer directly to packages in NPM registry.

RU
Используяю стандартный JSON API, можно напрямую предоствлять имена и содержимое всех исходных файлов, |как часть входных данных компилятора(?). В таком случае имена блоков данных могут быть произвольными. Однако, если вы хотите, чтобы компилятор автоматически находил и загружал исходный код в VFS, имена ваших блоков данных исходного кода (?) должны быть структурированы таким образом, чтоб вызов `import callback` смог найти и импортировать их. При использовании командной строки компилятора/(?) стандартный `import callback` поддерживает только загрузку исходного кода из файловой системы носителя, что означает, что имена ваших блоков данных должны быть путями. Некоторые среды предоставляют собственные `callback`-и, которые более универсальны.
Например, в Remix IDE есть такой `callback`, который позволяет испортировать файлы по HTTP, IPFS и Swarm URL или напрямую ссылаться на пакеты в реестре NPM.

EN
For a complete description of the virtual filesystem and the path resolution logic used by the compiler see Path Resolution. 

RU
Полное описание виртуальной файловой системы и логики разрешения путей, используемой компилятором, приведено в разеделе Разрешения путей.