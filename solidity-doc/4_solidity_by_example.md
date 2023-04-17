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
### Аукцион вслепую / Аукцион "втемную"
В этом разделе, мы покажем, как легко создать контракт аукциона полностью вслепую(?) на Ethereum.


EN
### Simple Open Auction
###

The general idea of the following simple auction contract is that everyone can send their bids during a bidding period. The bids already include sending money / Ether in order to bind the bidders to their bid. If the highest bid is raised, the previous highest bidder gets their money back. After the end of the bidding period, the contract has to be called manually for the beneficiary to receive their money - contracts cannot activate themselves.

RU

```javascript
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
contract SimpleAuction {
    // Parameters of the auction. Times are either
    // absolute unix timestamps (seconds since 1970-01-01)
    // or time periods in seconds.
    address payable public beneficiary;
    uint public auctionEndTime;

    // Current state of the auction.
    address public highestBidder;
    uint public highestBid;

    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns;

    // Set to true at the end, disallows any change.
    // By default initialized to `false`.
    bool ended;

    // Events that will be emitted on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // Errors that describe failures.

    // The triple-slash comments are so-called natspec
    // comments. They will be shown when the user
    // is asked to confirm a transaction or
    // when an error is displayed.

    /// The auction has already ended.
    error AuctionAlreadyEnded();
    /// There is already a higher or equal bid.
    error BidNotHighEnough(uint highestBid);
    /// The auction has not ended yet.
    error AuctionNotYetEnded();
    /// The function auctionEnd has already been called.
    error AuctionEndAlreadyCalled();

    /// Create a simple auction with `biddingTime`
    /// seconds bidding time on behalf of the
    /// beneficiary address `beneficiaryAddress`.
    constructor(
        uint biddingTime,
        address payable beneficiaryAddress
    ) {
        beneficiary = beneficiaryAddress;
        auctionEndTime = block.timestamp + biddingTime;
    }

    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won.
    function bid() external payable {
        // No arguments are necessary, all
        // information is already part of
        // the transaction. The keyword payable
        // is required for the function to
        // be able to receive Ether.

        // Revert the call if the bidding
        // period is over.
        if (block.timestamp > auctionEndTime)
            revert AuctionAlreadyEnded();

        // If the bid is not higher, send the
        // money back (the revert statement
        // will revert all changes in this
        // function execution including
        // it having received the money).
        if (msg.value <= highestBid)
            revert BidNotHighEnough(highestBid);

        if (highestBid != 0) {
            // Sending back the money by simply using
            // highestBidder.send(highestBid) is a security risk
            // because it could execute an untrusted contract.
            // It is always safer to let the recipients
            // withdraw their money themselves.
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    /// Withdraw a bid that was overbid.
    function withdraw() external returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            pendingReturns[msg.sender] = 0;

            // msg.sender is not of type `address payable` and must be
            // explicitly converted using `payable(msg.sender)` in order
            // use the member function `send()`.
            if (!payable(msg.sender).send(amount)) {
                // No need to call throw here, just reset the amount owing
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    /// End the auction and send the highest bid
    /// to the beneficiary.
    function auctionEnd() external {
        // It is a good guideline to structure functions that interact
        // with other contracts (i.e. they call functions or send Ether)
        // into three phases:
        // 1. checking conditions
        // 2. performing actions (potentially changing conditions)
        // 3. interacting with other contracts
        // If these phases are mixed up, the other contract could call
        // back into the current contract and modify the state or cause
        // effects (ether payout) to be performed multiple times.
        // If functions called internally include interaction with external
        // contracts, they also have to be considered interaction with
        // external contracts.

        // 1. Conditions
        if (block.timestamp < auctionEndTime)
            revert AuctionNotYetEnded();
        if (ended)
            revert AuctionEndAlreadyCalled();

        // 2. Effects
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Interaction
        beneficiary.transfer(highestBid);
    }
}
```