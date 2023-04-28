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

### Micropayment Channel
### Канал для микроплатежей

EN
In this section, we will learn how to build an example implementation of a payment channel. It uses cryptographic signatures to make repeated transfers of Ether between the same parties secure, instantaneous, and without transaction fees. For the example, we need to understand how to sign and verify signatures, and setup the payment channel.

RU
В это разделе мы узнаем, как построить пример реализации платежного канала. Он использует криптографические подписи, чтобы сделать повторные переводы Эфира безопасными между одними и теми же сторонами, мгновенными и без комиссии за транзакцию. Для примера, нам нужно понять, как подписывать и верифицировать/проверять подписи, а также настроить платежный канал.

#### Creating and verifying signatures
#### Создание и проверка подписей

EN
Imagine Alice wants to send some Ether to Bob, i.e. Alice is the sender and Bob is the recipient.

Alice only needs to send cryptographically signed messages off-chain (e.g. via email) to Bob and it is similar to writing checks.

RU
Представим, что Алиса хочет отправить некоторое количество Эфиров Бобу, т.е. Алиса - отправитель, а Боб - получатель.

Для этого Алисе нужно только отправить Бобу криптографически подписанное сообщение вне блокчейн-сети (например через email), что похоже на выписанные чеки.

EN
Alice and Bob use signatures to authorize transactions, which is possible with smart contracts on Ethereum. Alice will build a simple smart contract that lets her transmit Ether, but instead of calling a function herself to initiate a payment, she will let Bob do that, and therefore pay the transaction fee.

RU
Алиса и Боб используют подписи для авторизации транзакций, что возможно с помощью смарт-контрактов на Эфире.
Алиса создаст простой смарт-контракт, который позволит ей передавать Эфир, но вместо того, чтобы самой вызывать функцию для инициирования платежа, она позволит Бобу сделать это, и соответственно, оплатить комиссию за транзакцию.

EN
The contract will work as follows:
1. Alice deploys the ReceiverPays contract, attaching enough Ether to cover the payments that will be made.
2. Alice authorizes a payment by signing a message with her private key.
3. Alice sends the cryptographically signed message to Bob. The message does not need to be kept secret (explained later), and the mechanism for sending it does not matter.
4. Bob claims his payment by presenting the signed message to the smart contract, it verifies the authenticity of the message and then releases the funds.

RU
Контракт будет работать следующим образом:
1. Алиса публикует `ReceiverPays` контракт, прикрепляя достаточное количество Эфира для покрытия платежей, которые будут произведены.
2. Алиса одобряет/санкционирует платеж, подписывая сообщение с помощью приватного ключа.
3. Алиса отправляет криптографически подписанное сообщение Бобу. Сообщение не требуется держать в секрете (это объясняется позже), и механизм отправки сообщения Бобу не имеет значение.
4. Боб требует оплаты, предъявляя подписанное сообщение смарт-контракту, который проверяет подлинность сообщения и затем выдает деньги.

### Creating the signature
### Создание подписи

EN
Alice does not need to interact with the Ethereum network to sign the transaction, the process is completely offline. In this tutorial, we will sign messages in the browser using web3.js and MetaMask, using the method described in EIP-712, as it provides a number of other security benefits.

RU
У Алисы нет необходимости взаимодействовать с сетью Ethereum для подписания транзакции, этот процесс происходит полностью офлайн/автономно. В этой документации, мы будем подписывать сообщения в браузере с помощью библиотеки web3.js и MetaMask, используя метод, описанный в EIP-712, поскольку он обеспечивает ряд других преимуществ в плане безопасности.

```javascript
/// Предварительное хэширование все упрощает
var hash = web3.utils.sha3("message to sign");
web3.eth.personal.sign(hash, web3.eth.defaultAccount, function () { console.log("Signed"); });
```

EN
>Note
The web3.eth.personal.sign prepends the length of the message to the signed data. Since we hash first, the message will always be exactly 32 bytes long, and thus this length prefix is always the same.

> <c>ℹ️ Примечание</c>
___
`web3.eth.personal.sign` добавляет длину сообщения к подписанным данным. Поскольку мы сначала хэшируем сообщение, длина сообщения всегда будет ровно 32 байта, поэтому префикс длины всегда один и тот же.
___

### What to Sign
### Что подписывать

EN
For a contract that fulfils payments, the signed message must include:
1. The recipient’s address.
2. The amount to be transferred.
3. Protection against replay attacks.

RU
В контракте, по которому осуществляются платежи, подписанное сообщение должно содержать:
1. Адрес получателя.
2. Сумму, подлежащая переводу.
3. Защита от атак повторного воспроизведения. (?)

EN
A replay attack is when a signed message is reused to claim authorization for a second action. To avoid replay attacks we use the same technique as in Ethereum transactions themselves, a so-called nonce, which is the number of transactions sent by an account. The smart contract checks if a nonce is used multiple times.

RU
Атака повторного воспроизведения - это когда подписанное сообщение используется повторно для получения разрешения на повтоное действие. Чтобы избежать атак повторного воспроизвдеения, мы используем ту же технику, что и в самих транзакциях Ethereum, - так называемый `nonce`(одноразовый номер), который представляет собой количество транзакций, отправленных аккаунтом. Смарт-контракт проверяет, не используется ли `nonce` несколько раз.

**nonce** - number that can only be used once - число, которое может быть использовано один раз, одноразовый код.

EN
Another type of replay attack can occur when the owner deploys a ReceiverPays smart contract, makes some payments, and then destroys the contract. Later, they decide to deploy the RecipientPays smart contract again, but the new contract does not know the nonces used in the previous deployment, so the attacker can use the old messages again.

RU
Другой тип атаки повторного воспроизведения может возникнуть, когда владелец контракта публикует смарт-контракт `ReceiverPays`, проводит несколько платежей, а затем уничтожает контракт. Позже, они решают снова развернуть смарт-контракт `RceiverPays`, но новый контракт не знает `nonces`(всех одноразовых кодов), использованных в предыдущей публикации, поэтому злоумышленник может снова использовать старые сообщения.

EN
Alice can protect against this attack by including the contract’s address in the message, and only messages containing the contract’s address itself will be accepted. You can find an example of this in the first two lines of the claimPayment() function of the full contract at the end of this section.

RU
Алиса может защититься от этой атаки, включив адреса контракта в сообщение, и только сообщения, содержащие адрес самого контракта, будут приняты. Пример этого можно найти в первых двух строках функции `claimPayment()` полного контракта в конце этого раздела.

### Packing arguments
### Упаковка аргументов

EN
Now that we have identified what information to include in the signed message, we are ready to put the message together, hash it, and sign it. For simplicity, we concatenate the data. The ethereumjs-abi library provides a function called soliditySHA3 that mimics the behaviour of Solidity’s keccak256 function applied to arguments encoded using abi.encodePacked. Here is a JavaScript function that creates the proper signature for the ReceiverPays example:

RU
Теперь, когда мы определились, какую информацию включить в подписываемое сообщение, мы готовы собрать сообщение воедино, хэшировать его, а затем подписать. Для простоты, мы будем соединять данные. Библиотека ethereumjs-abi предоставляет функцию `soliditySHA3`, которая имитирует поведение функции `keccak256` от Solidity, применяемой к аргументам, закодированным с помощью `abi.encodePacked`. Вот функция JavaScript, которая создает правильну подпись для примера контракта `ReceiverPays`:


```javascript
// `receipent` - это адрес, на который следует отправить деньги.
// `amount` - в wei, указывает, сколько эфира должно быть отправлено.
// `nonce` - может быть любым уникальным числом для предотвращения атак воспроизведения.
// `contractAddress` - используется для предотвращения межконтрактных атак воспроизведения.
function signPayment(recipient, amount, nonce, contractAddress, callback) {
    var hash = "0x" + abi.soliditySHA3(
        ["address", "uint256", "uint256", "address"],
        [recipient, amount, nonce, contractAddress]
    ).toString("hex");

    web3.eth.personal.sign(hash, web3.eth.defaultAccount, callback);
}
```

### Recovering the Message Signer in Solidity
### Восстановление лица подписавшего сообщение в Solidity

EN
In general, ECDSA signatures consist of two parameters, r and s. Signatures in Ethereum include a third parameter called v, that you can use to verify which account’s private key was used to sign the message, and the transaction’s sender. Solidity provides a built-in function ecrecover that accepts a message along with the r, s and v parameters and returns the address that was used to sign the message.

RU
В общем случает, подписи ECDSA состоят из двух частей, `r` and `s`. Подписи в Ethereum включают 3-ий параметр, называемый `v`, который можно использовать для проверки/верификации того, закрытый ключ какой учетной записи был использован для подписания сообщениия, а также отправителя транзакции. Solidity предоставляет встроенную функцию `ecrecover`, которая принимает сообщение вместе с параметрами, `r`, `s` и `v` и возвращает адрес, который был использован для подписи сообщения.

### Extracting the Signature Parameters
### Извлечение параметров подписи

EN
Signatures produced by web3.js are the concatenation of r, s and v, so the first step is to split these parameters apart. You can do this on the client-side, but doing it inside the smart contract means you only need to send one signature parameter rather than three. Splitting apart a byte array into its constituent parts is a mess, so we use inline assembly to do the job in the splitSignature function (the third function in the full contract at the end of this section).

RU
Подписи, создаваемые с помощью web3.js, представляют собой конкатенацию(соединение) `r`, `s` и `v`, поэтому первым шагом будет разделение этих параметров. Вы можете сделать это на стороне клиента, но если сделать это внутри смарт-контракта, то вам нужно будет отправить только один параметр подписи, а не три. Разделение массива байтов на составляющие части - дело непростое, поэтому мы используем `inline assembly` для выполнения этой работы в функции `splitSignature`(это третья функция в полной версии контракта, в конце этого раздела).

### Computing the Message Hash
### Вычисление хэша сообщения

EN
The smart contract needs to know exactly what parameters were signed, and so it must recreate the message from the parameters and use that for signature verification. The functions prefixed and recoverSigner do this in the claimPayment function.

RU
Смарт-контракту необходимо знать, какие именно параметры были подписаны, поэтому он должен воссоздать сообщение из параметров и использовать его для проверки подписи. Функции `prefixed` и `recoverSigner` делают это в функции `claimPayment`.

### The full contract
### Полная версия контракта

```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
// Это выдаст предупреждение из-за устаревшего `selfdestruct`
contract ReceiverPays {
    address owner = msg.sender;

    mapping(uint256 => bool) usedNonces;

    constructor() payable {}

    function claimPayment(uint256 amount, uint256 nonce, bytes memory signature) external {
        require(!usedNonces[nonce]);
        usedNonces[nonce] = true;

        // воссоздаем сообщение, которое было подписано на клиенте
        bytes32 message = prefixed(keccak256(abi.encodePacked(msg.sender, amount, nonce, this)));

        require(recoverSigner(message, signature) == owner);

        payable(msg.sender).transfer(amount);
    }

    /// уничтожаем контракт и получаем оставшиеся средства.
    function shutdown() external {
        require(msg.sender == owner);
        selfdestruct(payable(msg.sender));
    }

    /// методы подписи.
    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65);

        assembly {
            // первые 32 байта, после префикса длины.
            r := mload(add(sig, 32))
            // вторые 32 байта.
            s := mload(add(sig, 64))
            // последний байт (первый байт из следующих 32 байтов).
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig)
        internal
        pure
        returns (address)
    {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

    /// builds a prefixed hash to mimic the behavior of eth_sign.
    /// ставит префиксный хэш, чтобы имитировать поведение `eth_sign`.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}
```

### Writing a Simple Payment Channel
### Написание простого платежного канала

EN
Alice now builds a simple but complete implementation of a payment channel. Payment channels use cryptographic signatures to make repeated transfers of Ether securely, instantaneously, and without transaction fees.

RU
Теперь Алиса создает простую, но полную реализацию платежного канала. Платежные канала используют криптографические подписи для осуществления повторяющихся переводов Эфира безопасно, мгновенно, и без комиссии за транзакции.

### What is a Payment Channel?
### Что такое платежный канал?

EN
Payment channels allow participants to make repeated transfers of Ether without using transactions. This means that you can avoid the delays and fees associated with transactions. We are going to explore a simple unidirectional payment channel between two parties (Alice and Bob). It involves three steps:
1. Alice funds a smart contract with Ether. This “opens” the payment channel.
2. Alice signs messages that specify how much of that Ether is owed to the recipient. This step is repeated for each payment.
3. Bob “closes” the payment channel, withdrawing his portion of the Ether and sending the remainder back to the sender.

RU
Платежные каналы позволяют участникам осуществлять многократные переводы Эфира без использования транзакций. Это означает, что вы можете избежать задержек и комиссий, связанных с транзакциями. Мы рассмотрим просто односторонний/однонаправленный платежный канал между двумя сторонами(Алисой и Бобом). Он включает в себя три этапа:
1. Алиса пополняет смарт-контракт Эфиром. Это "открывает" платежный канал.
2. Алиса подписывает сообщения, в которых указывается, сколько Эфира полагается получателю. Данный шаг повторяется для каждого платежа.
3. Боб "закрывает" платежный канал, забирая/выводя свою часть Эфира и отправляя остаток обратно отправителю.

EN
Only steps 1 and 3 require Ethereum transactions, step 2 means that the sender transmits a cryptographically signed message to the recipient via off chain methods (e.g. email). This means only two transactions are required to support any number of transfers.

RU
> <c>ℹ️ Примечание</c>
___
Только для осуществления шагов 1 и 3 требуется выполнение Ethereum-транзакций, шаг 2 означает, что отправитель передает криптографиески подписанное сообщение получателю вне цепи блокчейна (например, по электронной почте). Таким образом, для осуществленния любого количества переводов требуется всего две транзакции.
___

EN
Bob is guaranteed to receive his funds because the smart contract escrows the Ether and honours a valid signed message. The smart contract also enforces a timeout, so Alice is guaranteed to eventually recover her funds even if the recipient refuses to close the channel. It is up to the participants in a payment channel to decide how long to keep it open. For a short-lived transaction, such as paying an internet café for each minute of network access, the payment channel may be kept open for a limited duration. On the other hand, for a recurring payment, such as paying an employee an hourly wage, the payment channel may be kept open for several months or years.

RU
Боб гарантированно получит свои средства, поскольку смарт-контракт хранит(депонирует) Эфир и исполняет одно(?) действительное подписанное сообщение. Смарт-контракт также обеспечивает время ожидания/блокировку по времени, поэтому Алиса гарантированно вернутся ее средства, даже если получатель(Боб) откажется закрывать свой платежный канал. Участники платежного канала сами решают, как долго держать его открытым. для кратковременных транзакций, например, таких как оплата в интернет-кафе за каждую минуту доступа к сети, платежный канал может оставаться открытым только в течении ограниченного периода времени. С другой стороны, для повторяющихся платежей, таких как почасовая оплата труда работника, платежный канал может оставаться открытым в течении нескольких месяцев или лет.

EN
### Opening the Payment Channel
To open the payment channel, Alice deploys the smart contract, attaching the Ether to be escrowed and specifying the intended recipient and a maximum duration for the channel to exist. This is the function `SimplePaymentChannel` in the contract, at the end of this section.

RU
### Открытие платежного канала
Чтобы открыть платежный канал, Алиса развертывает смарт-контракт, обеспечивая его Эфиром в качестве вложения/депонирования, и указывая предполагаемого получателя и максимальную продолжительность существования канала. Это делает функция контракта `SimplePaymentChanel` приведенного в конце этого раздела.

EN
### Making Payments
Alice makes payments by sending signed messages to Bob. This step is performed entirely outside of the Ethereum network. Messages are cryptographically signed by the sender and then transmitted directly to the recipient.

Each message includes the following information:
- The smart contract’s address, used to prevent cross-contract replay attacks.
- The total amount of Ether that is owed to the recipient so far.

RU
### Осуществление Платежей
Алиса осуществляет платежи, отправляя Бобу подписанные сообщения. Этот шаг выполняется полностью вне сети Ethereum.  Сообщения криптографически подисываются отправителем, а затем передаются непосредственно получателю.

Каждое сообщение содержит следующую информацию:
1. Адрес смарт-контракта, используемый для предотвращения кросс-контрактных атак повторного воспроизведения(?). 
2. Общая сумма Эфира, пока что предназначенная получателю.

EN
A payment channel is closed just once, at the end of a series of transfers. Because of this, only one of the messages sent is redeemed. This is why each message specifies a cumulative total amount of Ether owed, rather than the amount of the individual micropayment. The recipient will naturally choose to redeem the most recent message because that is the one with the highest total. The nonce per-message is not needed anymore, because the smart contract only honours a single message. The address of the smart contract is still used to prevent a message intended for one payment channel from being used for a different channel.

Here is the modified JavaScript code to cryptographically sign a message from the previous section:

RU
Платежный канал закрывается только один раз, в конце серии переводов. Поэтому, только одно из отправленных сообщений, будет погашено. Вот почему в каждом сообщении указываетя суммарная сумма причитающихся Эфиров, а не сумма отдельного микроплатежа. Получатель, естественно, решит погасить самое последнее сообщение, поскольку именно в нем указана наибольшая сумма. Одноразовый номер `nonce` больше не нужен на каждое сообщение, поскольку смарт-контракт исполняет только одно сообщение. Адрес смарт-контракта по-прежнему используется для того, чтобы сообщение, предназначенное для одного платежного канала, не было использовано для другого канала.


Вот доработанный код JavaScript из предыдущего раздела для криптографической подписи сообщения:
```javascript
function constructPaymentMessage(contractAddress, amount) {
    return abi.soliditySHA3(
        ["address", "uint256"],
        [contractAddress, amount]
    );
}

function signMessage(message, callback) {
    web3.eth.personal.sign(
        "0x" + message.toString("hex"),
        web3.eth.defaultAccount,
        callback
    );
}

// `contractAddress` используется для предотвращения межконтрактных атак воспроизведения (?)
// `amount`, в wei, указывает сколько Эфира должно быть отправлено

function signPayment(contractAddress, amount, callback) {
    var message = constructPaymentMessage(contractAddress, amount);
    signMessage(message, callback);
}
```

### Closing the Payment Channel
### Закрытие платежного канала

EN
When Bob is ready to receive his funds, it is time to close the payment channel by calling a close function on the smart contract. Closing the channel pays the recipient the Ether they are owed and destroys the contract, sending any remaining Ether back to Alice. To close the channel, Bob needs to provide a message signed by Alice.

RU
Когда Боб готов получить свои средства, наступает время закрыть платежный канал, вызвав функцию `close` смарт-контракта. Закрытие канала выплачивает получателю полженные ему Эфиры и уничтожает контракт, отправляя все оставшиеся Эфиры обратно Алисе. Чтобы закрыть канал, Боб должен предоставить сообщение, подписанное Алисой.

EN
The smart contract must verify that the message contains a valid signature from the sender. The process for doing this verification is the same as the process the recipient uses. The Solidity functions isValidSignature and recoverSigner work just like their JavaScript counterparts in the previous section, with the latter function borrowed from the ReceiverPays contract.

RU
Смарт-контракт должен проверить, что сообщение содержит действительную подпись отправителя. Процесс этой проверки такой же, как и процесс, использует получатель. Функции Solidity `isValidSignature` и `recoverSigner` работают так же, как их аналоги на JavaScript в предыдущем разделе, причем последняя функция заимстована из конракта `ReceiverPays`.

EN
Only the payment channel recipient can call the `close` function, who naturally passes the most recent payment message because that message carries the highest total owed. If the sender were allowed to call this function, they could provide a message with a lower amount and cheat the recipient out of what they are owed.

RU
Только получатель платежного канала может вызвать функцию `close`, которая, естественно, передает самое последнее сообщение о платеже, поскольку в этом сообщении содержится наибольшая сумма задолжности. Если бы отправителю было разрешено вызвать эту функцию, он мог бы передать сообщение с меньшей суммой и обмануть получателя на сумму долга.

EN
The function verifies the signed message matches the given parameters. If everything checks out, the recipient is sent their portion of the Ether, and the sender is sent the rest via a `selfdestruct`. You can see the `close` function in the full contract.

RU
Функция проверяет соответствие подписанного сообщения заданным параметрам.Если все подтверждается, получателю отправляется часть Эфира, а отправителю - остаток с помощью `selfdestruct`. Функцию `close` можно посмотреть в полной версии контратка.

### Channel Expiration
### Истечение срока действия контракта

EN
Bob can close the payment channel at any time, but if they fail to do so, Alice needs a way to recover her escrowed funds. An expiration time was set at the time of contract deployment. Once that time is reached, Alice can call claimTimeout to recover her funds. You can see the claimTimeout function in the full contract.

RU
Боб может закрыть платежный канал в любое время, но если он этого не сделает, Алисе нужен способ вернуть свои депонированные средства. Во время развертывания контракта было установлено время истечения срока действия. По истечении этого времени Алиса может вызвать функцию `claimTimeout`, чтобы вернуть свои средства. Вы можете посмотреть функцию `claimTimeout` в полной версии контракта.

EN
After this function is called, Bob can no longer receive any Ether, so it is important that Bob closes the channel before the expiration is reached.

RU
После вызова этой функции Алисой, Боб больше не сможет получить Эфир, поэтому важно, чтобы Боб закрыл канал до истечения срока действия. 

Полная версия контракт

```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
// Это выдаст предупреждение из-за устаревшего `selfdestruct`
contract SimplePaymentChannel {
    address payable public sender;      // Аккаунт, отправлющий платежи.
    address payable public recipient;   // Аккаунт, получающий платежи.
    uint256 public expiration; // Таймаут на случай, если получатель так и не закроется.

    constructor (address payable recipientAddress, uint256 duration)
        payable
    {
        sender = payable(msg.sender);
        recipient = recipientAddress;
        expiration = block.timestamp + duration;
    }

    /// получатель может закрыть канал в любое время, предъявив
    /// подписанную сумму полученную от отправителя.  Получателю будет отправлена эта сумма,
    /// и остаток вернется обратно отправителю.
    function close(uint256 amount, bytes memory signature) external {
        require(msg.sender == recipient);
        require(isValidSignature(amount, signature));

        recipient.transfer(amount);
        selfdestruct(sender);
    }

    /// отправитель может продлить срок действия в любое время
    function extend(uint256 newExpiration) external {
        require(msg.sender == sender);
        require(newExpiration > expiration);

        expiration = newExpiration;
    }

    /// если тайм-аут достигнут без закрытия кнала получателем,
    /// то Эфир возвращается обратно отправителю.
    function claimTimeout() external {
        require(block.timestamp >= expiration);
        selfdestruct(sender);
    }

    function isValidSignature(uint256 amount, bytes memory signature)
        internal
        view
        returns (bool)
    {
        bytes32 message = prefixed(keccak256(abi.encodePacked(this, amount)));

        // проверяем, что подпись принадлежит отправителю платежа
        return recoverSigner(message, signature) == sender;
    }

    /// Все следующие функции взяты и главы `Создание и проверка подписей`

    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65);

        assembly {
            // первый 32 байта, после префикса длины
            r := mload(add(sig, 32))
            // вторые 32 байта
            s := mload(add(sig, 64))
            // последний байт (первый байт от следующих 32 байтов)
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig)
        internal
        pure
        returns (address)
    {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

    /// формируем префиксный хэш, чтобы имитировать поведение eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}
```

EN
Note
The function splitSignature does not use all security checks. A real implementation should use a more rigorously tested library, such as openzepplin’s version of this code.

> <c>ℹ️ Примечание</c>
___
Функция `splitSignature` не использует все проверки безопасности. Реальная реализация должна больше использовать какую-нибудь тщательно протестированную библиотеку, такую как, например, openzepplin в частности [версию](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol) этого кода.
___

### Verifying Payments
### Проверка платежей

EN
Unlike in the previous section, messages in a payment channel aren’t redeemed right away. The recipient keeps track of the latest message and redeems it when it’s time to close the payment channel. This means it’s critical that the recipient perform their own verification of each message. Otherwise there is no guarantee that the recipient will be able to get paid in the end.

RU
В отличие от предыдущего раздела, сообщения в платежном канале не погашаются сразу. Получать отслеживает последнее сообщение и обменивает его, когда подходит время закрывать платежный канал. Это означает, что очень важно, чтобы получатель самостоятельно проверял каждое сообщение. В противном случает нет никакой гарантии, что получатель сможет в итоге получить деньги.

EN
The recipient should verify each message using the following process:
1 Verify that the contract address in the message matches the payment channel.
2 Verify that the new total is the expected amount.
3 Verify that the new total does not exceed the amount of Ether escrowed.
4 Verify that the signature is valid and comes from the payment channel sender.

RU
Получатель должен проверять каждое сообщение следующим образом:
1 Убедиться, что адрес контракта в полученном сообщении соответствует каналу оплаты.
2 Убедиться, что новая общая сумма в сообщении соответствует ожидаемой сумме.
3 Убедиться, что новая общая сумма не превышает сумму депонированных Эфиров.
4 Убедиться, что подпись действительна и пришла от отправителя платежного канала.

EN
We’ll use the ethereumjs-util library to write this verification. The final step can be done a number of ways, and we use JavaScript. The following code borrows the constructPaymentMessage function from the signing JavaScript code above:

RU
Для написаний это проверки мы будем использовать библиотеку `ethereumjs-util`. Последний шаг может быть выполнен несколькими способами, и мы будем использовать JavaScript. Следующий код заимствует функцию `constructPaymentMessage` из JavaScript-кода подписи(?), приведенного выше:

```javascript
// this mimics the prefixing behavior of the eth_sign JSON-RPC method.
// это имитирует поведение префикса метода eth_sign JSON-RPC.
function prefixed(hash) {
    return ethereumjs.ABI.soliditySHA3(
        ["string", "bytes32"],
        ["\x19Ethereum Signed Message:\n32", hash]
    );
}

function recoverSigner(message, signature) {
    var split = ethereumjs.Util.fromRpcSig(signature);
    var publicKey = ethereumjs.Util.ecrecover(message, split.v, split.r, split.s);
    var signer = ethereumjs.Util.pubToAddress(publicKey).toString("hex");
    return signer;
}

function isValidSignature(contractAddress, amount, signature, expectedSigner) {
    var message = prefixed(constructPaymentMessage(contractAddress, amount));
    var signer = recoverSigner(message, signature);
    return signer.toLowerCase() ==
        ethereumjs.Util.stripHexPrefix(expectedSigner).toLowerCase();
}
```

### Modular Contracts
### Модульные контракты

EN
A modular approach to building your contracts helps you reduce the complexity and improve the readability which will help to identify bugs and vulnerabilities during development and code review. If you specify and control the behaviour of each module in isolation, the interactions you have to consider are only those between the module specifications and not every other moving part of the contract. In the example below, the contract uses the `move` method of the `Balances` library to check that balances sent between addresses match what you expect. In this way, the `Balances` library provides an isolated component that properly tracks balances of accounts. It is easy to verify that the `Balances` library never produces negative balances or overflows and the sum of all balances is an invariant across the lifetime of the contract.

RU
Модульный подход к построению контрактов помогает снизить сложность и улучшить читаемость, что поможет выявить ошибки и уязвимости в овремя разработки и проверки кода. Если вы определяете и контролируете поведение каждого модуля по отдельности, то вам придется учитывать только взаимодействие между спецификациями модулей, а не все остальные moving(?) части контракта. В приведенном ниже примере, контракт использует метод `move` библиотеки `Balacnes` чтобы удостовериться, что balances (?) отправленные между адресами, соответствуют ожидаемым(?). Таким образом, библиотека `Balances` предоставляет изолированный компонент, который правильно отселживает остатки на счетах. Легко проверить, что библиотека `Balances` никогда не возвращает отрицательный баланс или не допускает переполнение, а сумма всех балансов является неизменной на протяжении всего срока действия контракта.

```java
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

library Balances {
    function move(mapping(address => uint256) storage balances, address from, address to, uint amount) internal {
        require(balances[from] >= amount);
        require(balances[to] + amount >= balances[to]); // otherwise we get overflow
        balances[from] -= amount;
        balances[to] += amount;
    }
}

contract Token {
    mapping(address => uint256) balances;
    using Balances for *;
    mapping(address => mapping(address => uint256)) allowed;

    event Transfer(address from, address to, uint amount);
    event Approval(address owner, address spender, uint amount);

    function transfer(address to, uint amount) external returns (bool success) {
        balances.move(msg.sender, to, amount);
        emit Transfer(msg.sender, to, amount);
        return true;

    }

    function transferFrom(address from, address to, uint amount) external returns (bool success) {
        require(allowed[from][msg.sender] >= amount);
        allowed[from][msg.sender] -= amount;
        balances.move(from, to, amount);
        emit Transfer(from, to, amount);
        return true;
    }

    function approve(address spender, uint tokens) external returns (bool success) {
        require(allowed[msg.sender][spender] == 0, "");
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function balanceOf(address tokenOwner) external view returns (uint balance) {
        return balances[tokenOwner];
    }
}
```