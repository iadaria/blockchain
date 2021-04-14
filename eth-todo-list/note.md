// Markdown language
https://www.markdownguide.org/basic-syntax/
video https://www.youtube.com/watch?v=itUrxH-rksc&list=PLP-nAdHo5zyIEqAf98sg_3Vg-rTmXXLtX&index=4
web3 + Metamask to read https://awantoch.medium.com/how-to-connect-web3-js-to-metamask-in-2020-fee2b2edf58a
min = 7:39:56

see https://www.trufflesuite.com/tutorials/building-testing-frontend-app-truffle-3

> npm install -g npm@latest
> npm install -g truffle@5.0.2 or
> truffle init

* Compile smart-contract
> truffle compile

* Deploy smart-contract
> truffle migrate
> truffle migrate --reset

### List tasks in the smart contract
1. List tasks in the smart contract
2. list tasks in the console
3. List tasks in the client side application
4. List tasks in the test

### Check our deployed smart-contract
> truffle console

-> todoList = await TodoList.deployed() \
-> todoList - see contract \
-> todoList.address \
-> todoList.taskCount() \
-> taskCount = await todoList.taskCount() \
-> taskCount.toNumber() -- it sshould be zero for begin \
-> task = await todoList.tasks(1) \
-> task \
-> task.id.toNumber() \
-> task.content \