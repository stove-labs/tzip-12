
const balance_requester = artifacts.require('total_token_supply_requester');

module.exports = async (deployer, network, accounts) => {
    /**
     * Load the network specific initial storage for the migration
     */
    const { initialStorage } = require(`./${network}/total_token_supply_requester`);
    await deployer.deploy(balance_requester, initialStorage);
};