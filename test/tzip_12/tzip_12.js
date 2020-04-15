const tzip_12 = artifacts.require('tzip_12');

const { initialStorage, tokenLookupIdAlice, tokenLookupIdBob, tokenId, tokenBalance } = require('../../migrations/development/tzip_12');
const bigMapKeyNotFound = require('../../helpers/bigMapKeyNotFound.js');
const constants = require('../../helpers/constants.js');
const { alice, bob } = require('../../scripts/sandbox/accounts');
const { getTokenBalance } = require('../../helpers/storage');


contract('tzip_12', () => {
    let storage;
    let tzip_12_instance;
    let expectedBalanceAlice;

    before(async () => {
        // TODO: deploy a fresh instance before each test suite
        tzip_12_instance = await tzip_12.deployed();
        /**
         * Display the current contract address for debugging purposes
         */
        console.log('Contract deployed at:', tzip_12_instance.address);
        storage = async () => await tzip_12_instance.storage();
        expectedBalanceAlice = await getTokenBalance(tokenLookupIdAlice, initialStorage);
    });

    it(`should store a balance equal to the initialStorage value for Alice`, async () => {
        /**
         * Get balance for Alice from the smart contract's storage (by a big map lookup id)
         */
        const deployedBalanceAlice = await getTokenBalance(tokenLookupIdAlice, storage);
        assert(deployedBalanceAlice.isEqualTo(expectedBalanceAlice));
    });

    it(`should not store any balance for Bob`, async () => {
        let fetchBalanceError;

        try {
            /**
             * If a big map key does not exist in the storage, the RPC returns a 404 HttpResponseError
             */
            await getTokenBalance(tokenLookupIdBob, storage);
        } catch (e) {
            fetchBalanceError = e;
        }

        assert(bigMapKeyNotFound(fetchBalanceError))
    });

});
