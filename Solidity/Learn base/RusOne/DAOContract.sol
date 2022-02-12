// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// Инрейрфейс токена
interface ChangableToken {
    function stop() external;
    function start() external;
    function changeSymbol(string memory name) external;
    function balanceOf(address user) external returns (uint256);
}

// Контракт ДАО
contract DAOContract {

    // Переменная для хранения токена
    ChangableToken public token;
    // Минимальное число голосов
    uint8 public minVotes;
    // Переменная для предложенного названия
    string public proposalName;
    // Переменная для хранения состояния голосования
    bool public voteActive = false;
    // Структура для голосов
    struct Votes {
        int current;
        uint numberOfVotes;
    }
    // Переменная для структуры голосов
    Votes public election;
    // Функция инициализации ( принимает адрес токена)
    constructor(ChangableToken _token) {
        token = _token;
    }
    // Фукнкция для предложения нового символа
    function newName(string memory _proposalName) public {
        // Проверяем что голосование не идет
        require(!voteActive, "The vote is active!");
        proposalName = _proposalName;
        voteActive = true;
        // Остановим рабоы токена - заблокируем функцию _transfer на время голосования
        token.stop();
    }

    // Функция для голосования
    function vote(bool _vote) public {
        // Проверим, что голосование идет
        require(voteActive, "The vote is not active, you cannot to vote!");
        // Логика для голосования
        if (_vote) {
            election.current += int(token.balanceOf(msg.sender));
        } else {
            election.current -= int(token.balanceOf(msg.sender));
        }
        election.numberOfVotes += token.balanceOf(msg.sender);
    }

    // Функция для смены символа
    function changeSymbol() public {
        // Проверяем, что голосование активно
        require(voteActive, "The vote is not active, you cannot to vote!");
        // Проверяем, что было достаточное количество голосов
        require(election.numberOfVotes >= minVotes, "Number of votes is less than min votes");
        // Логика для смены символа
        if (election.current > 0) {
            token.changeSymbol(proposalName);
        }
        // Сбрасываем все переменные для голосования
        election.numberOfVotes = 0;
        election.current = 0;
        voteActive = false;
        // Возобновляем работу нашего токена
        token.start();
    }
}