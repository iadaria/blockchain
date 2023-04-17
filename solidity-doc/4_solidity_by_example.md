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

            // Если произошло зациклирование в делегировании, что недопустимо.
            require(to != msg.sender, "Found loop in delegation.");
        }

        Voter storage delegate_ = voters[to];

        // Voters cannot delegate to accounts that cannot vote.
        require(delegate_.weight >= 1);

        // Since `sender` is a reference, this
        // modifies `voters[msg.sender]`.
        sender.voted = true;
        sender.delegate = to;

        if (delegate_.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate_.weight += sender.weight;
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
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

    // Calls winningProposal() function to get the index
    // of the winner contained in the proposals array and then
    // returns the name of the winner
    function winnerName() external view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}
```