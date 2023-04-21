## Solidity by Example
## Solidity на примере

### Voting
### Голосование

EN
The following contract is quite complex, but showcases a lot of Solidity’s features. It implements a voting contract. Of course, the main problems of electronic voting is how to assign voting rights to the correct persons and how to prevent manipulation. We will not solve all problems here, but at least we will show how delegated voting can be done so that vote counting is automatic and completely transparent at the same time.

RU
Следующий рассматриваемый нами контракт достаточно сложный, но демонстрирует многие возможности Solidity. В следующем примере  мы реализуем контракт для голосования. Конечно, основная проблема электронного голосования в том, как дать права голоса соответствующим лицам и как предотвратить манипуляции. Мы не решим здесь всех проблем, но, по крайней мере, мы покажем как можно сделать делегированное голосование таким образом, чтобы подсчет голосов был **автоматическим и в то же время полностью прозрачным**.

EN
The idea is to create one contract per ballot, providing a short name for each option. Then the creator of the contract who serves as chairperson will give the right to vote to each address individually.

RU
Идея заключается в том, чтобы создать один контракт на каждый бюллетень, снабдив каждый вариант коротким названием. Затем создатель контракта, выполняющий функцию председателя, передает права голоса каждому адресу в отдельности.

EN
The persons behind the addresses can then choose to either vote themselves or to delegate their vote to a person they trust.

RU
Затем лица, стоящие за адресами, могу выбрать: либо голосовать самим, либо передать/делегировать свой голос лицу, которому они доверяют.

EN
At the end of the voting time, `winningProposal()` will return the proposal with the largest number of votes.

RU
По окончании времени голосования, функция `winningProposal()` вернет предложение с наибольшим количеством голосов.

```javascript
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
/// @title Voting with delegation.
/// @title Голосование с делегированием.
contract Ballot {
    // Здесь объявляется новый сложный тип данных,
    // которрый позже будет использован для переменных.
    // Он будет представлять одного избирателя.
    struct Voter {
        uint weight; // вес накапливается при делегировании полномочий
        bool voted;  // если true, то этот человек уже проголосовал
        address delegate; // лицо, которому делегировали голос
        uint vote;   // индекс предложения за которое проголосовал избиратель
    }

    // Это объявление типа для представления отдельного предложения.
    struct Proposal {
        bytes32 name;  // короткое название (размером дло 32 байт)
        uint voteCount; // количество накопленных голосов
    }

    address public chairperson;

    // Здесь мы объявляем переменную состояния, которая
    // хранит отдельный голос(стуктура `Voter`) для каждого возможного адреса.
    mapping(address => Voter) public voters;

    // Динамически изменяемый массив стурктур `Proposal`.
    // Здесь будут представлены все имеющиеся предложения.
    Proposal[] public proposals;

    /// Создаем один новый бюллетень для выбора одного из предоставленных `proposalNames`. 
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        // Для каждого из предоставленных наименований предложений,
        // создаем один новый объект предложение и добавляем его
        // в конец массива
        for (uint i = 0; i < proposalNames.length; i++) {
            // `Proposal({...})` создает временный
            // Proposal объект и `proposals.puhs(...)`
            // добавляет его в конец `proposals`.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // Даем `voter` право голосовать по этому бюллетеню.
    // Данная функция может быть вызвана только `chairperson`(председателем)
    function giveRightToVote(address voter) external {
        // Если первый аргумент `require` равен false,
        // то выполнение прерывается и все изменения в состоянии
        // и в балансе Эфира будут отменены.
        // Раньше это потребляло весь газ в старых версия EVM,
        // но больше этого не происходит.
        // Часто бывает полезно использовать `require` для проверки того,
        // правильно ли вызвана функция
        // В качестве второго аргумента, вы можете передавать
        // объяснение того, что пошло не так.
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /// Делегируем свой голос избирателю `to`.
    function delegate(address to) external {
        // присваиваем ссылку
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "You have no right to vote");
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");
        
        // Передавайте делегирование до тех пора пока
        // у `to` будет отсутстовать лицо которому он делегирует
        //  или пока не получим ошибку зацикливания.
        // В целом, такие циклы очень рискованы,
        // потому что, если он выполняются слишком долго, им может
        // потребоваться больше газа, чем доступно в блоке.
        // В этом случае, делегирование не будет выполнено,
        // но в других ситуациях, такие циклы могут
        // привести к тому, что контракт полностью "зависнет"
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // Проверяем произошло ли зациклирование в делегировании, что недопустимо.
            require(to != msg.sender, "Found loop in delegation.");
        }

        Voter storage delegate_ = voters[to];

        // Избиратели не могут делегировать полномочия тем аккаунтам, которые не могут голосовать
        require(delegate_.weight >= 1);

        // Поскольку `sender` является ссылкой,
        // это мы изменяем `voters[msg.sender]`.
        sender.voted = true;
        sender.delegate = to;

        if (delegate_.voted) {
            // Если делегат уже проголосовал, 
            // напрямую прибаляем к количеству голосов
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // Если делегат еще не проголосовал,
            // то прибавляем к его весу
            delegate_.weight += sender.weight;
        }
    }

    /// Отдаем свой голос (включая делегированные вам голоса)
    /// предложениею `proposals[proposal].name`.
    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        // Если `proposal` находится вне диапазона масива,
        // то следующая строка кода вызовет ошибку и откатит
        // все изменения
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Вычисляем победившее предложение с учетом
    /// всех предыдущих голосований.
    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    // Вызываем функцию winningProposal() чтобы получить индекс
    // победителя, содержащегося в массиве всех предложений, а затем
    // возвращаем имя победителя
    function winnerName() external view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}
```

EN
### Possible Improvements
Currently, many transactions are needed to assign the rights to vote to all participants. Moreover, if two or more proposals have the same number of votes, winningProposal() is not able to register a tie. Can you think of a way to fix these issues?

RU
### Возможные улучшения
В текущем виде смартконтракта, требуется много транзакций, чтобы назначить право голоса всем участникам. Кроме того, если два или более предложений будут иметь одинаковое количество голосов, `winningProposal()` не сможет зафиксировать ничью. Можете ли вы подумать как решить эту проблему?

EN
### Blind Auction
In this section, we will show how easy it is to create a completely blind auction contract on Ethereum. We will start with an open auction where everyone can see the bids that are made and then extend this contract into a blind auction where it is not possible to see the actual bid until the bidding period ends.

RU
### Аукцион Вслепую / Аукцион "втемную"
В этом разделе, мы покажем, как легко создать контракт аукциона полностью вслепую(?) на Ethereum. Начнем мы с открытого аукциона, где каждый может видеть сделанные ставки, а зетем расширим этот контракт до аукциона вслепую, где невозможно увидеть актуальную ставку до самого окончания периода торгов.

EN
### Simple Open Auction
### Простой Открытый Аукцион

The general idea of the following simple auction contract is that everyone can send their bids during a bidding period. The bids already include sending money / Ether in order to bind the bidders to their bid. If the highest bid is raised, the previous highest bidder gets their money back. After the end of the bidding period, the contract has to be called manually for the beneficiary to receive their money - contracts cannot activate themselves.

RU
Общая идея следующего контракта простого аукциона заключается в том, что каждый может отправлять свои ставки/заявки/предложения (?) в течении периода торгов. Ставки уже включают отправку денег / Эфира для того, чтобы связать участников торгов с их ставкой. Если самая высокая ставка повышается, предыдущий участник самой высокой ставки получает свои деньги обратно. После окончания периода торгов, контракт должен быть вызван вручную, чтобы бенефициар получил свои деньги - контракты не могут запускаться самостоятельно.

```c
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
contract SimpleAuction {
    // Параметры аукциона. Время будет либо
    // абсолютным в формате  `unix timestamp` (т.е. в секундах с 1970-01-01)
    // или временные интервалы в секундах.
    address payable public beneficiary;
    uint public auctionEndTime;

    // Текущее состояние аукциона.
    address public highestBidder; // кто больше заплатит
    uint public highestBid; // самая высокая ставка/предложение

    // Разрешенные отзывы/взвраты предыдущих ставок
    mapping(address => uint) pendingReturns;

    // Устанавливаем в `true` в конце, запрещаются любые изменения.
    // По умолчанию инициализируется `false`.
    bool ended;

    // Events that will be emitted on changes.
    // События, которые будут вызываны при изменениях.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // Далее идут ошибки, описывающие сбои.

    // Комментарии с тройной косой чертой - это так называемые `natspec`
    // комментарии. Они будут выводиться, когда у пользователя
    // запрашивается подтверждение транзакции или
    // когда отображается ошибка.

    /// Аукцион уже законился.
    error AuctionAlreadyEnded();
    /// Уже есть более высокая ил равная ставка
    error BidNotHighEnough(uint highestBid);
    /// Аукцион еще не закончился.
    error AuctionNotYetEnded();
    /// Функция `auctionEnd` уже была взывана.
    error AuctionEndAlreadyCalled();

    /// Создаем простой аукцион с `biddingTime`
    /// где время торгов задается в секундах от имени
    /// адреса бенефициара `beneficiaryAddress`
    constructor(
        uint biddingTime,
        address payable beneficiaryAddress
    ) {
        beneficiary = beneficiaryAddress;
        auctionEndTime = block.timestamp + biddingTime;
    }

    /// Предлагаем цену со значением, отправленным
    /// вместе с транзакцией. `{ value: <number> }`
    /// Стоимость будте возвращена только в том случае, если
    /// аукцион не будет выйгран.
    function bid() external payable {
        // Никаких аргументов не требуется, вся
        // информация уже является частью
        // транзакции. Ключевое слово `payable`
        // требуется для того, чтобы функция
        // имела возможность получать Эфир.

        // Вернет вызов если период торгов закончился.
        if (block.timestamp > auctionEndTime)
            revert AuctionAlreadyEnded();

        // Если ставка не выше актуальной, отправляет
        // деньги обратно 
        // (опертаор `revert` отменяет все изменения 
        // сделанные этой функцией, включая получение денег)
        if (msg.value <= highestBid)
            revert BidNotHighEnough(highestBid);

        if (highestBid != 0) {
            // Отправка обратно денег простым способом
            // `highestBidder.send(highestBid)` представляет собой риск для безопасности
            // потому как это может привести к выполнению ненадежного контракта.
            // Всегда безопаснее позволять получателям,
            // самостоятельно выввести свои деньги.
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    /// Отозван ставку которая была перебита другой более высокой ставкой.
    function withdraw() external returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            // Важно установить это значение равным нулю, потому что получатель
            //(?) может вызывать эту функцию снова (?)as part of the receiving call(?)
            // до того, `send` вернется/завершится.
            pendingReturns[msg.sender] = 0;

            // msg.sender is not of type `address payable` and must be
            // explicitly converted using `payable(msg.sender)` in order
            // use the member function `send()`.
            // Поскольку `msg.sender` не является типом `address payable`, то должен быть
            // явно преобразован с помощью `payable(msg.sender)`, чтобы
            //(?) использовать (?)memeber(?) функцию `send()`.
            if (!payable(msg.sender).send(amount)) {
                // No need to call throw here, just reset the amount owing
                //(?) Сдесь не нужно выбрасывать ошибку через `throw` (?)
                // просто восстанавливаем сумму долга
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    /// Завершаем аукцион и отправляет самую высокую ставку
    /// бенефициару.
    function auctionEnd() external {
        // It is a good guideline to structure functions that interact
        // with other contracts (i.e. they call functions or send Ether)
        // into three phases:
        // 1. checking conditions
        // 2. performing actions (potentially changing conditions)
        // 3. interacting with other contracts
        // If these phases are mixed up, the other contract could call
        // (?) back into the current contract and modify the state or cause
        // effects (ether payout) to be performed multiple times.
        // If functions called internally include interaction with external
        // contracts, they also have to be considered interaction with
        // external contracts.

        // Хорошей практикой является структурирование функций, которые
        // взаимодействую с другими контрактами (т.е. вызывают функции или отправляют Эфир)
        // Выделяются три этапа:
        // 1. проверка условий
        // 2. выполнение действий (потенциально изменяющих условия)
        // 3. взаимодействие с другими контрактами
        // Если эти шаги буду перепутаны, другой контракт может заставить
        // (?)вернуться в текущий контракт и изменить состояние или вызвать
        // эффекты (выплата эфира), которые могут выполняться несколько раз.
        // Если функции, вызываемые внутри контракта, включают взаимодейтсвие с внешними
        // контрактами, они также должны учитывать это при взаимодействии в внешними контрактами.

        // 1. Условия
        if (block.timestamp < auctionEndTime)
            revert AuctionNotYetEnded();
        if (ended)
            revert AuctionEndAlreadyCalled();

        // 2. Эффекты/действия
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Взаимодействие
        beneficiary.transfer(highestBid);
    }
}
```

### Blind Auction

### Аукцион Вслепую

EN
The previous open auction is extended to a blind auction in the following. The advantage of a blind auction is that there is no time pressure towards the end of the bidding period. Creating a blind auction on a transparent computing platform might sound like a contradiction, but cryptography comes to the rescue.

RU
Ранее рассмотренный нами контракт открытого аукциона мы дополним и получим контракт аукциона вслепую. Преимущество аукциона вслепую заключается в отсутсвии спешки по времени ближе к концу проведения торгов. Создание аукциона вслепую  на прозрачно вычислительной платформе может показаться противоречивым, но на помощь приходит криптография.

EN
During the **bidding period**, a bidder does not actually send their bid, but only a hashed version of it. Since it is currently considered practically impossible to find two (sufficiently long) values whose hash values are equal, the bidder commits to the bid by that. After the end of the bidding period, the bidders have to reveal their bids: They send their values unencrypted, and the contract checks that the hash value is the same as the one provided during the bidding period. 

RU
Во время **проведения торгов** участник на самом деле не отправляет свою заявку, а только ее хэшированную версию. Поскольку на данный момент считается что практически невозможно найти два (достаточно длинных) значения, хэш-значениия которых были бы равны, и участник торгов берет на себя обязательство и делает свою ставку именно таким образом. После окончания периода торгов, участники должны раскрыть свои предложения: Они отправляют свои значения ставок (?) в незашифрованном виде, а контракт проверяет, совпадает ли хэш-значение с тем, которое было предоставлено этим участником в период, когда проходили торги.

EN
Another challenge is how to make the auction **binding and blind** at the same time: The only way to prevent the bidder from just not sending the money after they won the auction is to make them send it together with the bid. Since value transfers cannot be blinded in Ethereum, anyone can see the value.

RU
Другая загвоздка заключается в том, как сделать аукцион одновременно и обязательным/принудительным(?) и слепым: Единственный способ помешать участнику - это просто не отправлять деньги после их победы в аукционе, а заставить их отправлять их(?) вместе с заявкой. Поскольку в Ethereum (передачи стоимости/операции по переводу) не могут быть сделаны "вслепую", то любой может увидеть стоимость/значение. (?)

EN
The following contract solves this problem by accepting any value that is larger than the highest bid. Since this can of course only be checked during the reveal phase, some bids might be **invalid**, and this is on purpose (it even provides an explicit flag to place invalid bids with high-value transfers): Bidders can confuse competition by placing several high or low invalid bids.

RU
Следующий рассматриваемый контракт решает эту проблему, принимая любое значение, которое больше самой высокой ставки. Поскольку это можно проверить только на этапе раскрытия, некоторые ставки могут оказаться **недействительными**, и это сделано специально (в контракте даже предусмотрен явный флаг для размещения недействительных ставок с передачей высокой стоимости (?)): Участники торгов мгут запутать конкурентов, разместив несколько высоких или низких недействительных предложений.

```javascript
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
contract BlindAuction {
    struct Bid {
        bytes32 blindedBid;
        uint deposit;
    }

    address payable public beneficiary;
    uint public biddingEnd;
    uint public revealEnd;
    bool public ended;

    mapping(address => Bid[]) public bids;

    address public highestBidder;
    uint public highestBid;

    // Разрешены отзывы/возвраты предыдущих заявок
    mapping(address => uint) pendingReturns;

    event AuctionEnded(address winner, uint highestBid);

    // Ошибки, описывающие сбои

    /// Функция была вызывана слишком рано.
    /// Попробуйте снова в `time`
    error TooEarly(uint time);
    /// Функция была вызывана слишком позжно.
    /// Она не может быть вызвана после `time`.
    error TooLate(uint time);
    /// Функция `auctionEnd` уже была вызвана.
    error AuctionEndAlreadyCalled();

    // Модификаторы - это удобный способ проверить передаваемые
    // функциям данные. `onlyBefore` применяется к `bid`:
    // Новое тело функции является телом модификатором, где
    // `_`(знак подчеркивания) заменяется старым телом функции.
    modifier onlyBefore(uint time) {
        if (block.timestamp >= time) revert TooLate(time);
        _;
    }
    modifier onlyAfter(uint time) {
        if (block.timestamp <= time) revert TooEarly(time);
        _;
    }

    constructor(
        uint biddingTime,
        uint revealTime,
        address payable beneficiaryAddress
    ) {
        beneficiary = beneficiaryAddress;
        biddingEnd = block.timestamp + biddingTime;
        revealEnd = biddingEnd + revealTime;
    }

    /// Place a blinded bid with `blindedBid` =
    /// keccak256(abi.encodePacked(value, fake, secret)).
    /// The sent ether is only refunded if the bid is correctly
    /// revealed in the revealing phase. The bid is valid if the
    /// ether sent together with the bid is at least "value" and
    /// "fake" is not true. Setting "fake" to true and sending
    /// not the exact amount are ways to hide the real bid but
    /// still make the required deposit. The same address can
    /// place multiple bids.
    /// Размещаем ставку "вслепую" с `blindBid` = keccak256(abi.encodePacked(value, fake, secret)).
    /// Отправленный эфир возвращается только в том случае, если ставка 
    /// правильно раскрыта на этапе раскрытия. Ставка действительна, если
    /// эфир, отправленный вместе со ставкой, с минимальной стоимостью `value` 
    /// и `fake` не равен true. Установка `fake` в true и отправка
    /// неточной суммы - являются способами скрыть реальную ставку, но
    /// при этом требуется внести депозит. 
    /// Один и тот же адрес может размещать несколько ставок.
    function bid(bytes32 blindedBid)
        external
        payable
        onlyBefore(biddingEnd)
    {
        bids[msg.sender].push(Bid({
            blindedBid: blindedBid,
            deposit: msg.value
        }));
    }

    /// Оглашаем свои ставки, сделанные вслепую. Вам вернуться деньги/эфир
    /// за все правильно закрытые недействительные ставки и за все ставки,
    /// за исключение самой высокой.
    function reveal(
        uint[] calldata values,
        bool[] calldata fakes,
        bytes32[] calldata secrets
    )
        external
        onlyAfter(biddingEnd)
        onlyBefore(revealEnd)
    {
        uint length = bids[msg.sender].length;
        require(values.length == length);
        require(fakes.length == length);
        require(secrets.length == length);

        uint refund;
        for (uint i = 0; i < length; i++) {
            Bid storage bidToCheck = bids[msg.sender][i];
            (uint value, bool fake, bytes32 secret) =
                    (values[i], fakes[i], secrets[i]);
            if (bidToCheck.blindedBid != keccak256(abi.encodePacked(value, fake, secret))) {
                // Ставка на самом деле не была раскрыта.
                // Не возвращаем депозит.
                continue;
            }
            refund += bidToCheck.deposit;
            if (!fake && bidToCheck.deposit >= value) {
                if (placeBid(msg.sender, value))
                    refund -= value;
            }

            // Делаем невозможным повторное требования на возврат отправителем
            // того же депозита
            bidToCheck.blindedBid = bytes32(0);
        }
        payable(msg.sender).transfer(refund);
    }

    /// Отзовать ставку, которая была переибата.
    function withdraw() external {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            //(?) can call this function again as part of the receiving call 
            // before `transfer` returns (see the remark above about
            // conditions -> effects -> interaction).
            // Важно установить это значение равное нулю, потому что получатель
            // может вызвать эту функцию снова как часть принимающего вызова
            // до того как `transfer` вернет результат (см. замечаине выше об
            // условиях -> эффектах/действиях -> взаимодействии).
            pendingReturns[msg.sender] = 0;

            payable(msg.sender).transfer(amount);
        }
    }

    /// Завершаем аукцион и отправляем самую высокую ставку
    /// бенефициару.
    function auctionEnd()
        external
        onlyAfter(revealEnd)
    {
        if (ended) revert AuctionEndAlreadyCalled();
        emit AuctionEnded(highestBidder, highestBid);
        ended = true;
        beneficiary.transfer(highestBid);
    }

    // Это "внутренняя" функция, что означает, что она 
    // может быть вызвана только из самого контракта (или из)
    // производных контрактов).
    function placeBid(address bidder, uint value) internal
            returns (bool success)
    {
        if (value <= highestBid) {
            return false;
        }
        if (highestBidder != address(0)) {
            // Фиксируем необходимость возврата средств для предыдущего участника торгов
            // который ранее сделал самую высокую ставку.
            pendingReturns[highestBidder] += highestBid;
        }
        highestBid = value;
        highestBidder = bidder;
        return true;
    }
}
```

### Safe Remote Purchase
### Безопасная Удаленная/Дистанционная Покупка

EN
Purchasing goods remotely currently requires multiple parties that need to trust each other. The simplest configuration involves a seller and a buyer. The buyer would like to receive an item from the seller and the seller would like to get money (or an equivalent) in return. The problematic part is the shipment here: There is no way to determine for sure that the item arrived at the buyer.

RU
Покупка товаров удаленно в настоящее время требуется участия нескольких сторон, которые должны доверять друг другу. Простейшая форма такого взаимодействия включает продавца и покупателя. Покупаетль хотел бы получить товар от продавца,а продавец взамен хотел бы получить деньги (или эквивалент). Проблемной частью здесь является доствка: Нет возможности точно определить, что товар прибыл к покупателю.

EN
There are multiple ways to solve this problem, but all fall short in one or the other way. In the following example, both parties have to put twice the value of the item into the contract as escrow. As soon as this happened, the money will stay locked inside the contract until the buyer confirms that they received the item. After that, the buyer is returned the value (half of their deposit) and the seller gets three times the value (their deposit plus the value). The idea behind this is that both parties have an incentive to resolve the situation or otherwise their money is locked forever.

RU
Существует множество способов решения этой проблемы, но все они не работают в той или иной степени. В следующем примере обе стороны должны внести в договор в качестве условного депонирования(хранения) сумму, вдвое превышающую стоимость товара. Как только это произойдет, деньги останутся заблокированными в контракте до тех пор пока покупатель не подтвердит, что получил товар. После этого покупателю возвращается стоимость(половина его депозита), а продавец получает трехкратную стоимость(его депозит плюс стоимость). Идея заключается в том, что у обеих сторон есть стимул разрешить ситуацию, иначе их деньги будут заблокированны навсегда.

EN
This contract of course does not solve the problem, but gives an overview of how you can use state machine-like constructs inside a contract.

RU
Данный контракт, конечно, не решает проблему, но дает представление о том, как можно использовать механизмы, подобно государственной машине, внутри контракта.

```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
contract Purchase {
    uint public value;
    address payable public seller;
    address payable public buyer;

    enum State { Created, Locked, Release, Inactive }
    // Переменная `state` имеет значение по умолчанию первого члена, `State.Created`
    State public state;

    modifier condition(bool condition_) {
        require(condition_);
        _;
    }

    /// Только покупатель может вызвать эту функцию.
    error OnlyBuyer();
    /// Только продавец может вызвать эту функцию.
    error OnlySeller();
    /// Функция не может быть вызывана в текущем состоянии.
    error InvalidState();
    /// Предоставленное значение должно быть четным.
    error ValueNotEven();

    modifier onlyBuyer() {
        if (msg.sender != buyer)
            revert OnlyBuyer();
        _;
    }

    modifier onlySeller() {
        if (msg.sender != seller)
            revert OnlySeller();
        _;
    }

    modifier inState(State state_) {
        if (state != state_)
            revert InvalidState();
        _;
    }

    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();
    event SellerRefunded();

    // Нужно убедиться что `msg.value` четное число.
    // Деление будет усеченным(c потерей), если это нечетное число.
    // Проверяем с помощью умножения, что число четное.
    constructor() payable {
        seller = payable(msg.sender);
        value = msg.value / 2;
        if ((2 * value) != msg.value)
            revert ValueNotEven();
    }

    /// Прерываем покупку и возвращаем эфир.
    /// Может быть вызвана только продавцом до того, как
    /// контракт будет заблокирован.
    function abort()
        external
        onlySeller
        inState(State.Created)
    {
        emit Aborted();
        state = State.Inactive;
        // We use transfer here directly. It is
        // reentrancy-safe, because it is the
        // last call in this function and we
        // already changed the state.
        // Здесь мы напрямую делаем перевод.
        // Это безопасно от повторного входа(?), потому что
        // это последний вызов в этой функци, и
        // мы уже изменили все необходимые состояния(переменные состояний).
        seller.transfer(address(this).balance);
    }

    /// Подтверждаем покупку как покупатель.
    /// Транзакция должна включать `2 * стоимость` эфира.
    /// Эфир будет заблокировать до тех пор, 
    /// пока не будет вызвана функция `confirmReceived`
    function confirmPurchase()
        external
        inState(State.Created)
        condition(msg.value == (2 * value))
        payable
    {
        emit PurchaseConfirmed();
        buyer = payable(msg.sender);
        state = State.Locked;
    }

    /// Подтверждение, что вы (покупатель) получили товар. 
    /// Это освободит заблокированный эфир.
    function confirmReceived()
        external
        onlyBuyer
        inState(State.Locked)
    {
        emit ItemReceived();
        // It is important to change the state first because
        // otherwise, the contracts called using `send` below
        // can call in again here.
        // Важно сначала изменить состояние, т.к иначе
        // контракты, вызванные с помощью `send` приведенный ниже (?) функционал
        // могут вызвать это повторно.
        state = State.Release;

        buyer.transfer(value);
    }

    /// Эта функция возвращает деньги продавцу, т.е.
    /// возвращает заблокированные средства продавца
    function refundSeller()
        external
        onlySeller
        inState(State.Release)
    {
        emit SellerRefunded();
        // It is important to change the state first because
        // otherwise, the contracts called using `send` below
        // can call in again here.
        // Важно сначала изменить состояние, т.к иначе
        // контракты, вызванные с помощью `send` приведенный ниже (?) функционал
        // могут вызвать это повторно.
        state = State.Inactive;

        seller.transfer(3 * value);
    }
}
```