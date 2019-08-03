const path = require("path");
const HDWalletProvider = require('truffle-hdwallet-provider')
require('dotenv').config()

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    develop: {
          provider() {
            return new HDWalletProvider(
              process.env.TRUFFLE_MNEMONIC,
              'http://localhost:9545/'
            )
          },
          provider: () =>
          new HDWalletProvider(
            process.env.TRUFFLE_MNEMONIC,
            'http://localhost:9545/'
          ),
          host: 'localhost',
          port: 9545,
          network_id: 4447
        }

  }
};
