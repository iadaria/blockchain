### 
- compile a contract: > truffle compile
- deploy a contract: > truffle migrate
- console token: > truffle console

### truffle console
> const token = await Token.deployed()
- get token address: > token.address
- get name: > const name = await token.name()