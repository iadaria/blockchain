const SHA256 = require('crypto-js/sha256');
const ChainUtil = require('../chain-util');
const { DIFFICULTY, MINE_RATE } = require('../config');

class Block {
  constructor(timestamp, lastHash, hash, data, nonce, difficulty) {
    this.timestamp = timestamp;
    this.lastHash = lastHash;
    this.hash = hash;
    this.data = data;
    this.nonce = nonce;

    this.difficulty = difficulty || DIFFICULTY;
  }

  toString() {
    return `Block -
    Timestamp: ${this.timestamp}  
    Last hash: ${this.lastHash.substring(0, 10)}
    Hash: ${this.hash.substring(0, 10)}
    Nonce: ${this.nonce}
    Difficulty: ${this.difficulty}
    Data: ${this.data}
    `;
  }

  static genesis() {
    return new this('Genesis time', '------', 'f1r57-h45h', [], 0, DIFFICULTY);
  }

  static mineBlock(lastBlock, data) {
    const { hash: lastHash, difficulty: lastDifficulty } = lastBlock;

    let hash, timestamp;
    let nonce = 0;
    let difficulty = lastDifficulty;
    do {
      nonce++;
      timestamp = Date.now();
      difficulty = Block.adjustDifficulty(lastBlock, timestamp);
      hash = Block.hash(timestamp, lastHash, data, nonce, difficulty);
    } while (hash.substring(0, difficulty) !== '0'.repeat(difficulty));

    return new this(timestamp, lastHash, hash, data, nonce, difficulty);
  }

  static hash(timestamp, lastHash, data, nonce, difficulty) {
    return ChainUtil.hash(
      `${timestamp}${lastHash}${data}${nonce}${difficulty}`,
    ).toString();
  }

  static blockHash(block) {
    const { timestamp, lastHash, data, nonce, difficulty } = block;
    return Block.hash(timestamp, lastHash, data, nonce, difficulty);
  }

  static adjustDifficulty(lastBlock, currentTime) {
    const { difficulty: lastDifficulty, timestamp } = lastBlock;

    let difficulty = lastDifficulty;
    const increaser = timestamp + MINE_RATE > currentTime ? +1 : -1;
    difficulty += increaser;
    return difficulty;
  }
}

module.exports = Block;