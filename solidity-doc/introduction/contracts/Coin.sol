// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Coin {
    // Ключевое слово "public" делает переменные доступными для других контрактов
    address public minter;
    mapping (address => uint) public balances;

    // События позволяют клиентам реагировать на определенные изменения, которые вы объявляете
    event Sent(address from, address to, uint amount);


    // Код в конструкторе запускается только только один раз - при создании контракта
    constructor() {
        minter = msg.sender;
    }
    // Отправляет только что созданные монеты в размере - amount на адрес - receiver
    // Данная функция может вызываться только владельцем/создателем контракта
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter, "You are not the minter");
        balances[receiver] += amount;
    }

    // Errors позволяют отображать информацию о том, почему операция закончилась с ошибкой
    // Ошибки возвращатеся пользователю, который вызывал функцию.
    error InsufficientBalance(uint requested, uint available);

    // Отправляем имеющиеся монеты в количестве - amount
    // Отправителем может быть любой на любой адрес
    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
