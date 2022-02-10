// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// Объявляем интерфейс
interface MyFirstERC20Token {
    function transfer(address _reciever, uint256 _amount) external;
}

contract MyFirstSafeICo {

    // Объявляем переменную для указания стоимости токена
    uint public buyPrice;

    // Объявляем переменную для хранения токена
    MyFirstERC20Token public token; // просто адрес смарт-контракта и вызовем на этом адрес функцию

    // Функция инициализации (принимаем токен)
    constructor(MyFirstERC20Token _token) {
        // Присваиваем токен
        token = _token;

        // Присваиваем стоимость
        buyPrice = 10000;
    }

    // Функция для прямого перевода эфира
    fallback() external payable {
        // Вызов внутренней функции
        _buy(msg.sender, msg.value);
    }

    // Функция для вызова
    function buy() public payable returns (uint) {
        // Вызов внутренней функции для покупки токенов - для фронт разрабов
        uint tokens = _buy(msg.sender, msg.value);
    
        // Возвращаем значение
        return tokens;
    }

    // Внутренняя функция
    function _buy(address _sender, uint256 _amount) internal returns (uint) {
        // Рассчитываем стоимость
        uint tokens = _amount / buyPrice;

        // Отправляем токены с помощью метода токена
        token.transfer(_sender, tokens);

        // Возвращаем значение удалось или нет
        return tokens;
    }
}