// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

// library Math {
//     function divide(uint256 a, uint256 b) internal pure returns (uint256) {
//         require(b > 0);
//         uint256 c = a / b;
//         return c;
//     }
// }

// import "./Math.sol";
import "./SafeMath.sol";

contract MyContract {
    using SafeMath for uint256;
    uint256 public value;
    
    function calculate(uint _value1, uint _value2) public {
        value = _value1.div(_value2);
    }
}