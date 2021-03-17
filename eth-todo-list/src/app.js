// var contract = require("@truffle/contract");
/** Am wondering, now that the injected window.web3 is now removed as of February 2021,  
 * window.web3 Removal and window.ethereum changes
 * https://docs.metamask.io/guide/provider-migration.html
 * https://github.com/ChainSafe/web3.js
 * https://web3js.readthedocs.io/en/v1.3.0/web3-eth.html#getaccounts
 * 
*/
// var TruffleContract = require("@truffle/contract");

App = {
  loading: false,
  contracts: {},

  load: async () => {
    // Loading app...
    console.log("app loading...");
    await App.loadWeb3();
    await App.loadAccount();
    await App.loadContract();
    await App.render();
  },

  loadWeb3: async() => {
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
    } 
    else {  
      console.log('Non-Ethereum browser deteced. You should consider trying MetaMask!')
    }
  },

  loadAccount: async() => {
    let accounts = await window.web3.eth.getAccounts();
    App.account = accounts[0];
    console.log('account', App.account);
  },

  loadContract: async() => {
    const todoList = await $.getJSON('TodoList.json');
    console.log(todoList);
    App.contracts.TodoList = TruffleContract(todoList);
    App.contracts.TodoList.setProvider(App.web3.currentProvider);

    // Hydrate the smart contract with values from the blockchain
    App.todoList = await App.contracts.TodoList.deployed();
  },

  renderTasks: async () => {
    // Load the total task count from the blockchain
    const taskCount = await App.todoList.taskCount();
    const $taskTemplate = $('.taskTemplate');

    console.log(taskCount);
    // Render out each task with a new task template
    // for(let i = 1; i <= taskCount; i++) {
    //   // Fetch the task data from the blockchain
    //   const task = await App.todoList.tasks(i);
    //   const taskId = task[0].toNumber();
    //   const taskContent = task[1]
    //   const taskCompleted = task[2];

    //   // Create the html for the task
    //   const $newTaskTemplate = $taskTemplate.clone();
    //   $newTaskTemplate.find('.content').html(taskContent);
    //   $newTaskTemplate.find('.input')
    //     .prop('name', taskId)
    //     .prop('checked', taskCompleted);
    //     //.on('click', App.toggleCompleted)

    //   // Put the task in the correct list
    //   if (taskCompleted) {
    //     $('#completedTaskList').append($newTaskTemplate);
    //   } else {
    //     $('#taskList').append($newTaskTemplate);
    //   }
    // }

    // // Show the task
    // $newTaskTemplate.show();
  },

  render: async () => {
    // Prevent double render
    if (App.loading) {
      return;
    }

    // Update app loading state
    App.setLoading(true);

    $('#account').html(App.account);

    // Render Tasks
    await App.renderTasks();

    // Update loading state
    App.setLoading(false);
  },

  setLoading: (isLoading) => {
    App.loading = isLoading;
    const loader = $('#loader');
    const content = $('#content');
    if (isLoading) {
      loader.show();
      content.hide();
    } else {
      loader.hide();
      content.show();
    }
  }

}

$(() => {
  $(window).load(() => {
    App.load()
  })
})

