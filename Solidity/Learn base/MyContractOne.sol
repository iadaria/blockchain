// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

contract MyContract {
    //** @title Using Map*/
    uint256 public peopleCount = 0;
    mapping(uint => Person) public people;
    uint256 openingTime = 1706179351;
    
    address owner;
    
    // Person[] public people;
    // uint256 public peopleCount;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    
    modifier onlyWhileOpen() {
        require(block.timestamp >= openingTime);
        _;
    }
    
    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function addPerson(
        string memory _firstName, 
        string memory _lastName
    ) 
        public 
        onlyWhileOpen
        // onlyOwner 
    {
        // peopleCount += 1;
        incrementCount();
        people[peopleCount] = Person(peopleCount, _firstName, _lastName);
        // people.push(Person(_firstName, _lastName));
        // peopleCount += 1;
    }
    
    function incrementCount() internal {
        peopleCount += 1;
    }
    
    /** @title Elementary sintax
    
    string public value = "myValue";
    
    bool public myBool = true;
    int public myInt = -1;
    uint public myUnit = 1;
    uint8 public myUnit8 = 8;
    
    enum State { Waiting, Ready, Active }
    State public state;
    
    constructor() {
        value = "myValue2";
        state = State.Active;
    } */
    
    /* function get() public view returns(string memory) {
            return value;   
        }
        function set(string memory _value) public {
            value = _value;
        }
    
    function activate() public {
        state = State.Active;
    }
    
    function isActive() public view returns(bool) {
        return state == State.Active;
    }*/
}