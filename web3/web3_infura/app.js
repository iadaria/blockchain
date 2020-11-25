require('dotenv').config();
const Web3 = require('web3');
const web3 = new Web3('https://mainnet.infura.io/v3/bc0047816b8d47d8b4494f09a1a5a751');

web3.eth.getGasPrice().then((result) => {
    console.log('Gas price', web3.utils.fromWei(result, 'ether'));
});

/* const hash = web3.utils.sha3('Dap University');
console.log(hash);

const _ = web3.utils._;

_.each({ key1: 'value', key2: 'value'}, (value, key) => {
    console.log(key);
}); */

const account1 = '';
const account2 = '';

console.log('private_key', process.env.PRIVATE_KEY_1);

const privateKey1 = Buffer.from(process.env.PRIVATE_KEY_1, 'hex');
const privateKey2 = Buffer.from(process.env.PRIVATE_KEY_2, 'hex');

console.log(privateKey1);