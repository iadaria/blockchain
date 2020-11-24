// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

contract ERC20Token {
    string public name;
    mapping(address => uint256) public balances;
    
    function mint() public {
        // balances[msg.sender] ++; // this wrong
        balances[tx.origin] ++;
    }
}

contract MyContract {
    // mapping(address => uint256) public balances;
    address payable wallet;
    address public token;
    
    // event Purchase(
    //     address indexed _buyer,
    //     uint256 _amount
    // );
    
    constructor(address payable _wallet, address _token) {
        wallet = _wallet;
        token = _token;
    }
    
    fallback() external payable {
        buyToken();
    }
    
    function buyToken() public payable {
    //     // buy a token 
    //     balances[msg.sender] += 1;
    //     // send ether to the wallet
        // ERC20Token _token = ERC20Token(address(token));
        // _token.mint();
        ERC20Token(address(token)).mint();
        wallet.transfer(msg.value);
    //     // emit Purchase(msg.sender, 1);
    }
}