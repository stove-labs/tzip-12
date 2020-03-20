const tzip_12 = artifacts.require('tzip_12');

module.exports = async (deployer, network, accounts) => {
    /**
     * Load the network specific initial storage for the migration
     */
    const { initialStorage } = require(`./${network}/tzip_12`);
    await deployer.deploy(tzip_12, initialStorage);
};