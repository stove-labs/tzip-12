const tzip_12 = artifacts.require('tzip_12');

const { initialStorage, tokenLookupIdAlice, tokenLookupIdBob, tokenId, tokenBalance } = require('../../migrations/development/tzip_12');
const bigMapKeyNotFound = require('../../helpers/bigMapKeyNotFound.js');
const constants = require('../../helpers/constants.js');
const { alice, bob } = require('../../scripts/sandbox/accounts');
const { getTokenBalance } = require('../../helpers/storage');

contract('tzip_12', (accounts) => {
    let storage;
    let tzip_12_instance;
    let expectedBalanceAlice;

    before(async () => {
        tzip_12_instance = await tzip_12.deployed();
        /**
         * Display the current contract address for debugging purposes
         */
        console.log('Contract deployed at:', tzip_12_instance.address);
        storage = await tzip_12_instance.storage();
        expectedBalanceAlice = await getTokenBalance(tokenLookupIdAlice, initialStorage);
    });

    it(`should store a balance of ${expectedBalanceAlice} for Alice`, async () => {
        /**
         * Get balance for Alice from the smart contract's storage (by a big map lookup id)
         */
        const deployedBalanceAlice = await getTokenBalance(tokenLookupIdAlice, storage);
        assert.equal(expectedBalanceAlice, deployedBalanceAlice);
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

    it('should transfer 1 token from Alice to Bob', async () => {
        const transferParam = [
            {   
                /**
                 * token_id: 0 represents the single token_id within our contract
                 */
                token_id: 0,
                amount: 1,
                from_: alice.pkh,
                to_: bob.pkh
            }
        ];
        
        /**
         * Call the `transfer` entrypoint
         */
        await tzip_12_instance.transfer(transferParam);
        /**
         * Bob's token balance should now be 1
         */
        const deployedBalanceBob = await getTokenBalance(tokenLookupIdBob, storage);
        const expectedBalanceBob = 1;
        assert.equal(deployedBalanceBob, expectedBalanceBob);
    });

    it(`should not allow transfers from_ an address that did not sign the transaction`, async () => {
        const transferParam = [
            {   
                token_id: 0,
                amount: 1,
                from_: bob.pkh,
                to_: alice.pkh
            }
        ];

        try {
            /**
             * Transactions in the test suite are signed by a secret/private key
             * configured in truffle-config.js
             */
            await tzip_12_instance.transfer(transferParam);
        } catch (e) {
            assert.equal(e.message, constants.contractErrors.transferInvalidPermissions)
        }
    });

    it(`should not transfer tokens from Alice to Bob when Alice's balance is insufficient`, async () => {
        const transferParam = [
            {   
                token_id: 0,
                // Alice's balance at this point is 9
                amount: 100,
                from_: alice.pkh,
                to_: bob.pkh
            }
        ];

        try {
            await tzip_12_instance.transfer(transferParam);
        } catch (e) {
            assert.equal(e.message, constants.contractErrors.transferInvalidInsufficientBalance)
        }
    });

});
