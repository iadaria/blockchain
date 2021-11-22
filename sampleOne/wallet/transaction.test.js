const Transaction = require('./transaction');
const Wallet = require('./index');

describe('Transaction', () => {
  let transaction, wallet, recipient, amount;

  beforeEach(() => {
    wallet = new Wallet();
    amount = 50;
    recipient = 'r3c1p13nt';
    transaction = Transaction.newTransaction(wallet, recipient, amount);
  });

  it('outputs the `amount` subtracted from the wallet balance', () => {
    const f = transaction.outputs.find(
      output => output.address === wallet.publicKey,
    );
    expect(f.amount).toEqual(wallet.balance - amount);
  });

  it('outputs the `amount` added to the recipient', () => {
    const found = transaction.outputs.find(
      output => output.address === recipient,
    ).amount;
    expect(found).toEqual(amount);
  });

  it('inputs the balance of the wallet', () => {
    expect(transaction.input.amount).toEqual(wallet.balance);
  });

  it('validates a valid transaction', () => {
    const t = Transaction.verifyTransaction(transaction);
    expect(t).toBe(true);
  });

  it('validates a corrupt transaction', () => {
    transaction.outputs[0].amount = 50000;
    expect(Transaction.verifyTransaction(transaction)).toBe(false);
  });

  describe('transacting with an amount that exceeds the balance', () => {
    beforeEach(() => {
      amount = 50000;
      transaction = Transaction.newTransaction(wallet, recipient, amount);
    });

    it('does not create the transaction', () => {
      expect(transaction).toEqual(undefined);
    });
  });

  describe('and updating a transaction', () => {
    let nextAmount, nextRecipient;

    beforeEach(() => {
      nextAmount = 20;
      nextRecipient = 'n3xt-address';
      transaction = transaction.update(wallet, nextRecipient, nextAmount);
    });

    it('subracts the next amount from the senders output', () => {
      expect(
        transaction.outputs.find(o => o.address === wallet.publicKey).amount,
      ).toEqual(wallet.balance - amount - nextAmount);
    });

    it('outputs an amount for the next recipient', () => {
      expect(
        transaction.outputs.find(o => o.address === nextRecipient).amount,
      ).toEqual(nextAmount);
    });
  });
});
