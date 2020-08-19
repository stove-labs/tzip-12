const tzip12Ft = artifacts.require('tzip-12-ft-tablespoon');
const saveContractAddress = require('../helpers/saveContractAddress');
const tzip12FTInitialStorage = require('./initialStorage/tzip-12-ft');

/**
 * Deploy an NFT-optimized TZIP-12 contract
 */
module.exports = async (deployer) => {
    await deployer.deploy(tzip12Ft, tzip12FTInitialStorage.withOperators)
        .then(({ address }) => saveContractAddress('tzip-12-ft-teaspoon', address));
}
module.exports.initialStorage = tzip12FTInitialStorage.withOperators;