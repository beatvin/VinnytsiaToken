const fs = require('fs');

const mnemonic = fs.readFileSync('mnemonic.json','utf-8');

const HDWalletProvider = require('@truffle/hdwallet-provider');
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "5777"
    },
    goerli: {
      network_id: "5",
      gasPrice: 10000000000,
      provider: new HDWalletProvider(mnemonic, "https://goerli.infura.io/v3/bdc7f317cedb484da4d3953c54344944"),
      from: '0x5Dd1187ab3f21eFc415acE15d9f94d043948ed7F'
    }
  },
  mocha: {},
  compilers: {
    solc: {
      version: "0.8.17"
    }
  }
};