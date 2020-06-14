const { MichelsonMap, UnitValue } = require('@taquito/taquito');
const tzip12Nft = artifacts.require('tzip-12-nft-big-map');
const { alice, bob } = require('../scripts/sandbox/accounts');
const saveContractAddress = require('../helpers/saveContractAddress');

/**
 * Initial storage for the NFT implementation flavour
 */
const initialStorage = {
    tokenOwners: MichelsonMap.fromLiteral({
        // tokenId: tokenOwner
        0: alice.pkh,
        1: bob.pkh
    }),
    u: UnitValue
};

/**
 * Deploy an NFT-optimized TZIP-12 contract
 */
module.exports = async (deployer) => {
    deployer.deploy(tzip12Nft, initialStorage)
        .then(({ address }) => saveContractAddress('tzip-12-nft-big-map', address));
}
module.exports.initialStorage = initialStorage;