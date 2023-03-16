### TRON

Chapter 1: Introduction

If you have a background in front-end development, you are probably well accustomed to the tools that make a web developer’s life simpler - Webpack, Gulp, or Browserify.

If you have a background in Solidity, and you’ve previously deployed a smart contract to Ethereum, you’re probably familiar with using Truffle or Hardhat.

But what tools can you use to deploy your smart contracts TRON?
TronBox

TronBox is a smart contract development platform that allows you to test, compile and deploy your smart contracts to the TRON network. TronBox aims to make the life of developers easier and is packed with useful features:

    Easy smart contract compilation
    Automated ABI generation
    Integrated smart contract testing
    Support for multiple networks

TronWeb

TronWeb delivers a seamless development experience influenced by Ethereum's Web3. The TRON team has taken the core ideas of Web3 and expanded upon them to unlock the functionality of the TRON blockchain.

Provided that Node.js has been installed on your computer, we'll want you to install TronBox and TronWeb and make them available globally.

To get started, you'll need to create a new directory and install both Tronbox and TronWeb.

### zkSync
Accounts

The Ethereum blockchain is made up of accounts, which you can think of like bank accounts. An account has a balance of Ether (the currency used on the Ethereum blockchain), and you can send and receive Ether payments to other accounts, just like your bank account can wire transfer money to other bank accounts.

Each account has an address, which you can think of like a bank account number. It's a unique identifier that points to that account, and it looks like this:

0x0cE446255506E92DF41614C46F1d6df9Cc969183

We're not going to get into the nitty-gritty of addresses, but for now, you only need to understand that an address is owned by a specific user (or a smart contract) and that the users prove their identity using something called private keys.
Private keys and wallets

Ethereum uses a public/private key pair to digitally sign transactions. Any transaction you send must be signed by the private key associated with your account, and the public key can be derived from the signature and matched against your account to ensure no one can forge a transaction from your account.

Cryptography is complicated, so unless you're a cryptographer you should use battle-tested and well-reviewed cryptographic libraries instead of writing your own.

And because this your lucky day, you don't have to. Both zkSync and ethers provide a class called Wallet that manages users' key pairs and signs blockchain transactions.

We'll be covering how you can create an Ethereum wallet a bit later down the road. In this lesson, we'll walk you through how you can instantiate a zkSync wallet.
Instantiate a zkSync wallet

Every zkSync wallet has an Ethereum address associated with it, and the user that owns an Ethereum account owns the corresponding zkSync account.

The zksync.Wallet wallet class wraps ethers.Signer and zksync.Signer, allowing you to use it for transferring assets between chains (which requires you to sign transactions on Ethereum) and also for transferring assets between zkSync accounts (which requires you to sign transactions on zkSync). Sweet!

To instantiate a zkSync wallet, you must call the zksync.Wallet.fromEthSigner function passing it the following parameters:

    An instance of the ethers.Wallet class (we're going to instantiate this later in this lesson).
    Your zkSync provider

Deposit assets to zkSync

In this chapter, you're going to learn about the two types of operations a user can perform on zkSync:

    Priority operations. These are actions users initiate on the Ethereum network. Can you think of an example? Yup, deposits are priority operations.👏🏻👏🏻👏🏻

    Transactions. These are actions users initiate on zkSync. An example of a transaction is when Alice makes a payment on zkSync.

    Note the following about zkSync transactions:

        When you submit a transaction to zkSync, it's instantly confirmed by the protocol. That's nice, but you should know that an instant confirmation is just a promise the operators make that they'll add the transaction to the next block. If you trust the operators then you don't need to wait for the transaction to be finalized.

        A zkSync transaction is final after the SNARK proof is accepted by the Ethereum smart contract. This takes around 10 minutes.

In this chapter, we'll look into how you can deposit assets to zkSync.
Deposit assets to zkSync

Depositing assets to zkSync is as simple as calling the depositToSyncFromEthereum as follows:

```javascript
const deposit = await zkSyncWallet.depositToSyncFromEthereum({
    depositTo: recipient,
    token: token,
    amount: amountInWei
})
```

The parameters of this function are self-explanatory, so we won't spend time explaining them.

But what happens after you call this function?

First, the transaction gets mined on the Ethereum network. At this stage, the transaction is not yet reflected on zkSync. However, if you don't want your users to stare at a blank screen for too long and you trust this is secure enough, you can use the awaitEthereumTxCommit function to await for the deposit transaction to be mined:

await deposit.awaitEthereumTxCommit()

Second, the transaction is committed to zkSync. When this happens, your balance gets updated accordingly. To check when that happens, you can use the awaitReceipt function.

await deposit.awaitReceipt()

Lastly, once a specific number of blocks get confirmed on Ethereum, the transaction is considered finalized or verified. You can check this by calling the awaitVerifyReceipt function.

await deposit.awaitVerifyReceipt()

    Note: You can only verify a single condition, not all. In this lesson, we'll use the deposit.awaitReceipt function. For our purposes, it's a good enough bargain between security and user experience.

Transfer fees

On zkSync, operations are cheap but they're not free. In this chapter, we're going to continue by teaching you how you can calculate the fee associated with each transaction.

As the protocol performs the computation and stores the state off-chain, the fees users must pay are comprised of two separated components:

    off-chain fee, representing the cost of computation and storage. This component is invariable
    on-chain fee, representing the cost of verifying the SNARK on Ethereum. This cost is amortized across all transactions in a block, and it's variable because it depends on the price of gas.

Here's an example of computing the fee for a specific transaction:

const feeInWei = await zkSyncProvider.getTransactionFee(transactionType, address, token)

In this example, the getTransactionFee function takes three parameters:

    transactionType: specifies whether this is a "Withdraw" or "Transfer"
    address: represents the address of the recipient
    token: specifies the type of token you want to transfer (e.g. "ETH")

The getTransactionFee returns a promise which resolves to an object with the following structure:

````javascript
export interface Fee {
    // Operation type (amount of chunks in operation differs and impacts the total fee).
    feeType: "Withdraw" | "Transfer" | "TransferToNew",
    // Amount of gas used by transaction
    gasTxAmount: utils.BigNumber,
    // Gas price (in wei)
    gasPriceWei: utils.BigNumber,
    // Ethereum gas part of fee (in wei)
    gasFee: utils.BigNumber,
    // Zero-knowledge proof part of fee (in wei)
    zkpFee: utils.BigNumber,
    // Total fee amount (in wei)
    // This value represents the summarized fee components, and it should be used as a fee
    // for the actual operation.
    totalFee: utils.BigNumber,
}
````

Now you can do the math and add up all components of the fee, or just use totalFee.

Which one do you choose?

There's no need to answer this question, I probably already know the answer.😉

But, as with transfers, this function expresses all values in wei. If you want to present the fee to your users, you'd better convert it to a human-readable form by:

    converting it from BigNumber to string
    calling the ethers.utils.formatEther function

Example:

const fee = ethers.utils.formatEther(feeInWei.toString())

That's how easy it is to calculate the fee!

Committed and verified balances

When you transfer assets on zkSync, the operator includes your transaction in a new block and pushes this new block to the zkSync smart contract on Ethereum using a Commit transaction. Then, the SNARK proofs for each transaction in the block is and published on Ethereum using a Verify transaction. Once the Verify transaction is mined on Ethereum, the protocol considers the new state to be final.

Remember that you can receive some tokens and then immediately send those tokens to another user as part of a different transaction? How can that be possible if the protocol waits for the transaction to be mined on Ethereum? The answer is that there are two types of balances on zkSync (committed and verified) and you can use the assets in your committed balance as you wish.

Just to make things clear:

    The committed balance includes all verified and committed transactions
    The verified balance includes only verified transactions

There are two way in which you can retrieve the balances for an account:

    Using the await wallet.getBalance function as follows:

    const committedETHBalance = await wallet.getBalance('ETH')
    const verifiedETHBalance = await wallet.getBalance('ETH', 'verified')

    Retrieving the account state which is a JSON object that describes the current state of your account:

    const state = await wallet.getAccountState()

    If you console.log the state variable, the output would look similar to the following example:

```javascript
    { address: '0xc26f2adeeebbad73f25329ffa12cd3889429b5b6',
     committed:
     { balances: { ETH: '100000000000000000' },
       nonce: 1,
       pubKeyHash: 'sync:de9de11bdad08aa1cdc2beb5b2b7c7f29c10f079' },
     depositing: { balances: {} },
     id: 138,
     verified:
     { balances: { ETH: '100000000000000000' },
       nonce: 1,
       pubKeyHash: 'sync:de9de11bdad08aa1cdc2beb5b2b7c7f29c10f079' } }
```

The second method is handier when you want to retrieve balances for multiple assets.

Now, there's something else you should pay attention to before jumping to the part where you write the code: if an account balance is zero, the corresponding JSON field (for example state.committed.balances.ETH) will be undefined. Trying to console.log an undefined variable will break your application, so you should gate the lines of code that display the verified and committed balances with an if/else statement as follows:

if (variable) {
  doSomething()
} else {
  doSomethingElse()
}

In this example, if variable is defined, then the doSomething function gets called. Otherwise, if variable is undefined, then the doSomethingElse function gets called.


### Setting Up New Oracles

Great! Now it's time to write the function that sets up a new oracle by adding its address to the list of known oracles. You might think this is just a matter of calling the oracles.add function with the address of the oracle you want to add as an argument.

Well... think again. Before doing that you'll want to:

    Verify that the caller is the owner of the contract.
    Make sure that the address is not already an oracle.
    Notify the front-end that a new oracle has been added by firing an event at the end of the function.


### Using Constructor to Set the Owner
Now that your contract doesn't inherit from Ownable, you must find a way to specify its owner. You'll do this by adding a constructor. This is a special function that's executed only once, when a contract gets deployed.

Here's an example of using a constructor:

````javascript
contract MyAwesomeContract {
  constructor (address _owner) public {
    // Do something
  }
````

To make this work, your constructor should take a parameter - the owner's address. So you must revisit the migration file and edit the line that deploys the smart contract to something like the following:

deployer.deploy(EthPriceOracle, '0xb090d88a3e55906de49d76b66bf4fe70b9d6d708')

Next, the code inside the constructor must add the owner (which comes from the function's arguments) to the list of owners:

owners.add(_owner);


### Problems of the first decision
Awesome, you've completed Lesson 2 of our series about building and interacting with an oracle.

Because we're just building an oracle for demo purposes, we've made a bunch of decisions that simplified things a bit. For example, think about what would happen when you bring the oracle down for an upgrade. Yeah, even if it'll take just a few minutes until you bring it back online, all the requests made during this period will be lost. And there's no way to notify the app that a particular request hasn't been processed. A solution for this is to keep track of the last block that got processed, and, every time the oracle starts, it should take it from there.

A production-ready oracle should take care of this, and a few other things, of which, the most important is: how to make the oracle more decentralized. And this is exactly what we'll cover next.

Stay tuned for our next lesson!


### Deploy the contract
> cd oracle && npx truffle migrate --network extdev --reset -all && cd ..
"scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "deploy:oracle": "cd oracle && npx truffle migrate --network extdev --reset -all && cd ..",
    "deploy:caller": "cd caller && npx truffle migrate --network extdev --reset -all && cd ..",
    "deploy:all": "npm run deploy:oracle && npm run deploy:caller"
  },

>node EthPriceOracle.js
>node Client.js

### Working with Numbers in Ethereum and JavaScript
Remember we've mentioned that data needs a bit of massaging before it's sent to the oracle contract. Let's look into why.

The Ethereum Virtual Machine doesn't support floating-point numbers, meaning that divisions truncate the decimals. The workaround is to simply multiply the numbers in your front-end by 10**n. The Binance API returns eight decimals numbers and we'll also multiply this by 10**10. Why did we choose 10**10? There's a reason: one ether is 10**18 wei. This way, we'll be sure that no money will be lost.

But there's more to it. The Number type in JavaScript is "double-precision 64-bit binary format IEEE 754 value" which supports only 16 decimals...

Luckily, there's a small library called BN.js that'll help you overcome these issues.

    ☞ For the above reasons, it's recommended that you always use BN.js when dealing with numbers.

Now, the Binance API returns something like 169.87000000.

Let's see how you can convert this to BN.

First, you'll have to get rid of the decimal separator (the dot). Since JavaScript is a dynamically typed language (that's a fancy way of saying that the interpreter analyzes the values of the variables at runtime and, based on the values, it assigns them a type), the easiest way to do this is...

aNumber = aNumber.replace('.', '')

Continuing with this example, converting aNumber to BN would look something like this:

const aNumber = new BN(aNumber, 10)

    Note: The second argument represents the base. Make sure it's always specified.

We've gone ahead and filled in almost all the code that goes to the setLatestEthPrice function. Here's what's left for you to do.

### Oracle 


### Truffle
> npm install -g truffle
> truffle init
[Truffle Structure](imgs/truffle-structer.png)
> npm install truffle-hdwallet-provider 
(Its only purpose is to handle the transaction signing)

deploy:
>truffle migrate --network <name-provider in the truffle.js file>

### Ganache
It sets up a local Ethereum network
Migrations.sol keeps track of the changes you are making to your code.

[Configurating truffle](files/truffle.js)

### Loom
> npm install loom-truffle-provider
[tutorial](https://loomx.io/developers/en/basic-install-all.html)

### Случайные числа

Отлично! Теперь разберемся с логикой битвы.

Все хорошие игры требуют некоего элемента случайности. Как в Solidity генерировать случайные числа?

Правильный ответ — НИКАК. Нет способа делать это безопасно.

И вот почему.
Генерация случайных чисел через keccak256

Лучший способ создать источник случайностей в Solidity — хэш-функция keccak256.

Можно написать код вроде такого:

```javascript
// Сгенерировать случайное число от 1 до 100:
uint randNonce = 0;
uint random = uint(keccak256(now, msg.sender, randNonce)) % 100;
randNonce++;
uint random2 = uint(keccak256(now, msg.sender, randNonce)) % 100;
```

Эта функция берет временную метку now, msg.sender и добавочный nonce (nonce - число, используемое только один раз, поэтому не запускают дважды хэш-функцию с одним и тем же наборов входных данных).

Затем она использует keccak для преобразования входных данных в случайный хэш, конвертирует этот хэш в uint, далее выполняет %100, чтобы взять только последние 2 цифры. Эта процедура дает нам абсолютно случайное число от 0 до 100.
Этот метод уязвим перед типом атаки, известным как «нечестная нода»

Когда ты вызываешь функцию в контракте Ethereum, то транслируешь ее ноде или нодам в сети как транзакцию. Ноды в сети собирают много транзакций вместе и стараются первыми найти решение сложной математической задачи, чтобы получить «Доказательство работы». Затем они публикуют в сети эту группу транзакций и доказательство работы (PoW) как блок.

Как только нода решила задачу и получила PoW, другие ноды перестают решать эту задачу, проверяют валидность списка транзакций решившей ноды, принимают блок и включают его в блокчейн. Затем приступают к поиску решения задачи для следующего блока.

Теоретически из-за этого функцию случайных чисел можно взломать.

Представим, что существует контракт игры типа «орел-решка» - если выпадает орел, то активы удваиваются, если выпадает решка, то игрок теряет все. Предположим, что функция определяет выпадение орла и решки. (random >= 50 - орел, random <50 - решка).

Если человек держит ноду, то он может опубликовать транзакцию только в своей собственной ноде и не делиться ей ни с кем. Он может запустить функцию подбрасывания монеты, чтобы увидеть результат — орел или решка — и не включать транзакцию в следующий блок при проигрыше. Можно продолжать делать это бесконечно, пока не выпадет нужная сторона монеты, и эту транзакцию уже включить в следующий блок — профит!
Как же решить проблему безопасной генерации случайных чисел в Ethereum?

Поскольку содержимое блокчейна видно всем участникам, это нелегкая задача, и ее решение выходит за рамки данного руководства. Для вдохновения почитай тему на [StackOverflow](https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract). Одна из идей — использовать оракул для доступа к функции генерации случайных чисел извне блокчейна Ethereum.

Разумеется, в условиях десятков тысяч конкурирующих за блок нод в сети Ethereum, шансы на нахождение ответа следующего блока крайне низки. Нужно много времени и вычислительных ресурсов, чтобы воспользоваться уязвимостью - но если вознаграждение было бы достаточно высоким (например, если можно выиграть 100 000 000 долларов в орел-решку), то атаковать целесообразно.

Таким образом генерация случайных чисел в Ethereum НЕ безопасна. На практике, если наша случайная функция не обещает очень больших денег, то у пользователей игры не хватит ресурсов для атаки.

На этом курсе мы пишем простую игру в демонстрационных целях и в ней не задействованы реальные деньги. Поэтому используем простой в реализации генератор случайных чисел, отдавая себе отчет, что он не полностью безопасен.

### Вывод средств

В предыдущей главе мы узнали, как отправить ETH на адрес контракта. Что происходит после отправки?

После отправки ETH он сохранится в контракте в аккаунте Ethereum. Он не исчезнет оттуда, пока ты не добавишь функцию снятия ETH с адреса контракта.

Вот функция для снятия ETH с адреса контракта:

```javascript
contract GetPaid is Ownable {
  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }
}
```

Обрати внимание, что мы используем owner и onlyOwner из контракта Ownable при условии его импортации.

Можно перевести ETH на адрес, используя функцию transfer, а функция this.balance вернет общий баланс контракта. Если 100 пользователей заплатили по 1 ETH, this.balance вернет 100 ETH.

Ты можешь использовать transfer, чтобы переводить средства на любой адрес Ethereum. Например, можно предусмотреть функцию, которая переведет ETH обратно msg.senderу, если он переплатил за предмет:

uint itemFee = 0.001 ether;
msg.sender.transfer(msg.value - itemFee);

Или в контракте между покупателем и продавцом можно сохранить адрес продавца в хранилище, а затем, когда кто-то купит его предмет, перевести ему комиссию, оплаченную покупателем: seller.transfer (msg.value).

Это одна из самых классных фишек программирования на Ethereum - можно создавать никому не подконтрольные децентрализованные рынки вроде нашего.

### Платные опции

Мы уже видели множество модификаторов функций. Сложно сразу все запомнить, поэтому проведем быстрый обзор:

    Модификаторы видимости контролируют вызов функции: private означает, что функцию
    могут вызвать другие функции только внутри контракта; internal похожа на private,
    но ее помимо функций внутри контракта могут вызывать те, которые наследуют ей;
    external может быть вызвана только извне контракта; и, наконец, public функцию
    можно вызвать откуда угодно — изнутри и извне.

    Модификаторы состояния сообщают нам, как функция взаимодействует с блокчейном: 
    view означает только просмотр, то есть после запуска функции данные не 
    пересохраняются и не изменяются. pure означает, что функция не только 
    не сохраняет, но даже не считывает данные из блокчейна. Обе эти функции 
    не тратят газ, если их вызывают извне контракта (но тратят газ, если их 
    вызывают внутренние функции).

    Есть пользовательские модификаторы, о которых мы узнали в уроке 3, к 
    примеру onlyOwner и aboveLevel. Для определения их влияния на функцию 
    нужно задавать пользовательскую логику.

Эти модификаторы могут быть объединены вместе в определение функции следующим образом:

function test() external view onlyOwner anotherModifier { /* ... */ }

В этой главе мы введем еще один модификатор функции: payable.

### Модификатор payable

Функции payable — платные — одна из причин, почему Solidity и Ethereum настолько классные. Это особый тип функций, которые могут получать ETH.

Подумаем минутку. Когда ты вызываешь функцию API на обычном веб-сервере, то ты не сможешь одновременно с вызовом функции отправить USD. Биткоин, к слову, тоже не сможешь:).

Но в Ethereum и деньги (ETH), и данные (транзакции), и сам код контракта живут в блокчейне Ethereum. Поэтому можно вызвать функцию и одновременно заплатить за исполнение контракта.

Это позволяет задействовать действительно интересную логику, например, сделать запрос платежа по контракту для выполнения функции.
Рассмотрим пример

```javascript
contract OnlineStore {
  function buySomething() external payable {
    // Проверь, что 0.001 ETH действительно отправлен за вызов функции 
    require(msg.value == 0.001 ether);
    // Если да, то вот логика, чтобы перевести цифровой актив вызывающему функцию 
    transferThing(msg.sender);
  }
}
```

Здесь msg.value - это способ увидеть, сколько ETH было отправлено на адрес контракта, а ether - встроенный блок.

Что произойдет, если кто-то вызовет функцию из web3.js (из внешнего интерфейса DApp JavaScript)? Смотри ниже:

```javascript
// Допустим, `OnlineStore` указывает на контракт в Ethereum:
OnlineStore.buySomething().send(from: web3.eth.defaultAccount, value: web3.utils.toWei(0.001))
```

Обрати внимание на поле value, где javascript-функция указывает, сколько ether нужно отправить (0.001). Если представить транзакцию как конверт, а параметры вызова функции как содержимое письма, то добавление value - это как положить наличные в конверт. Письмо и деньги вместе доставляются получателю.

    Примечание. Если функция не помечена как payable, а на нее пытаются отправить ETH, то функция отклонит транзакци

### Проблема этого подхода

Вроде просто, но посмотрим, что произойдет, если позже мы добавим функцию передачи зомби от одного владельца к другому (а мы обязательно захотим добавить эту фичу в следующем уроке!).

Функция передачи должна:

    Переместить зомби в массив ownerToZombies нового владельца
    Удалить зомби из массива ownerToZombies предыдущего владельца
    В массиве старого владельца переместить всех зомби на одно место вверх, чтобы заполнить пробел, а затем
    Уменьшить длину массива на 1.

Шаг 3 требует слишком много газа, потому что пришлось бы переписать положение для каждого перемещенного зомби. Если у владельца 20 зомби и он продаст первого, то чтобы сохранить порядок зомби, нужно будет сделать 19 новых записей.

Поскольку запись в хранилище является одной из самых дорогих операций в Solidity, вызов функции передачи потратит неоправданно много газа. И что еще хуже, при каждом вызове расход газа будет разным, в зависимости от количества зомби в армии пользователя и порядкового номера продаваемого зомби. Таким образом, пользователь не будет знать, сколько газа отправить.

    Примечание. Конечно, мы могли бы просто переместить последнего зомби в массиве,
    чтобы заполнить недостающий слот и уменьшить длину массива на единицу. Но тогда
    порядок зомби в армии будет меняться при каждой сделке.

Так как функция view при вызове извне не тратит газ, мы можем просто использовать for-loop в getZombiesByOwner для перестроения массива принадлежащих конкретному владельцу зомби. Тогда функция transfer будет намного дешевле, так как нам не нужно будет перестраивать массивы в хранилище. Кажется контр-интуитивным, но в целом этот подход дешевле.

### Использование циклов for

Синтаксис циклов for в Solidity похож на JavaScript.

Например, мы хотим создать массив четных чисел:

```javascript
function getEvens() pure external returns(uint[]) {
  uint[] memory evens = new uint[](5);
  // Отслеживай порядковый номер в новом массиве:
  uint counter = 0;
  // Повторяй цикл `for` от 1 до 10:
  for (uint i = 1; i <= 10; i++) {
    // Если `i` четное...
    if (i % 2 == 0) {
      // То в массив добавится
      evens[counter] = i;
      // Добавь счетчик к следующему свободному номеру в `evens`:
      counter++;
    }
  }
  return evens;
}
```
Функция вернет массив, который содержит [2, 4, 6, 8, 10].

### Дорогое место в хранилище

Одна из самых дорогих операций в Solidity - использование storage - особенно запись в него.

Каждый раз, когда ты записываешь или изменяешь данные, они навсегда записываются в блокчейн! Тысячи нод по всему миру должны хранить эти данные на своих жестких дисках, объем данных растет по мере роста блокчейна. Поэтому за это надо платить газ.

Чтобы снизить затраты, старайся избегать записывать данные в хранилище, кроме случаев, когда это абсолютно необходимо. Иногда приходится прибегать к неэффективной логике программирования - например, восстанавливать массив в memory при каждом вызове функции вместо простого сохранения его в переменной для быстрого поиска.

В большинстве языков программирования объединение в цикл больших наборов данных — дорогостоящая операция. А в Solidity это намного дешевле, чем storage, если цикл находится внутри функции external view, так как за view пользователь не платит газ. (А газ стоит денег!).

В следующей главе мы перейдем к циклам for, но сначала посмотрим, как задавать массивы в памяти.
Задание массивов в памяти

Чтобы создать новый массив внутри функции без необходимости записывать в хранилище, используй ключевое слово memory. Массив просуществует только до конца вызова функции и потратит меньше газа, чем обновление массива в storage. Если вызываемая извне функция view, то операция будет бесплатной.

Вот как задать массив в памяти:

```javascript
function getArray() external pure returns(uint[]) {
  // Создай в памяти новый массив с длиной 3
  uint[] memory values = new uint[](3);
  // Добавь значений
  values.push(1);
  values.push(2);
  values.push(3);
  // Верни массив
  return values;
}
```

Это элементарный пример синтаксиса, в следующей главе мы рассмотрим объединение циклов for для реальных кейсов.

    Примечание: массивы памяти должны создаваться с аргументом длины (3 в этом примере). Пока что их нельзя изменить с помощью array.push() аналогично массивам хранилища. Может быть, эту функцию добавят в будущей версии Solidity.


### Функции просмотра не тратят газ

Функции просмотра view не расходуют газ, когда их вызывает внешний пользователь.

Так происходит, потому что функция view только считывает данные и по факту ничего не меняет в блокчейне. Если отметить функцию web3.js с помощью view, то для запуска она будет обращаться к локальной ноде Ethereum, а не создавать транзакцию в блокчейне (которая запускается в каждой ноде и расходует газ).

Позже мы рассмотрим подробнее настройку web3.js в ноде. На данный момент выгода от использования функции view где только возможно — оптимизации расхода газа в DApp пользователей.

    Примечание. Если функция view вызывается внутренне из другой функции в том
    же самом контракте, который не является функцией view, то ты потратишь газ.
    Это связано с тем, что другая функция создает транзакцию на Ethereum и каждая
    нода будет верифицировать ее. Функции view доступны только при внешнем вызове.


### Передаем структуры как аргументы

Можно передавать структуре указатель хранилища как аргумент private или internal функции. Это полезно для передачи структур Zombie между функциями.

Синтаксис выглядит следующим образом:

```javascript
function _doStuff(Zombie storage _zombie) internal {
  // Сделать что-либо с _zombie
}
```
Таким способом мы можем передать функции ссылку на нашего зомби вместо того, чтобы передавать и потом искать зомби-ID.

### Единицы времени

В Solidity есть собственные единицы для управления временем.

Переменная now вернет текущую временную метку unix (количество секунд, прошедших с 1 января 1970 года). Время этой записи по unix - 1515527488.

    Примечание. Unix-время традиционно сохраняется в 32-битном номере. Это приведет к 
    проблеме «2038 года», когда 32-разрядные временные метки unix переполнят и сломают
    множество устаревших систем. Поэтому, если мы хотим, чтобы наш DApp продолжал работать
    и через 20 лет, желательно было бы использовать 64-битное число. Но пользователям 
    пришлось бы тратить больше газа для работы DApp. Есть над чем поломать голову!

Solidity также содержит единицы времени seconds, minutes, hours, days, weeks и years. Они преобразуются в uint, равный количеству секунд в течение отрезка времени. Например: 1 минута равна 60, 1 час равен 3600 (60 секунд x 60 минут), 1 день равен 86400 (24 часа x 60 минут x 60 секунд).

Пример использования единиц времени:

```javascript
uint lastUpdated;

// Выставим `lastUpdated` на `now`
function updateTimestamp() public {
  lastUpdated = now;
}

// Вернет `true`, если прошло 5 минут с момента вызова `updateTimestamp`,
// и `false`, если 5 минут не прошло
function fiveMinutesHavePassed() public view returns (bool) {
  return (now >= (lastUpdated + 5 minutes));
}
```

Мы можем использовать единицы времени для cooldown (перезарядки).

### Газ

Круто! Теперь ты знаешь, как обновлять ключевые части DApp, при этом заставляя других пользователей держаться подальше от твоих контрактов.

Теперь рассмотрим еще одно серьезное отличие Solidity от других языков программирования:
Газ — топливо для DApps на Ethereum

В Solidity пользователи должны заплатить за каждый вызов функции DApp с помощью валюты под названием газ. Газ покупают вместе с эфиром, валютой Ethereum. Следовательно, пользователи расходуют ETH, чтобы выполнить функцию в приложении DApp.

Количество газа для запуска зависит от сложности логики функции. У любой операции есть цена газа, она вычисляется, исходя на количестве вычислительных ресурсов, необходимых для выполнения операции (например, запись в хранилище намного дороже, чем добавление двух целых чисел). Общая стоимость газа функции - сумма затрат газа на все операции.

Поскольку запуск функций стоит пользователям реальных денег, оптимизация кода в Ethereum гораздо важнее, чем в других языках программирования. Если код написан небрежно, а пользователям придется платить за выполнение функций, в пересчете на тысячи пользователей это может означать миллионы долларов ненужных комиссий.
Зачем нужен газ?

Ethereum похож на большой, медленный, но крайне безопасный компьютер. Когда ты выполняешь функцию, каждая нода в сети должна запустить такую же функцию, чтобы проверить результат на выходе. Это то, что делает Ethereum децентрализованным, а данные в нем неизменяемыми а не подверженными цензуре.

Создатели Ethereum хотели быть уверенными, что никто не сможет заспамить сеть, запустив бесконечный цикл, или поглотить все ресурсы сети своими интенсивными вычислениями. Поэтому они сделали транзакции платными — пользователи должны отдавать газ за использование вычислительных мощностей и хранилища.

    Примечание: для сайдчейнов, как например для используемого авторами Loom Network в игре КриптоЗомби, 
    это правило не обязательно. Нет смысла запускать игру вроде World of Warcraft в главной сети Ethereum
     - стоимость газа будет заградительным барьером. Но зато такая игра может работать на сайдчейне с
      другим алгоритмом консенсуса. В следующих уроках мы вернемся к вопросу, какие DApps развертывать на
       сайдчейне, а какие в главной сети Ethereum.

Как упаковать структуру, сэкономив газ

Мы упоминали в первом уроке, что есть разные типы uint: uint8, uint16, uint32 и так далее.

Обычно использование этих подтипов нецелесообразно, поскольку Solidity резервирует 256 бит в хранилище независимо от размера uint. Например, использование uint8 вместо uint (uint256) не экономит газ.

Но внутри структур есть исключение.

Если внутри структуры несколько uint, использование uint меньшего размера позволит Solidity объединить переменные и уменьшить объем хранилища. Например:

struct NormalStruct {
  uint a;
  uint b;
  uint c;
}

struct MiniMe {
  uint32 a;
  uint32 b;
  uint c;
}

// `mini` будет стоить меньше, чем `normal` из-за упаковки структуры
NormalStruct normal = NormalStruct(10, 20, 30);
MiniMe mini = MiniMe(10, 20, 30); 

Так что внутри структур можно использовать наименьшие целочисленные подтипы, которые позволяют запустить код.

Еще можно объединять идентичные типы данных в кластеры — ставить их в структуре рядом друг с другом. Так Solidity оптимизирует пространство в хранилище. К примеру, структура поля uint c; uint32 a; uint32 b; будет стоить меньше газа, чем структура с полями uint32 a; uint c; uint32 b;, потому что поля uint32 группируются вместе.

### Модификатор функции onlyOwner (единственный владелец)

Теперь базовый контракт ZombieFactory наследует Ownable и мы можем использовать модификатор onlyOwner в ZombieFeeding.

Запомни, как работает наследование в контрактах:

ZombieFeeding is ZombieFactory
ZombieFactory is Ownable

Таким образом, ZombieFeeding также и Ownable, он может получить доступ к функциям, событиям и модификаторам контракта Ownable. Это относится к любым контрактам, которые будут наследовать ZombieFeeding в будущем.
Модификаторы функций

Модификатор функции выглядит точно так же, как сама функция, но использует ключевое слово modifier вместо function. Его нельзя вызвать напрямую, как функцию - вместо этого мы можем добавить модификатор в конце определения функции и изменить ее поведение.

Рассмотрим на примере onlyOwner:

```javascript
/**
 * @dev Throws if called by any account other than the owner.
 */
modifier onlyOwner() {
  require(msg.sender == owner);
  _;
}

Используем модификатор:

contract MyContract is Ownable {
  event LaughManiacally(string laughter);

  // Обрати внимание на использование `onlyOwner` ниже:
  function likeABoss() external onlyOwner {
    LaughManiacally("Muahahahaha");
  }
}
```

Видишь модификатор onlyOwner в функции likeABoss? Когда ты вызываешь likeABoss, в первую очередь выполняется код внутри onlyOwner. Затем, когда он доходит до оператора _; в onlyOwner, он возвращается и выполняет код внутри likeABoss.

Хотя есть и другие способы использования модификаторов, одним из наиболее распространенных вариантов является добавление быстрой проверки require перед выполнением функции.

Добавление модификатора onlyOwner в функцию делает так, что только единственный владелец, например ты, может вызвать эту функцию.

    Примечание: предоставление владельцу особой власти над подобным контрактом часто необходимо. Но властью можно злоупотреблять: например, 
    владелец может оставить бэкдор, который переведет всех зомби на его адрес!

    Важно помнить, что DApp на Ethereum не означает децентрализацию по умолчанию. Читай исходники, чтобы убедиться, что контракт не содержит средств 
    передачи контроля другому владельцу. Разработчику необходимо найти баланс между контролем над DApp для исправления багов, и созданием децентрализованной
     платформы, которой пользователи могут доверять.


### Собственные контракты

Насчет дыры в безопасности в предыдущей главе.

Функция setKittyContractAddress — внешняя external, ее может вызвать кто угодно! Это означает, что любой вызвавший функцию может заменить адрес контракта Криптокотиков и испортить игру всем остальным.

Нам нужна возможность обновления адреса в контракте, но также надо закрыть возможность обновления всем остальным.

Для подобных случаев есть одна распространенная практика: делать контракты Ownable — собственными, то есть принадлежащими тебе и дающими особые привилегии.
Собственный контракт OpenZeppelin

Ниже пример Ownable контракта из библиотеки Solidity OpenZeppelin. OpenZeppelin - это библиотека безопасных смарт-контрактов сообщества, которыми можно пользоваться для личных DApps. Пока ты будешь ждать Урока 4, посмотри библиотеки на этом сайте. Поможет в дальнейшем.

Прочитай контракт ниже. Ты увидишь несколько неизученных моментов, не волнуйся, сейчас мы поговорим о них.

```javascript
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}
```

Вот что мы не видели раньше:

    Конструкторы: function Ownable() это конструктор, особая опциональная функция с таким же именем, как контракт. 
    Выполняется только один раз в момент создания контракта.
    Модификаторы функции: modifier onlyOwner(). Модификаторы — полуфункции, которые используются для изменения других 
    функций, обычно для проверки некоторых требований до их выполнения. В этом случае onlyOwner можно использовать для ограничения
     доступа, чтобы только владелец контракта мог запустить эту функцию. В следующей главе мы подробно поговорим о модификаторах функций, 
     а также о странном _; и его назначении. Ключевое слово indexed: пока не нужно, об этом потом.

В целом Ownable контракт делает следующее:

    Когда контракт создается, конструктор присваивает msg.sender (развернувшему контракт) атрибут owner.

    Он добавляет модификатор onlyOwner, который может ограничить доступ к определенным функциям, предоставив его только владельцу owner.

    Он позволяет передать контракт новому owner.

onlyOwner настолько распространенное требование для контрактов, что большинство DApps Solidity начинаются с копирования/вставки Ownable контракта, а следующий контракт наследует ему.

Поскольку мы хотим ограничить setKittyContractAddress только для onlyOwner, сделаем то же самое и для нашего контракта.

### Неизменяемость контрактов

До сих пор Solidity был похож на другие языки программирования, например на JavaScript. Но у Ethereum DApps есть несколько важных отличий от обычных приложений.

Первое — после развертывания на Ethereum контракта он становится неизменяемым. Это значит, что он никогда не сможет быть модифицирован или обновлен.

Первоначально развернутый в контракте код останется в блокчейне навсегда. Это одна из самых неприятных проблем с безопасностью в Solidity. Если в коде контракта есть недостаток, позже его не удастся исправить. Тебе придется убедить пользователей перейти на исправленный адрес смарт-контракта.

Одновременно это и преимущество смарт-контрактов. Код - это закон. Если прочесть и проверить код смарт-контракта, то можно не волноваться: каждый раз при вызове функция будет делать именно то, что написано в коде. Никто не может впоследствии изменить функцию и задать ей незаявленное поведение.
Внешние зависимости

Во втором уроке мы зашили адрес контракта Криптокотиков в DApp. Но что произойдет, если в контракте Криптокотиков обнаружится баг или кто-то уничтожит всех котиков?

Это маловероятно, но если вдруг подобное произойдет, то наш DApp станет совершенно бесполезным - он будет указывать на адрес, который больше не возвращает котиков. Зомби не смогут питаться котятами, а мы не сможем починить контракт.

По этой причине имеет смысл предустмотреть функции, позволяющие обновлять ключевые части DApp.

Например, вместо того, чтобы зашивать адрес контракта Криптокотиков в DApp, лучше предусмотреть функцию setKittyContractAddress (задать адрес котоконтракта). Если в контракте Криптокотиков что-то пойдет не так, она позволит в будущем изменить адрес. 

### Работа с несколькими возвращаемыми значениями

Функция getKitty — первый видимый нами пример возвращения множественных значиний. Посмотрим, как с ними обращаться:

```javascript
function multipleReturns() internal returns(uint a, uint b, uint c) {
  return (1, 2, 3);
}z

function processMultipleReturns() external {
  uint a;
  uint b;
  uint c;
  // Вот как выполнять несколько заданий:
  (a, b, c) = multipleReturns();
}

// А если нам важно только одно значение...
function getLastReturnValue() external {
  uint c;
  // ...мы просто оставим другое поле пустым
  (,,c) = multipleReturns();
}
```

### Используем интерфейс

Продолжим наш предыдущий пример с NumberInterface, как только зададим интерфейс:

contract NumberInterface {
  function getNum(address _myAddress) public view returns (uint);
}

Мы можем использовать его в контракте следующим образом:

```javascript
contract MyContract {
  address NumberInterfaceAddress = 0xab38... 
  // ^ Адрес контракта FavoriteNumber в Ethereum
  NumberInterface numberContract = NumberInterface(NumberInterfaceAddress)
  // Сейчас `numberContract` указывает на другие контракты

  function someFunction() public {
    // Теперь можно вызвать `getNum` из контракта:
    uint num = numberContract.getNum(msg.sender);
    // ...и сделать что-то с `num` здесь
  }
}
```

Этим способом контракт будет взаимодействовать с всеми другими контрактами в блокчейне Ethereum, если они задают функции как public (открытые) или external (внешние). 

### Взаимодействие с другими контрактами

Чтобы наш контракт связался с другим контрактом в блокчейне, которым владеем не мы, сначала нужно определить интерфейс.

Посмотрим простой пример. Допустим, в блокчейне существует такой контракт:

```javascript
contract LuckyNumber {
  mapping(address => uint) numbers;

  function setNum(uint _num) public {
    numbers[msg.sender] = _num;
  }

  function getNum(address _myAddress) public view returns (uint) {
    return numbers[_myAddress];
  }
}
```

Это простой контракт, где каждый может хранить свой счастливый номер, связаный с личным адресом Ethereum. Тогда любой может найти счастливый номер человека по адресу.

Теперь допустим, что у нас есть другой внешний контракт, который хочет считать данные в этом контракте, используя функцию getNum.

Сначала нам надо будет определить интерфейс контракта LuckyNumber (счастливый номер):

contract NumberInterface {
  function getNum(address _myAddress) public view returns (uint);
}

Это похоже на определение контракта, но есть несколько отличий. Во-первых, мы объявляем только те функции, с которыми хотим взаимодействовать - в данном случае getNum - и не упоминаем другие функции или переменные состояния.

Во-вторых, мы не определяем тела функций. Вместо фигурных скобок ({ и }) мы заканчиваем задание функции точкой с запятой (;).

Это как скелет контракта. Так компилятор узнает, что это интерфейс.

Если включить интерфейс в код DApp, наш контракт узнает, как выглядят функции другого контракта, как их вызвать и какой придет ответ.

В следующем уроке мы будем вызывать функции другого контракта, а пока зададим интерфейс для контракта Криптокотиков.

### Внутренние и внешние функции

В дополнение к открытым и закрытым, в Solidity есть еще два типа видимости для функций: internal (внутренняя) и external (внешняя).

internal (внутренняя) это почти как private (закрытая), разница лишь в том, что к нему могут получить доступ только контракты, которые наследуют этому контракту. (Звучит как полная ерунда!).

external (внешний) это как public (открытая), с той лишь разницей, что она может быть вызвана ТОЛЬКО за пределами контракта — другими функциями вне его. Позже поговорим о том, когда использовать external а когда public функции.

Для internal или external функций синтаксис такой же, как в private and public:

```javascript
contract Sandwich {
  uint private sandwichesEaten = 0;

  function eat() internal {
    sandwichesEaten++;
  }
}

contract BLT is Sandwich {
  uint private baconSandwichesEaten = 0;

  function eatWithBacon() public returns (string) {
    baconSandwichesEaten++;
    // Можно вызвать функцию, потому что она внутренняя
    eat();
  }
}
```


### Хранилище и память

В Solidity есть два места, где могут сохраняться переменные: в storage (хранилище) и в memory (памяти).

Хранилище используют, чтобы сохранить переменные в блокчейн навсегда. Память используют для временного хранения переменных, они стираются в промежутках, когда внешняя функция обращается к контракту. Это похоже на жесткий диск компьютера и оперативную память.

В большинстве случаев тебе не придется использовать ключевые слова, потому что Solidity определяет по умолчанию, что куда сохранять. Переменные состояния (заданные вне функции) по умолчанию хранятся записанными в блокчейне. Переменные, заданные внутри функции, пишутся в память и исчезнут, как только вызов функции закончится.

Тем не менее, есть случаи, когда обязательно надо указывать ключевые слова, а именно когда ты работаешь со структурами и массивами в пределах функции:

```javascript
contract SandwichFactory {
  struct Sandwich {
    string name;
    string status;
  }

  Sandwich[] sandwiches;

  function eatSandwich(uint _index) public {
    // Сэндвич mySandwich = sandwiches[_index];

    // ^ Вроде все в порядке, но Solidity выдаст предупреждение, 
    // что надо ясно указать `storage` или `memory`.

    // Поэтому используй ключевое слово `storage`, вот так: 
    Sandwich storage mySandwich = sandwiches[_index];
    // ...где `mySandwich` указывает на `sandwiches[_index]` в хранилище, и...
    mySandwich.status = "Eaten!";
    // ...навсегда изменит `sandwiches[_index]` в блокчейне.

    // Если нужна просто копия, используй `memory`:
    Sandwich memory anotherSandwich = sandwiches[_index + 1];
    // ...тогда `anotherSandwich` будет простой копией данных в памяти, таким образом... 
    anotherSandwich.status = "Eaten!";
    // ...всего лишь модифицирует временную переменную и не окажет влияния
    // на `sandwiches[_index + 1]`. Но ты можешь сделать и так... 
    sandwiches[_index + 1] = anotherSandwich;
    // ...если надо сохранить данные в блокчейне.
  }
}

```
Не волнуйся, если пока не все ясно — на протяжение курса мы подскажем, когда использовать storage, а когда memory. Компилятор Solidity тоже выдает предупреждение, когда нужно использовать одно из этих ключевых слов.

На данный момент достаточно принять как факт, что есть случаи, требующие ясного обозначения storage или memory! 

### Импорт

Зацени! Мы снесли код справа, и теперь у тебя есть вкладки в верхней части редактора. Вперед, попереключайся между вкладками, чтобы попробовать.

Код уже довольно длинный, поэтому мы разбили его на несколько файлов, чтобы сделать его более послушным. Именно так управляют длинным кодом в проектах Solidity.

Когда у тебя несколько файлов и нужно импортировать один в другой, Solidity использует ключевое слово import:

import "./someothercontract.sol";

contract newContract is SomeOtherContract {

}

Если у нас есть файл someothercontract.sol в той же директории, что и этот контракт (/ нам говорит об этом), то компилятор импортирует его.

### Наследование

Код уже довольно длинный! Чтобы не делать один длиннющий контракт и организовать код, можно разбить логику кода на несколько контрактов.

В Solidity есть фича, которая помогает управлять длинными контрактами — наследование:

```javascript
contract Doge {
  function catchphrase() public returns (string) {
    return "Клевый песик";
  }
}

contract BabyDoge is Doge {
  function anotherCatchphrase() public returns (string) {
    return "Клевый щеночек";
  }
}
```

BabyDoge (щенок) наследует Doge (Псу!). Если ты скомпилируешь и развернешь BabyDoge, он получит доступ и к catchphrase() и к anotherCatchphrase() (и ко всем остальным открытым функциям, которые мы опишем в Doge).

Это можно использовать для логического наследования (как с подтипами, Cat (кошка) это Animal (животное)), или для простой организации кода, группируя вместе одинаковую логику внутри различных классов. 

### Требование
Используем require (требование). require делает так, что функция выдает ошибку и прекращает выполнение. если одно из условий не верно: 

```javascript
function sayHiToVitalik(string _name) public returns (string) {
  // Сравнивает, если _имя равно "Vitalik". Выдает ошибку и закрывается, если не верно.
  // (Примечание: в Solidity нет родного сравнивателя строк, поэтому
  // мы сравниваем их keccak256-хэши, чтобы увидеть, равны они или нет
  require(keccak256(_name) == keccak256("Vitalik"));
  // Если верно, то переходим к выполнению функции:
  return "Привет!";
}
```

### Отправитель

Теперь, когда у нас есть карта соответсвий для отслеживания владельцев зомби, надо обновить метод _createZombie.

Для этого нам понадобится msg.sender (отправитель).

**В Solidity существуют определенные глобальные переменные, доступные всем функциям. Одной из них является msg.sender (отправитель), который ссылается на address (адрес) человека или смарт-контракта, вызвавшего текущую функцию.**

    Примечание: В Solidity выполнение функции всегда начинается с внешнего вызова. Контракт в блокчейне ничего не делает, пока кто-то не вызовет одну из его функций. Поэтому всегда будет нужен msg.sender.

Пример использования msg.sender для обновления mapping:

```javascript
mapping (address => uint) favoriteNumber;

function setMyNumber(uint _myNumber) public {
  // Обнови соответсвие `favoriteNumber`, чтобы сохранить `_myNumber` под `msg.sender`
  favoriteNumber[msg.sender] = _myNumber;
  // ^ Синтаксис для сохранения в карте соответствия такой же, как для массива
}

function whatIsMyNumber() public view returns (uint) {
  // Затребуй значение, сохраненное в адресе отправителя 
  // Оно будет равно `0`, если отправитель еще не вызывал `setMyNumber`
  return favoriteNumber[msg.sender];
}
```

### Соответствия

В первом уроке мы рассмотрели структуры и массивы. Соответствия — это еще один способ хранения упорядоченных данных в Solidity.

Определение mapping (соответствий) выглядит как-то так:

// Для финансового приложения мы храним uint, который содержит остаток на счете пользователя: 
mapping (address => uint) public accountBalance;
// Или может использоваться для хранения / поиска имен пользователей на основе userId 
mapping (uint => string) userIdToName;

Соответствия - это, по сути, распределенное хранилище типа «ключ — значение», в котором можно хранить и искать данные. В первом примере ключ — это «адрес», а значение - «uint», а во втором примере ключ - «uint», а значение — «строка». 

### Адреса

Блокчейн Ethereum состоит из аккаунтов (счетов), вроде банковских. На аккаунте находится баланс Эфира (криптовалюты блокчейна Ethereum). Ты можешь отправлять и получать платежи в Эфире на другие счета, также как ты переводишь деньги со своего банковского счета на счета других людей.

У каждого счета есть address (адрес), наподобие номера банковского счета. Это уникальный идентификатор счета, который выглядит так:

0x0cE446255506E92DF41614C46F1d6df9Cc969183

(Этот адрес принадлежит команде Криптозомби. Если тебе нравится игра, можешь послать нам эфир!😉).

Мы изучим самое важное блокчейн-адресов в следующем уроке, сейчас же достаточно знать, что адрес принадлежит определенному человеку (или контракту).

Поэтому мы можем использовать его как уникальный идентификатор принадлежности зомби. Когда пользователь создает нового зомби, взаимодействуя с нашим приложением, мы привязываем право собственности на зомби к адресу Ethereum, который вызвал функцию. 

### web3.js
В Ethereum есть библиотека Javascript под названием Web3.js.

```javascript
// Как осуществляется доступ к контракту:
var abi = /* abi generated by the compiler */
var ZombieFactoryContract = web3.eth.contract(abi)
var contractAddress = /* our contract address on Ethereum after deploying */
var ZombieFactory = ZombieFactoryContract.at(contractAddress)
// `ZombieFactory` получил доступ к открытым функциям и событиям

// «Слушатель» событий принимает введенный текст 
$("#ourButton").click(function(e) {
  var name = $("#nameInput").val()
  // Вызываем функцию контракта `createRandomZombie`:
  ZombieFactory.createRandomZombie(name)
})

// Слушаем событие `NewZombie` и обновляем UI (интерфейс)
var event = ZombieFactory.NewZombie(function(error, result) {
  if (error) return
  generateZombie(result.zombieId, result.name, result.dna)
})

// Возьмем ДНК зомби и обновим изображение 
function generateZombie(id, name, dna) {
  let dnaStr = String(dna)
  // Заполним ячейки нулями, если ДНК получилось меньше 16 знаков 
  while (dnaStr.length < 16)
    dnaStr = "0" + dnaStr

  let zombieDetails = {
    // Первые 2 цифры задают голову. Всего возможно 7 вариантов голов, поэтому % 7
    // Получить цифры от 0 до 6, затем добавить 1, чтобы сделать их от 1 до 7. Так будет 7 вариантов
    // Файлы с именами от "head1.png" до "head7.png" загружаем, исходя из этого номера:
    headChoice: dnaStr.substring(0, 2) % 7 + 1,
    // Вторые 2 цифры задают глаза, 11 вариантов:
    eyeChoice: dnaStr.substring(2, 4) % 11 + 1,
    // 6 вариантов мундиров:
    shirtChoice: dnaStr.substring(4, 6) % 6 + 1,
    // Последние 6 цифр задают цвет. Обновления используют фильтр CSS с углом поворота 360 градусов:
    skinColorChoice: parseInt(dnaStr.substring(6, 8) / 100 * 360),
    eyeColorChoice: parseInt(dnaStr.substring(8, 10) / 100 * 360),
    clothesColorChoice: parseInt(dnaStr.substring(10, 12) / 100 * 360),
    zombieName: name,
    zombieDescription: "A Level 1 CryptoZombie",
  }
  return zombieDetails
}

```
### События
Событие — это способ, которым контракт сообщает внешнему интерфейсу приложения, что в блокчейне произошло некое событие. Интерфейс может «услышать» определенные события и выполнить заданное действие по его наступлении.

Пример:
// Объяви событие
`event IntegersAdded(uint x, uint y, uint result);
function add(uint _x, uint _y) public {
  uint result = _x + _y;
  // Запусти событие, чтобы оповестить приложение о вызове функции:
  IntegersAdded(_x, _y, result);
  return result;
}`

Теперь внешний интерфейс приложения сможет услышать событие. Примерно так будет выглядеть выполнение javascript:

YourContract.IntegersAdded(function(error, result) {
  // Воспользуйся результатом
})

### Random и преобразование
В Ethereum есть встроенная хэш-функция keccak256 (произносится как «кечак»), разновидность SHA3. Хеш-функция обычно преображает входную строку в случайное 256-битное шестнадцатеричное число. Небольшое изменение в строке приведет к сильному изменению хэша.

Эта функция полезна для выполнения многих задач в Ethereum, но сейчас мы используем ее для обычной генерации псевдослучайных чисел.

Пример:

//6e91ec6b618bb462a4a6ee5aa2cb0e9cf30f7a052bb467b0ba58b8748c00d2e5
keccak256("aaaab");
//b1f078126895a1424524de5321b339ab00408010b7cf0e6ed451514981e58aa9
keccak256("aaaac");
Как видишь, функция возвращает абсолютно другое значение, хотя мы изменили всего одну входную букву.
//6e91ec6b618bb462a4a6ee5aa2cb0e9cf30f7a052bb467b0ba58b8748c00d2e5
keccak256(abi.encodePacked("aaaab"));
//b1f078126895a1424524de5321b339ab00408010b7cf0e6ed451514981e58aa9
keccak256(abi.encodePacked("aaaac"));

Примечание: в блокчейне остро стоит проблема генерации безопасных случайных чисел. Приведенный нами метод небезопасен, но для текущей задачи годится, поскольку безопасность не входит в приоритетные задачи ДНК зомби.

Преобразование типов данных
Периодически типы данных надо конвертировать. Смотри пример:

uint8 a = 5;
uint b = 6;
// Выдаст ошибку, потому что a * b возвращает uint, а не uint8:
uint8 c = a * b; 
// Чтобы код работал, нужно преобразовать b в uint8:
uint8 c = a * uint8(b); 
В примере выше a * b возвращал uint, но мы попытались сохранить его как uint8, что потенциально могло привести к проблемам. Если преобразовать тип данных в uint8, то код будет работать, а компилятор не выдаст ошибку.

### Модификаторы функций
По умолчанию функции в Solidity public (открытые): любой человек или контракт может вызвать и исполнить функцию твоего контракта
Разумеется, это не всегда желательно, потому что в контракте могут найтись уязвимости для атак. Лучше по умолчанию помечать функции как «закрытые» и потом задавать «открытые» функции, которые не страшно выставить на всеобщее обозрение.
`uint[] numbers;
function _addToArray(uint _number) private {
  numbers.push(_number);
}`

Вернуть значение
Как задать функцию, чтобы она возвращала значение:
`string greeting = "Привет, дружок";
function sayHello() public returns (string) {
  return greeting;
}`
Задание функции в Solidity содержит тип возвращаемого значения (в данном случае string).

Модификаторы функций
Рассмотренная выше функция не модифицирует свое состояние — не изменяет значения и не переписывает что-либо.

Поэтому в данном случае мы можем задать функцию просмотр – просмотр данных без их изменения:
`function sayHello() public view returns (string) {
Еще в Solidity есть чистые функции — ты не получишь доступ к данным в приложении. Рассмотрим пример:

function _multiply(uint a, uint b) private pure returns (uint) {
  return a * b;
}`
Функция даже не читает состояние приложения - она возвращает значение, которое зависит только от параметров самой функции. В этом случае мы задаем функцию как pure.

Примечание: не всегда легко вспомнить, когда задать «чистую» функцию или «просмотр». К счастью, компилятор Solidity исправно выдает предупреждения, что нужно использовать тот или иной модификатор.

**Переменные состояния** записываются в хранилище контракта. Это означает, что они сохраняются в блокчейне Ethereum, как в базе данных.

Пример:
contract Example {
  // Контракт навсегда сохранен в блокчейне 
  uint myUnsignedInteger = 100;
}

> Примечание: в Solidity uint используют как синоним для uint256, 256-битного целого числа без знака. Можно задать uint с меньшим количество
> битов — uint8, uint16, uint32 и.т.д. Но обычно используют просто uint, кроме особенных случаев, о которых мы поговорим далее.

Математика в Solidity довольна проста. Операции точно такие же, как в большинстве языков программирования:

Сложение: x + y
Вычитание: x - y,
Умножение: x * y
Деление: x / y
Модуль и остаток от деления: x % y (например, 13 % 5 будет равно 3, если разделить 13 на 5, в остатке 3)
Solidity поддерживает экспоненциальные операции exponential operator — возведение в степень (например "x в степени y", x^y):

uint x = 5 ** 2; // 5 в квадрате = 25

### Структуры 

struct Person {
  uint age;
  string name;
}

С помощью структур ты создашь более сложные типы данных с несколькими свойствами.

### Массивы

Если нужен список из похожих элементов, подойдет массив. В Solidity есть два типа массивов: фиксированный и динамический:

// Массив фиксированной длины из 2 элементов:
uint[2] fixedArray;
// Другой фиксированный массив из 5 строк:
string[5] stringArray;
// Динамический массив не ограничен по размеру и может увеличиваться:
uint[] dynamicArray;

Ты можешь создать массив из структур. Возьми структуру Person из предыдущей части:
Person[] people; // Динамический массив позволяет добавлять в него данные

Ты не забыл, что переменные состояния сохраняются в блокчейне навсегда? Создание динамического массива из подобных структур полезно 
для хранения структурированных данных внутри контракта, как в базе данных.

### Открытые массивы
Можно задать массив как public (открытый), и Solidity автоматически создаст для него геттер (способ получения). Синтаксис:

Person[] public people;
В этом случае другие контракты смогут читать этот массив (но не писать в него). Это образец хранения открытых данных в контракте.

### Функции

Примечание: обычно (но не обязательно) имена переменных в параметрах функций записывают со знаком подчеркивания в начале,
 чтобы было проще отличить их от глобальных переменных. В наших урокам мы тоже будем пользоваться этим обычаем.

 ### Массивы

 uint[] numbers;
numbers.push(5);
numbers.push(10);
numbers.push(15);
// Числа равны [5, 10, 15]

### ERC721: Transfer Logic

Great, we've fixed the conflict!

Now we're going to continue our ERC721 implementation by looking at transfering ownership from one person to another.

Note that the ERC721 spec has 2 different ways to transfer tokens:

function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

and

function approve(address _approved, uint256 _tokenId) external payable;

function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    The first way is the token's owner calls transferFrom with his address
    as the _from parameter, the address he wants to transfer to as the _to
    parameter, and the _tokenId of the token he wants to transfer.

    The second way is the token's owner first calls approve with the address
    he wants to transfer to, and the _tokenID . The contract then stores who
    is approved to take a token, usually in a mapping (uint256 => address). Then,
    when the owner or the approved address calls transferFrom, the contract checks
    if that msg.sender is the owner or is approved by the owner to take the token, 
    and if so it transfers the token to him.

Notice that both methods contain the same transfer logic. In one case the sender of the token calls the transferFrom function; in the other the owner or the approved receiver of the token calls it.

So it makes sense for us to abstract this logic into its own private function, _transfer, which is then called by transferFrom.

### ERC721 Standard, Multiple Inheritance

Let's take a look at the ERC721 standard:

```javascript
contract ERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

  function balanceOf(address _owner) external view returns (uint256);
  function ownerOf(uint256 _tokenId) external view returns (address);
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
  function approve(address _approved, uint256 _tokenId) external payable;
}
```

This is the list of methods we'll need to implement, which we'll be doing over the coming chapters in pieces.

It looks like a lot, but don't get overwhelmed! We're here to walk you through it.
Implementing a token contract

When implementing a token contract, the first thing we do is copy the interface to its own Solidity file and import it, import "./erc721.sol";. Then we have our contract inherit from it, and we override each method with a function definition.

But wait — ZombieOwnership is already inheriting from ZombieAttack — how can it also inherit from ERC721?

Luckily in Solidity, your contract can inherit from multiple contracts as follows:

contract SatoshiNakamoto is NickSzabo, HalFinney {
  // Omg, the secrets of the universe revealed!
}

As you can see, when using multiple inheritance, you just separate the multiple contracts you're inheriting from with a comma, ,. In this case, our contract is inheriting from NickSzabo and HalFinney.

### Preventing Overflows

Congratulations, that completes our ERC721 and ERC721x implementation!

That wasn't so tough, was it? A lot of this Ethereum stuff sounds really complicated when you hear people talking about it, so the best way to understand it is to actually go through an implementation of it yourself.

Keep in mind that this is only a minimal implementation. There are extra features we may want to add to our implementation, such as some extra checks to make sure users don't accidentally transfer their zombies to address 0 (which is called "burning" a token — basically it's sent to an address that no one has the private key of, essentially making it unrecoverable). Or to put some basic auction logic in the DApp itself. (Can you think of some ways we could implement that?)

But we wanted to keep this lesson manageable, so we went with the most basic implementation. If you want to see an example of a more in-depth implementation, you can take a look at the OpenZeppelin ERC721 contract after this tutorial.
Contract security enhancements: Overflows and Underflows

We're going to look at one major security feature you should be aware of when writing smart contracts: Preventing overflows and underflows.

What's an overflow?

Let's say we have a uint8, which can only have 8 bits. That means the largest number we can store is binary 11111111 (or in decimal, 2^8 - 1 = 255).

Take a look at the following code. What is number equal to at the end?

```javascript
uint8 number = 255;
number++;
```

In this case, we've caused it to overflow — so number is counterintuitively now equal to 0 even though we increased it. (If you add 1 to binary 11111111, it resets back to 00000000, like a clock going from 23:59 to 00:00).

An underflow is similar, where if you subtract 1 from a uint8 that equals 0, it will now equal 255 (because uints are unsigned, and cannot be negative).

While we're not using uint8 here, and it seems unlikely that a uint256 will overflow when incrementing by 1 each time (2^256 is a really big number), it's still good to put protections in our contract so that our DApp never has unexpected behavior in the future.
Using SafeMath

To prevent this, OpenZeppelin has created a library called SafeMath that prevents these issues by default.

But before we get into that... What's a library?

A library is a special type of contract in Solidity. One of the things it is useful for is to attach functions to native data types.

For example, with the SafeMath library, we'll use the syntax using SafeMath for uint256. The SafeMath library has 4 functions — add, sub, mul, and div. And now we can access these functions from uint256 as follows:

```javascript
using SafeMath for uint256;

uint256 a = 5;
uint256 b = a.add(3); // 5 + 3 = 8
uint256 c = a.mul(2); // 5 * 2 = 10
```

### SafeMath Part 2

Let's take a look at the code behind SafeMath:

```javascript
library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
```

First we have the library keyword — libraries are similar to contracts but with a few differences. For our purposes, libraries allow us to use the using keyword, which automatically tacks on all of the library's methods to another data type:

```javascript
using SafeMath for uint;
// now we can use these methods on any uint
uint test = 2;
test = test.mul(3); // test now equals 6
test = test.add(5); // test now equals 11
```

Note that the mul and add functions each require 2 arguments, but when we declare using SafeMath for uint, the uint we call the function on (test) is automatically passed in as the first argument.

Let's look at the code behind add to see what SafeMath does:

```javascript
function add(uint256 a, uint256 b) internal pure returns (uint256) {
  uint256 c = a + b;
  assert(c >= a);
  return c;
}
```

Basically add just adds 2 uints like +, but it also contains an assert statement to make sure the sum is greater than a. This protects us from overflows.

assert is similar to require, where it will throw an error if false. The difference between assert and require is that require will refund the user the rest of their gas when a function fails, whereas assert will not. So most of the time you want to use require in your code; assert is typically used when something has gone horribly wrong with the code (like a uint overflow).

So, simply put, SafeMath's add, sub, mul, and div are functions that do the basic 4 math operations, but throw an error if an overflow or underflow occurs.
Using SafeMath in our code.

To prevent overflows and underflows, we can look for places in our code where we use +, -, *, or /, and replace them with add, sub, mul, div.

Ex. Instead of doing:

myUint++;

We would do:

```javascript
myUint = myUint.add(1);
```

### Comment

The standard in the Solidity community is to use a format called natspec, which looks like this:

```javascript
/// @title A contract for basic math operations
/// @author H4XF13LD MORRIS 💯💯😎💯💯
/// @notice For now, this contract just adds a multiply function
contract Math {
  /// @notice Multiplies 2 numbers together
  /// @param x the first uint.
  /// @param y the second uint.
  /// @return z the product of (x * y)
  /// @dev This function does not currently check for overflows
  function multiply(uint x, uint y) returns (uint z) {
    // This is just a normal comment, and won't get picked up by natspec
    z = x * y;
  }
}
```
@title and @author are straightforward.

@notice explains to a user what the contract / function does. @dev is for explaining extra details to developers.

@param and @return are for describing what each parameter and return value of a function are for.

Note that you don't always have to use all of these tags for every function — all tags are optional. But at the very least, leave a @dev note explaining what each function does.

### Intro to Web3.js

By completing Lesson 5, our zombie DApp is now complete. Now we're going to create a basic web page where your users can interact with it.

To do this, we're going to use a JavaScript library from the Ethereum Foundation called Web3.js.
What is Web3.js?

Remember, the Ethereum network is made up of nodes, with each containing a copy of the blockchain. When you want to call a function on a smart contract, you need to query one of these nodes and tell it:

    The address of the smart contract
    The function you want to call, and
    The variables you want to pass to that function.

Ethereum nodes only speak a language called JSON-RPC, which isn't very human-readable. A query to tell the node you want to call a function on a contract looks something like this:

```javascript
// Yeah... Good luck writing all your function calls this way!
// Scroll right ==>
{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"0xb60e8dd61c5d32be8058bb8eb970870f07233155","to":"0xd46e8dd67c5d32be8058bb8eb970870f07244567","gas":"0x76c0","gasPrice":"0x9184e72a000","value":"0x9184e72a","data":"0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"}],"id":1}
```
Luckily, Web3.js hides these nasty queries below the surface, so you only need to interact with a convenient and easily readable JavaScript interface.

Instead of needing to construct the above query, calling a function in your code will look something like this:

```javascript
CryptoZombies.methods.createRandomZombie("Vitalik Nakamoto 🤔")
  .send({ from: "0xb60e8dd61c5d32be8058bb8eb970870f07233155", gas: "3000000" })
```
We'll explain the syntax in detail over the next few chapters, but first let's get your project set up with Web3.js.
Getting started

Depending on your project's workflow, you can add Web3.js to your project using most package tools:

```javascript
// Using NPM
npm install web3

// Using Yarn
yarn add web3

// Using Bower
bower install web3
```
// ...etc.

Or you can simply download the minified .js file from github and include it in your project:
```javascript
<script language="javascript" type="text/javascript" src="web3.min.js"></script>
```
Since we don't want to make too many assumptions about your development environment and what package manager you use, for this tutorial we're going to simply include Web3 in our project using a script tag as above.

### Web3 Providers

Great! Now that we have Web3.js in our project, let's get it initialized and talking to the blockchain.

The first thing we need is a Web3 Provider.

Remember, Ethereum is made up of nodes that all share a copy of the same data. Setting a Web3 Provider in Web3.js tells our code which node we should be talking to handle our reads and writes. It's kind of like setting the URL of the remote web server for your API calls in a traditional web app.

You could host your own Ethereum node as a provider. However, there's a third-party service that makes your life easier so you don't need to maintain your own Ethereum node in order to provide a DApp for your users — Infura.
Infura

Infura is a service that maintains a set of Ethereum nodes with a caching layer for fast reads, which you can access for free through their API. Using Infura as a provider, you can reliably send and receive messages to/from the Ethereum blockchain without needing to set up and maintain your own node.

You can set up Web3 to use Infura as your web3 provider as follows:

var web3 = new Web3(new Web3.providers.WebsocketProvider("wss://mainnet.infura.io/ws"));

However, since our DApp is going to be used by many users — and these users are going to WRITE to the blockchain and not just read from it — we'll need a way for these users to sign transactions with their private key.

    Note: Ethereum (and blockchains in general) use a public / private key pair to digitally
    sign transactions. Think of it like an extremely secure password for a digital signature.
    That way if I change some data on the blockchain, I can prove via my public key that I
    was the one who signed it — but since no one knows my private key, no one can forge a
    transaction for me.

Cryptography is complicated, so unless you're a security expert and you really know what you're doing, it's probably not a good idea to try to manage users' private keys yourself in our app's front-end.

But luckily you don't need to — there are already services that handle this for you. The most popular of these is Metamask.
Metamask

Metamask is a browser extension for Chrome and Firefox that lets users securely manage their Ethereum accounts and private keys, and use these accounts to interact with websites that are using Web3.js. (If you haven't used it before, you'll definitely want to go and install it — then your browser is Web3 enabled, and you can now interact with any website that communicates with the Ethereum blockchain!).

And as a developer, if you want users to interact with your DApp through a website in their web browser (like we're doing with our CryptoZombies game), you'll definitely want to make it Metamask-compatible.

    Note: Metamask uses Infura's servers under the hood as a web3 provider, just like we 
    did above — but it also gives the user the option to choose their own web3 provider. 
    So by using Metamask's web3 provider, you're giving the user a choice, and it's one 
    less thing you have to worry about in your app.

Using Metamask's web3 provider

Metamask injects their web3 provider into the browser in the global JavaScript object web3. So your app can check to see if web3 exists, and if it does use web3.currentProvider as its provider.

Here's some template code provided by Metamask for how we can detect to see if the user has Metamask installed, and if not tell them they'll need to install it to use our app:

```javascript
window.addEventListener('load', function() {

  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // Use Mist/MetaMask's provider
    web3js = new Web3(web3.currentProvider);
  } else {
    // Handle the case where the user doesn't have web3. Probably
    // show them a message telling them to install Metamask in
    // order to use our app.
  }

  // Now you can start your app & access web3js freely:
  startApp()
})
```
You can use this boilerplate code in all the apps you create in order to require users to have Metamask to use your DApp.

    Note: There are other private key management programs your users might be using besides 
    MetaMask, such as the web browser Mist. However, they all implement a common pattern 
    of injecting the variable web3, so the method we describe here for detecting the 
    user's web3 provider will work for these as well.

### Contract Address

After you finish writing your smart contract, you will compile it and deploy it to Ethereum. We're going to cover deployment in the next lesson, but since that's quite a different process from writing code, we've decided to go out of order and cover Web3.js first.

After you deploy your contract, it gets a fixed address on Ethereum where it will live forever. If you recall from Lesson 2, the address of the CryptoKitties contract on Ethereum mainnet is 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d.

You'll need to copy this address after deploying in order to talk to your smart contract.
Contract ABI

The other thing Web3.js will need to talk to your contract is its ABI.

ABI stands for Application Binary Interface. Basically it's a representation of your contracts' methods in JSON format that tells Web3.js how to format function calls in a way your contract will understand.

When you compile your contract to deploy to Ethereum (which we'll cover in Lesson 7), the Solidity compiler will give you the ABI, so you'll need to copy and save this in addition to the contract address.

Since we haven't covered deployment yet, for this lesson we've compiled the ABI for you and put it in a file named cryptozombies_abi.js, stored in variable called cryptoZombiesABI.

If we include cryptozombies_abi.js in our project, we'll be able to access the CryptoZombies ABI using that variable.
Instantiating a Web3.js Contract

Once you have your contract's address and ABI, you can instantiate it in Web3 as follows:

```javascript
// Instantiate myContract
var myContract = new web3js.eth.Contract(myABI, myContractAddress);
```

### Calling Contract Functions

Our contract is all set up! Now we can use Web3.js to talk to it.

Web3.js has two methods we will use to call functions on our contract: call and send.
Call

call is used for view and pure functions. It only runs on the local node, and won't create a transaction on the blockchain.

    Review: view and pure functions are read-only and don't change state on the blockchain. 
    They also don't cost any gas, and the user won't be prompted to sign a transaction with MetaMask.

Using Web3.js, you would call a function named myMethod with the parameter 123 as follows:

```javascript
myContract.methods.myMethod(123).call()
```

Send

send will create a transaction and change data on the blockchain. You'll need to use send for any functions that aren't view or pure.

    Note: sending a transaction will require the user to pay gas, and will pop up their 
    Metamask to prompt them to sign a transaction. When we use Metamask as our web3 
    provider, this all happens automatically when we call send(), and we don't need 
    to do anything special in our code. Pretty cool!

Using Web3.js, you would send a transaction calling a function named myMethod with the parameter 123 as follows:
```javascript
myContract.methods.myMethod(123).send()
```
The syntax is almost identical to call().

### Getting Zombie Data

Now let's look at a real example of using call to access data on our contract.

Recall that we made our array of zombies public:

Zombie[] public zombies;

In Solidity, when you declare a variable public, it automatically creates a public "getter" function with the same name. So if you wanted to look up the zombie with id 15, you would call it as if it were a function: zombies(15).

Here's how we would write a JavaScript function in our front-end that would take a zombie id, query our contract for that zombie, and return the result:

    Note: All the code examples we're using in this lesson are using version 1.0 of Web3.js, 
    which uses promises instead of callbacks. Many other tutorials you'll see online are 
    using an older version of Web3.js. The syntax changed a lot with version 1.0, so if 
    you're copying code from other tutorials, make sure they're using the same version as you!

```javascript
function getZombieDetails(id) {
  return cryptoZombies.methods.zombies(id).call()
}

// Call the function and do something with the result:
getZombieDetails(15)
.then(function(result) {
  console.log("Zombie 15: " + JSON.stringify(result));
});
```

Let's walk through what's happening here.

cryptoZombies.methods.zombies(id).call() will communicate with the Web3 provider node and tell it to return the zombie with index id from Zombie[] public zombies on our contract.

Note that this is asynchronous, like an API call to an external server. So Web3 returns a promise here. (If you're not familiar with JavaScript promises... Time to do some additional homework before continuing!)

Once the promise resolves (which means we got an answer back from the web3 provider), our example code continues with the then statement, which logs result to the console.

result will be a javascript object that looks like this:
```javascript
{
  "name": "H4XF13LD MORRIS'S COOLER OLDER BROTHER",
  "dna": "1337133713371337",
  "level": "9999",
  "readyTime": "1522498671",
  "winCount": "999999999",
  "lossCount": "0" // Obviously.
}
```
We could then have some front-end logic to parse this object and display it in a meaningful way on the front-end.

### Metamask & Accounts

Awesome! You've successfully written front-end code to interact with your first smart contract.

Now let's put some pieces together — let's say we want our app's homepage to display a user's entire zombie army.

Obviously we'd first need to use our function getZombiesByOwner(owner) to look up all the IDs of zombies the current user owns.

But our Solidity contract is expecting owner to be a Solidity address. How can we know the address of the user using our app?
Getting the user's account in MetaMask

MetaMask allows the user to manage multiple accounts in their extension.

We can see which account is currently active on the injected web3 variable via:
```javascript
var userAccount = web3.eth.accounts[0]
```
Because the user can switch the active account at any time in MetaMask, our app needs to monitor this variable to see if it has changed and update the UI accordingly. For example, if the user's homepage displays their zombie army, when they change their account in MetaMask, we'll want to update the page to show the zombie army for the new account they've selected.

We can do that with a setInterval loop as follows:

```javascript
var accountInterval = setInterval(function() {
  // Check if account has changed
  if (web3.eth.accounts[0] !== userAccount) {
    userAccount = web3.eth.accounts[0];
    // Call some function to update the UI with the new account
    updateInterface();
  }
}, 100);
```
What this does is check every 100 milliseconds to see if userAccount is still equal web3.eth.accounts[0] (i.e. does the user still have that account active). If not, it reassigns userAccount to the currently active account, and calls a function to update the display.

### Getting the user's account in MetaMask

MetaMask allows the user to manage multiple accounts in their extension.

We can see which account is currently active on the injected web3 variable via:
```javascript
var userAccount = web3.eth.accounts[0]
```
Because the user can switch the active account at any time in MetaMask, our app needs to monitor this variable to see if it has changed and update the UI accordingly. For example, if the user's homepage displays their zombie army, when they change their account in MetaMask, we'll want to update the page to show the zombie army for the new account they've selected.

We can do that with a setInterval loop as follows:

```javascript
var accountInterval = setInterval(function() {
  // Check if account has changed
  if (web3.eth.accounts[0] !== userAccount) {
    userAccount = web3.eth.accounts[0];
    // Call some function to update the UI with the new account
    updateInterface();
  }
}, 100);
```
What this does is check every 100 milliseconds to see if userAccount is still equal web3.eth.accounts[0] (i.e. does the user still have that account active). If not, it reassigns userAccount to the currently active account, and calls a function to update the display.

### Sending Transactions

Awesome! Now our UI will detect the user's metamask account, and automatically display their zombie army on the homepage.

Now let's look at using send functions to change data on our smart contract.

There are a few major differences from call functions:

    sending a transaction requires a from address of who's calling the function (which becomes msg.sender in your Solidity code). We'll want this to be the user of our DApp, so MetaMask will pop up to prompt them to sign the transaction.

    sending a transaction costs gas

    There will be a significant delay from when the user sends a transaction and when that transaction actually takes effect on the blockchain. This is because we have to wait for the transaction to be included in a block, and the block time for Ethereum is on average 15 seconds. If there are a lot of pending transactions on Ethereum or if the user sends too low of a gas price, our transaction may have to wait several blocks to get included, and this could take minutes.

    Thus we'll need logic in our app to handle the asynchronous nature of this code.

Creating zombies

Let's look at an example with the first function in our contract a new user will call: createRandomZombie.

As a review, here is the Solidity code in our contract:

```javascript
function createRandomZombie(string _name) public {
  require(ownerZombieCount[msg.sender] == 0);
  uint randDna = _generateRandomDna(_name);
  randDna = randDna - randDna % 100;
  _createZombie(_name, randDna);
}
```

Here's an example of how we could call this function in Web3.js using MetaMask:

```javascript
function createRandomZombie(name) {
  // This is going to take a while, so update the UI to let the user know
  // the transaction has been sent
  $("#txStatus").text("Creating new zombie on the blockchain. This may take a while...");
  // Send the tx to our contract:
  return cryptoZombies.methods.createRandomZombie(name)
  .send({ from: userAccount })
  .on("receipt", function(receipt) {
    $("#txStatus").text("Successfully created " + name + "!");
    // Transaction was accepted into the blockchain, let's redraw the UI
    getZombiesByOwner(userAccount).then(displayZombies);
  })
  .on("error", function(error) {
    // Do something to alert the user their transaction has failed
    $("#txStatus").text(error);
  });
}
```
Our function sends a transaction to our Web3 provider, and chains some event listeners:

    receipt will fire when the transaction is included into a block on Ethereum, which 
    means our zombie has been created and saved on our contract
    error will fire if there's an issue that prevented the transaction from being included 
    in a block, such as the user not sending enough gas. We'll want to inform the user in 
    our UI that the transaction didn't go through so they can try again.

    Note: You can optionally specify gas and gasPrice when you call send, e.g. 
    .send({ from: userAccount, gas: 3000000 }). If you don't specify this, 
    MetaMask will let the user choose these values.

### Calling Payable Functions

The logic for attack, changeName, and changeDna will be extremely similar, so they're trivial to implement and we won't spend time coding them in this lesson.

    In fact, there's already a lot of repetitive logic in each of these function calls, 
    so it would probably make sense to refactor and put the common code in its own 
    function. (And use a templating system for the txStatus messages — already we're 
    seeing how much cleaner things would be with a framework like Vue.js!)

Let's look at another type of function that requires special treatment in Web3.js — payable functions.
Level Up!

Recall in ZombieHelper, we added a payable function where the user can level up:

```javascript
function levelUp(uint _zombieId) external payable {
  require(msg.value == levelUpFee);
  zombies[_zombieId].level++;
}
```
The way to send Ether along with a function is simple, with one caveat: we need to specify how much to send in wei, not Ether.
What's a Wei?

A wei is the smallest sub-unit of Ether — there are 10^18 wei in one ether.

That's a lot of zeroes to count — but luckily Web3.js has a conversion utility that does this for us.

```javascript
// This will convert 1 ETH to Wei
web3js.utils.toWei("1");
```
In our DApp, we set levelUpFee = 0.001 ether, so when we call our levelUp function, we can make the user send 0.001 Ether along with it using the following code:
```javascript
cryptoZombies.methods.levelUp(zombieId)
.send({ from: userAccount, value: web3js.utils.toWei("0.001", "ether") })
```

### Subscribing to Events

As you can see, interacting with your contract via Web3.js is pretty straightforward — once you have your environment set up, calling functions and sending transactions is not all that different from a normal web API.

There's one more aspect we want to cover — subscribing to events from your contract.
Listening for New Zombies

If you recall from zombiefactory.sol, we had an event called NewZombie that we fired every time a new zombie was created:

event NewZombie(uint zombieId, string name, uint dna);

In Web3.js, you can subscribe to an event so your web3 provider triggers some logic in your code every time it fires:
```javascript
cryptoZombies.events.NewZombie()
.on("data", function(event) {
  let zombie = event.returnValues;
  // We can access this event's 3 return values on the `event.returnValues` object:
  console.log("A new zombie was born!", zombie.zombieId, zombie.name, zombie.dna);
}).on("error", console.error);
```
Note that this would trigger an alert every time ANY zombie was created in our DApp — not just for the current user. What if we only wanted alerts for the current user?
Using indexed

In order to filter events and only listen for changes related to the current user, our Solidity contract would have to use the indexed keyword, like we did in the Transfer event of our ERC721 implementation:
```javascript
event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
```
In this case, because _from and _to are indexed, that means we can filter for them in our event listener in our front end:
```javascript
// Use `filter` to only fire this code when `_to` equals `userAccount`
cryptoZombies.events.Transfer({ filter: { _to: userAccount } })
.on("data", function(event) {
  let data = event.returnValues;
  // The current user just received a zombie!
  // Do something here to update the UI to show it
}).on("error", console.error);
```
As you can see, using events and indexed fields can be quite a useful practice for listening to changes to your contract and reflecting them in your app's front-end.
Querying past events

We can even query past events using getPastEvents, and use the filters fromBlock and toBlock to give Solidity a time range for the event logs ("block" in this case referring to the Ethereum block number):

```javascript
cryptoZombies.getPastEvents("NewZombie", { fromBlock: 0, toBlock: "latest" })
.then(function(events) {
  // `events` is an array of `event` objects that we can iterate, like we did above
  // This code will get us a list of every zombie that was ever created
});
```

Because you can use this method to query the event logs since the beginning of time, this presents an interesting use case: Using events as a cheaper form of storage.

If you recall, saving data to the blockchain is one of the most expensive operations in Solidity. But using events is much much cheaper in terms of gas.

The tradeoff here is that events are not readable from inside the smart contract itself. But it's an important use-case to keep in mind if you have some data you want to be historically recorded on the blockchain so you can read it from your app's front-end.

For example, we could use this as a historical record of zombie battles — we could create an event for every time one zombie attacks another and who won. The smart contract doesn't need this data to calculate any future outcomes, but it's useful data for users to be able to browse from the app's front-end.

### Chainlink Data Feeds Introduction

Now, let's suppose you're building a DeFi dapp, and want to give your users the ability to withdraw ETH worth a certain amount of USD. To fulfill this request, your smart contract (for simplicity's sake we'll call it the "caller contract" from here onwards) must know how much one Ether is worth.

And here's the thing: a JavaScript application can easily fetch this kind of information, making requests to the Binance public API (or any other service that publicly provides a price feed). But, a smart contract can't directly access data from the outside world.

Now we could build a JavaScript application ourselves, but then we are introducing a centralized point of failure! We also couldn't just pull from the Binance API, because that would be a centralized point of failure!

So what we want to do, is get our data from both a decentralized oracle network (DON) and decentralized data sources.

Chainlink is a framework for decentralized oracle networks (DONs), and is a way to get data in from multiple sources across multiple oracles. This DON aggregates data in a decentralized manner and places it on the blockchain in a smart contract (often referred to as a "price reference feed" or "data feed") for us to read from. So all we have to do, is read from a contract that the Chainlink network is constantly updating for us!

Using Chainlink Data Feeds is a way to cheaply, more accurately, and with more security gather data from the real world in this decentralized context. Since the data is coming from multiple sources, multiple people can partake in the ecosystem and it becomes even cheaper than running even a centralized oracle. The Chainlink network uses a system called Off-Chain Reporting to reach a consensus on data off-chain, and report the data in a cryptographically proven single transaction back on-chain for users to digest.

You can then make protocols like Synthetix, Aave, and Compound with this!

Chainlink Decentralized Oracle Network

You can see visualizations of some of these DONs here.

We'll go into exactly how these networks tick in later lessons.

So, let's learn how to read from one of these data feeds!

The first thing we want to do, is start our contract and import the Chainlink code.

### Did you know, you can actually import code from outside your contracts? I know it's amazing right! Often times you don't have to have every piece of code directly in your project, you can borrow it from other applications!

We want to import the AggregatorV3Interface from the [Chainlink GitHub repository](https://github.com/smartcontractkit/chainlink). This interface will include all the functions that we need to interact with a Chainlink Data Feed contract, including functions like latestRoundData() which will return all the information we need.

Here is what the full interface looks like:

```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface AggregatorV3Interface {

  function decimals()
    external
    view
    returns (
      uint8
    );

  function description()
    external
    view
    returns (
      string memory
    );

  function version()
    external
    view
    returns (
      uint256
    );

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(
    uint80 _roundId
  )
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}
```
And we can find it in the [GitHub repo for AggregatorV3Interface](https://github.com/smartcontractkit/chainlink/blob/master/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol).

We can either import directly from GitHub, or from [NPM packages](https://www.npmjs.com/package/@chainlink/contracts) to get this contract. The framework you're using (like Truffle, Brownie, Remix, Hardhat) will determine whether or not to use GitHub or NPM packages, but the syntax will be approximately the same!

### AggregatorV3Interface
Great work! Now, to interact with one of data fed contracts, since we already have the interface, all we need is the address. We can use the on-chain [Feeds Registry](https://docs.chain.link/docs/feed-registry/) which is an on-chain contract that keeps track of where all these feeds are, or we can just choose a contract address of our choosing by browsing all the [contract addresses](https://docs.chain.link/docs/reference-contracts/).

Since we are trying to get the price of ETH in terms of USD, we need to pick the data feed that has this information.

IMPORTANT: Each network will have a different address for each piece of data you want. The address of the ETH/USD contract will be different on Mainnet Ethereum from Mainnet Polygon, from a Rinkeby testnet, etc.

We will use the data feed of Rinkeby for this demo, you can find all the addresses in the [Rinkeby Data Feeds Documentation](https://docs.chain.link/docs/ethereum-addresses/#Rinkeby%20Testnet). We are using Rinkeby, because, in later courses, you'll learn how to deploy to the Rinkeby test net!

### Working with Tuples
Now we must retrieve the latest ETH price by calling the latestRoundData function of the priceFeed contract. This function has all the information we are looking for, plus some:

roundId: The round ID. Each price update gets a unique round ID.
answer: The current price.
startedAt: Timestamp of when the round started.
updatedAt: Timestamp of when the round was updated.
answeredInRound: The round ID of the round in which the answer was computed.
Tuples
But before we do call this function, let me ask you something: do you know what tuples are?

If you recall the answer from our previous lessons, feel free to skip this section. If not, just follow along and we'll explain.

A tuple is a way in Solidity to create a syntactic grouping of expressions.

If a function returns multiple variables, such as the latestRoundData function, we consider the return type to be a tuple of many types.

```javascript
function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
```
In order for us to assign variables to each return variable, we use the tuple syntax by grouping a list of variables in parentheses:
```javascript
 (uint80 roundId, int answer, uint startedAt, uint updatedAt, uint80 answeredInRound) = priceFeed.latestRoundData();
```
We can also rename the variables to anything that we please. For example, let's rename answer to price:
```javascript
 (uint80 roundId, int price, uint startedAt, uint updatedAt, uint80 answeredInRound) = priceFeed.latestRoundData();
```
Additionally, if there are variables that we are not going to use, it's often best practice to leave them as blanks, like so:
```javascript
 (,int price,,,) = priceFeed.latestRoundData();
```
This way, we can easily see what variables are important to us, and not declare anything extra.

### Chainlink Data Feeds References
Awesome! You now know how to get data from a decentralized oracle network (DON) into your smart contracts. Once you finish this lesson, you can follow along in the [Chainlink documentation](https://docs.chain.link/docs/beginners-tutorial/) basics tutorial to learn how to deploy one of these to a real testnet!

We will learn later how these price feeds work under the hood, and how you can setup a DON to gather any data that you're looking for. However, often developers choose to work with some of these "out-of-the-box" oracle services, since they are much easier and require almost no time to setup. We'll keep learning more of these "ready-to-go out-of-the-box" services.

There is so much more to Chainlink Oracles than what we've just covered here, and we are going to go over how this all works, as well as some other incredibly powerful features.

However, we want to give you a heads up on some tools that bring your developing to the next level. Soon, you'll learn how to work with Truffle, Hardhat, Front Ends, DeFi, and more that bring Chainlink Data Feeds to life even more. Once you learn some of those concepts, you can come back to the Truffle Starter Kit, Hardhat Starter Kit, and Brownie Starter Kit (Chainlink Mix), to build sophisticated smart contract applications in development suites.

But until we come to those, let's keep learning about some of the amazing features Chainlink has to offer us!

Select the Next button to move to the next chapter.
[Truffle Starter Kit](https://github.com/smartcontractkit/truffle-starter-kit)
[Hardhat STarter Kit](https://github.com/smartcontractkit/hardhat-starter-kit)
[Brownie Starter Kit(Chainlink Mix)](https://github.com/smartcontractkit/chainlink-mix)

### Chainlink VRF Introduction
The pseudo-random DNA

At this point in our contracts, we have been working with pseudo-randomness. Our keccak256 function was a great way to get started learning about how to create smart contracts. However, as we mentioned earlier, you can run into some major issues when creating smart contracts that rely on pseudo-randomness. Everything that is part of the on-chain mechanism is deterministic by design, including our hashing function.

When we tried to get random DNA from a string, we know that the DNA we are going to get is going to be the same every single time. This means, that our randomness creation function isn't actually random! We also can't rely on someone being honest when they input a "string" into this function.

uint(keccak256(abi.encodePacked(_str)))

So how can we fix this? Well, a naive approach is to use globally available variables like msg.sender, block.difficulty, and block.timestamp. You might see references that try to get random numbers like so:

uint(keccak256(abi.encodePacked(msg.sender, block.difficulty, block.timestamp)));

In this example, the developers try to mix up all these globally available variables to make it harder to predict the number. However, even these numbers have predictability:

    msg.sender is known by the sender
    block.difficulty is directly influenced by the miners
    block.timestamp is predictable

So now it should be clear that everything inside the blockchain is deterministic and can lead to exploits if we try to use randomness from inside the blockchain. So how can we get randomness from outside the blockchain? You guessed it, with a Chainlink Oracle!

Let's take a look back at our good friend the zombie code, where we gave our zombie some pseudo-random DNA, and let's try to fix it. This time though, we will use the secure randomness of the Chainlink Verifiable Randomness Function (Chainlink VRF).
Chainlink VRF

Chainlink VRF is a way to get randomness from outside the blockchain, but in a proven cryptographic manner. This is important because we always want our logic to be truly incorruptible. Another naive attempt at getting randomness outside the blockchain would be to use an off-chain API call to a service that returns a random number. But if that services goes down, is bribed, hacked, or otherwise, you could potentially be getting back a corrupt random number. Chainlink VRF includes on-chain verification contracts that cryptographically prove that the random number the contract is getting is really random.

Chainlink VRF (Verifiable Randomness Function)
Basic Request Model

Now, this is where we will be introduced to the basic request model of working with oracles.

The first step is when a smart contract (called the "callee contract") makes a "request" to a Chainlink node which is comprised of a smart contract and the corresponding off-chain node. When it receives the request, the smart contract emits a specific event that the corresponding Chainlink node is subscribed to/looking for. This happens in one transaction.

The Chainlink oracle will then process the request (be it randomness, a data request, etc), and return the data/computation back to the callee contract, or a contract that will in turn send the response to the callee contract. This "middle" contract is often referred to as the "oracle contract". This return process happens in a second separate transaction, so in total the basic request model is a two transaction event, and therefore, will take at the very minimum two blocks to complete.

This two transaction architecture is important, because it means that brute force attacks on randomness or data requests are throttled and impossible to hack without costing the attacker insane fees in gas costs.

To recap, the process is as such:

    Callee contract makes a request in a transaction
        Callee contract or oracle contract emits an event
    Chainlink node (Off-chain) is listening for the event, where the details of the request are logged in the event
    In a second transaction created by the Chainlink node, it returns the data on-chain by calling a function described by the callee contract
    In the case of the Chainlink VRF, a randomness proof is done to ensure the number is truly random

Now, similar to when we make a transaction on Ethereum or any Solidity compatible blockchain, as you know, we have to pay some transaction gas. To work with oracles, we have to pay a little bit of oracle gas, also known as the LINK or Chainlink token. The LINK token is specifically designed to work with oracles and ensure the security of the Chainlink oracle networks. Whenever we make a request following the basic request model, our contracts must be funded with a set amount of LINK, as defined by the specific oracle service that we are using (each service has different oracle gas fees).

Chainlink Basic Oracle Request Model
Why didn't we do this with the data feeds?

Now, the question then becomes, "Why wasn't this done with data feeds?" or "Why didn't we pay oracle gas for the data feeds?", and these are really good questions. With data feeds, an entire group of Chainlink nodes are being requested for data instead of just one Chainlink node (hence, it's a decentralized oracle network), however, only one entity has to kick off the request to the whole network. So we were able to benefit because someone else already created the requests to the oracles for the different kinds of data described in the data feeds. The data feeds are sponsored by a group of projects all making use of data feeds such as Aave, Compound, Synthetix, and more, and the updates to the network are being kicked off programmatically whenever there is a slight price change in the data they are reporting. Working together as a group, we can keep transaction costs down and create this collective good the whole ecosystem can benefit from!

In summary, someone else followed a bit more advanced version of the basic request model for us with the data feeds!
Chainlink VRF Under the Hood

The Chainlink VRF follows this basic request model, with one added benefit; since there is a cryptographic proof on-chain of the randomness of the number from a Chainlink VRF node, we are safe to work with a single Chainlink VRF node! As the technology gets better and better though, even more decentralized versions of the Chainlink VRF are being created, but luckily, we are good to work with this secure method of randomness for our smart contracts.

We aren't going to go deep into the proofs the many researchers have done to ensure the randomness returned by Chainlink VRF nodes, but here is the basically what's happening for this magic to occur.

In brief, a smart contract requests randomness by specifying a hash used to uniquely identify a Chainlink oracle. That hash is used by the Chainlink node with its own secret key to generate a random number, which is then returned to the contract on-chain, along with a cryptographic proof. An on-chain contract (called the VRF Coordinator) takes the random number along with the proof, and is verified using the oracle’s public key. Relying on the widely accepted signature and proof verification capabilities of a blockchain, this enables contracts to consume only randomness that has also been verified by the same on-chain environment running the contract itself.

You can check out the Chainlink VRF contracts to see the exact functions the system is using.

Wow, OK, there is a lot of big brained concepts here! Let's finally dive into learning how to pull a random number into our smart contract. We can get started, by once again pulling the Chainlink VRF contract code from NPM / Github that allows us to interact with a Chainlink VRF node. We are going to inherit the functionality of the VRFConsumerbase contract code into our code to emit events, and define what functions the Chainlink node is going to callback (respond) to.

[Chainlink Verifiable Randomness Function(Chainlink VRF)](https://docs.chain.link/docs/get-a-random-number/)
[basic request modek](https://docs.chain.link/docs/architecture-request-model/)
[LINK or Chainlink token](https://chain.link/)
[Chainlink VRF contracts](https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.6/VRFCoordinator.sol)
[Chainlink NPM / Github](https://github.com/smartcontractkit/chainlink)
[Chainlink Doc](https://docs.chain.link/docs/get-a-random-number/)

### Constructor in a constructor

You got it! The VRFConsumerbase contract includes all the code we need to send a request to a Chainlink oracle, including all the event logging code.

Now, as we said, to interact with a Chainlink node, we need to know a few variables.

    The address of the Chainlink token contract. This is needed so our contract can tell if we have enough LINK tokens to pay for the gas.
    The VRF coordinator contract address. This is needed to verify that the number we get is actually random.
    The Chainlink node keyhash. This is used identify which Chainlink node we want to work with.
    The Chainlink node fee. This represents the fee (gas) the Chainlink will charge us, expressed in LINK tokens.

You can find all these variables in the Chainlink VRF Contract addresses documentation page. Once again, the addresses will be different across networks, but for the scope of this lesson we will again be working with the Rinkeby network.

As said in the last lesson, we are going to inherit the functionality of this VRFConsumerbase. But how do we implement a constructor of an inherited contract? And the answer is that we can have a constructor in a constructor.

Let's take a look at this sample code:

```javascript
import "./Y.sol";
contract X is Y {
    constructor() Y() public{
    }
}
```
To use a constructor of an inherited contract, we just put the constructor declaration as part of our contract's constructor.

We can do the same thing with the VRFConsumerbase contract:
```javascript
constructor() VRFConsumerBase(
    0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
    0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
) public{

}
```

[Chainlink Random Number](https://docs.chain.link/docs/intermediates-tutorial/)

Now, let's circle back to how contract.new works. Basically, every time we call this function, Truffle makes it so that a new contract gets deployed.

On one side, this is helpful because it lets us start each test with a clean sheet.

On the other side, if everybody would create countless contracts the blockchain will become bloated. We want you to hang around, but not your old test contracts!

We would want to prevent this from happening, right?

Happily, the solution is pretty straightforward... our contract should selfdestruct once it's no longer needed.

The way this works is as follows:

    first, we would want to add a new function to the CryptoZombies smart contract like so:
    
    ```javascript
    function kill() public onlyOwner {
       selfdestruct(owner());
    }
    ```

        Note: If you want to learn more about selfdestruct(), you can read the Solidity docs here. The most important thing to bear in mind is that selfdestruct is the only way for code at a certain address to be removed from the blockchain. This makes it a pretty important feature!

    next, somewhat similar to the beforeEach() function explained above, we'll make a function called afterEach():
    ```javascript
    afterEach(async () => {
       await contractInstance.kill();
    });
    ```

    Lastly, Truffle will make sure this function is called after a test gets executed.

And voila, the smart contract removed itself!

### Lestening a event
```javascript
  //The above snippet just listens for an event called EventName. For more complex use cases, you could also specify a filter like so:

  myContract.events.EventName({ filter: { myParam: 1 }}, async (err, event) => {
    if (err) {
      console.error('Error on event', err)
      return
    }
    // Do something
})
```

### Working with Numbers in Ethereum and JavaScript
The Ethereum Virtual Machine doesn't support floating-point numbers, meaning that divisions truncate the decimals. The workaround is to simply multiply the numbers in your front-end by 10**n. The Binance API returns eight decimals numbers and we'll also multiply this by 10**10. Why did we choose 10**10? There's a reason: one ether is 10**18 wei. This way, we'll be sure that no money will be lost.

But there's more to it. The Number type in JavaScript is "double-precision 64-bit binary format IEEE 754 value" which supports only 16 decimals...

Luckily, there's a small library called BN.js that'll help you overcome these issues.

    ☞ For the above reasons, it's recommended that you always use BN.js when dealing with numbers.

Now, the Binance API returns something like 169.87000000.

Let's see how you can convert this to BN.

First, you'll have to get rid of the decimal separator (the dot). Since JavaScript is a dynamically typed language (that's a fancy way of saying that the interpreter analyzes the values of the variables at runtime and, based on the values, it assigns them a type), the easiest way to do this is...

aNumber = aNumber.replace('.', '')

Continuing with this example, converting aNumber to BN would look something like this:

const aNumber = new BN(aNumber, 10)

    Note: The second argument represents the base. Make sure it's always specified.


```javascript```
```solidity```