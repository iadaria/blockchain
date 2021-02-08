/** Am wondering, now that the injected window.web3 is now removed as of February 2021,  
 * window.web3 Removal and window.ethereum changes
 * https://docs.metamask.io/guide/provider-migration.html
 * https://github.com/ChainSafe/web3.js
 * https://web3js.readthedocs.io/en/v1.3.0/web3-eth.html#getaccounts
 * 
*/

App = {
  loading: false,
  contracts: {},

  load: async () => {
    // Loading app...
    console.log("app loading...");
    await App.loadWeb3();
    await App.loadAccount();
  },

  loadWeb3: async() => {
    /* if (typeof web3 !== 'undefined') {
      App.web3Profider = web3.currentProivder;
      web3 = new Web3(web3.currentProivder);
    } else {
      window.alert("Please connect to Metamask.");
    } */

    // Modern dapp browsers...
    if (window.ethereum) {
      // window.web3 = new Web3(ethereum);
      let web3 = new Web3('ws://localhost:7545');
      window.web3 = web3;
      App.web3 = web3;
      console.log(App.web3);
      console.log('Yes window.ethereum');
      try {
        // Request account access if needed
        await ethereum.enable();
        console.log('access window.ethereum');
        // Accounts now exposed
        // web3.eth.sendTransaction({/* ... */});
      } catch (error) {
        console.log('User denied account access...', error);
      }
    } // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Profider = web3.currentProivder;
      window.web3 = new Web3(web3.currentProivder);
      // Account always exposed
      console.log('User denied account access...', error);
    } // Non-dapp browsers...
    else {  
      console.log('Non-Ethereum browser deteced. You should consider trying MetaMask!')
    }
  },

  loadAccount: async() => {
    App.accounts = await window.web3.eth.getAccounts();
    console.log('account is', App.accounts);
  }

}

$(() => {
  $(window).load(() => {
    App.load()
  })
})

