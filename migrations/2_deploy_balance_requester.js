const balance_requester = artifacts.require('balance_requester');

module.exports = async (deployer, network, accounts) => {
    /**
     * Load the network specific initial storage for the migration
     */
    const { initialStorage } = require(`./${network}/balance_requester`);
    await deployer.deploy(balance_requester, initialStorage);
};