const { MichelsonMap, UnitValue } = require('@taquito/taquito');
const tzip12Nft = artifacts.require('tzip-12-nft-tablespoon');
const { alice, bob } = require('../scripts/sandbox/accounts');
const saveContractAddress = require('../helpers/saveContractAddress');

/**
 * Initial storage for the NFT implementation flavour
 */
const initialStorage = {
    tokensLedger: MichelsonMap.fromLiteral({
        // tokenId: tokenOwner
        0: alice.pkh,
        1: bob.pkh
    }),
    tokenOperators: MichelsonMap.fromLiteral({
        [`${bob.pkh}`]: [alice.pkh]
    }),
    token_metadata: new MichelsonMap,
    u: UnitValue
};

/**
 * Deploy an NFT-optimized TZIP-12 contract
 */
module.exports = async (deployer) => {
    await deployer.deploy(tzip12Nft, initialStorage)
        .then(({ address }) => saveContractAddress('tzip-12-nft-tablespoon', address));
}
module.exports.initialStorage = initialStorage;