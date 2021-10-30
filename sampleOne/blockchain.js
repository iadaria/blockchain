const Block = require('./block');

class Blockchain {
  constructor() {
    this.chain = [Block.genesis()];
  }

  addBlock(data) {
    const lastBlock = this.chain[this.chain.length - 1];
    const block = Block.mineBlock(lastBlock, data);
    this.chain.push(block);

    return block;
  }

  isValidChain(chain) {
    const toStr = obj => JSON.stringify(obj);

    if (toStr(chain[0]) !== toStr(Block.genesis())) return false;

    for (let i = 1; i < chain.length; i++) {
      const block = chain[i];
      const lastBlock = chain[i - 1];

      const isEqualLastHash = block.lastHash === lastBlock.hash;
      const isEqualHash = block.hash === Block.blockHash(block);

      return isEqualLastHash && isEqualHash;
    }
  }
}

module.exports = Blockchain;
