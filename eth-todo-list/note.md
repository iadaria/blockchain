> npm install -g npm@latest
> npm install -g truffle@5.0.2 or
> truffle init

* Compile smart-contract
> truffle compile

* Deploy smart-contract
> truffle migrate

# Check our deployed smart-contract
> truffle console

>> todoList = await TodoList.deployed()
>> todoList - see contract
>> todoList.address
>> todoList.taskCount()
>> taskCount = await todoList.taskCount()
>> taskCount.toNumber() -- should be zero for begin