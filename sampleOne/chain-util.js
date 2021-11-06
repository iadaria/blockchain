const EC = require('elliptic').ec;
const uuid = require('uuid');
const ec = new EC('secp256k1');

class ChainUtil {
  static genKeyPair() {
    return ec.genKeyPair();
  }

  static id() {
    return uuid.v1();
  }
}

module.exports = ChainUtil;
