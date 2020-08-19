const tzip12Nft = artifacts.require('tzip-12-nft-teaspoon');
const saveContractAddress = require('../helpers/saveContractAddress');
const tzip12NFTInitialStorage = require('./initialStorage/tzip-12-nft-big-map');

/**
 * Deploy an NFT-optimized TZIP-12 contract
 */
module.exports = async (deployer) => {
    await deployer.deploy(tzip12Nft, tzip12NFTInitialStorage.withOperators)
        .then(({ address }) => saveContractAddress('tzip-12-nft-teaspoon', address));
}
module.exports.initialStorage = tzip12NFTInitialStorage.withOperators;