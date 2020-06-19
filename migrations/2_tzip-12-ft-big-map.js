const { MichelsonMap, UnitValue } = require('@taquito/taquito');
const tzip12Ft = artifacts.require('tzip-12-ft-tablespoon');
const { alice, bob } = require('../scripts/sandbox/accounts');
const saveContractAddress = require('../helpers/saveContractAddress');

/**
 * Initial storage for the FT implementation flavour
 */
const initialStorage = {
    tokensLedger: new MichelsonMap,
    tokenOperators: MichelsonMap.fromLiteral({
        [`${bob.pkh}`]: [alice.pkh]
    }),
    u: UnitValue
};

initialStorage.tokensLedger.set([alice.pkh, '0'], 10);

/**
 * Deploy an NFT-optimized TZIP-12 contract
 */
module.exports = async (deployer) => {
    await deployer.deploy(tzip12Ft, initialStorage)
        .then(({ address }) => saveContractAddress('tzip-12-ft-tablespoon', address));
}
module.exports.initialStorage = initialStorage;