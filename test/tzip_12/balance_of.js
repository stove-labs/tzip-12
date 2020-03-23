/** 
 * Require the first test suite in the `alphabetically` first test suite.
 * This won't be necessary once every test suite deploys it's own contract instance.
 */
require('./tzip_12.js');

const tzip_12 = artifacts.require('tzip_12');
const balanceRequester = artifacts.require('balance_requester');

const { initialStorage, tokenLookupIdAlice, tokenLookupIdBob, tokenId, tokenBalance } = require('../../migrations/development/tzip_12');
const constants = require('../../helpers/constants.js');
const { alice, bob } = require('../../scripts/sandbox/accounts');
const { getTokenBalance } = require('../../helpers/storage');

contract('tzip_12', () => {
    let tzip_12Storage;
    let balanceRequesterStorage;
    let tzip_12Instance;
    let balanceRequesterInstance;
    let expectedBalanceAlice;
    let expectedBalanceBob = 0;

    before(async () => {
        // TODO: deploy a fresh instance before each test suite
        tzip_12Instance = await tzip_12.deployed();
        balanceRequesterInstance = await balanceRequester.deployed();
        /**
         * Display the current contract address for debugging purposes
         */
        console.log('TZIP-12 contract deployed at:', tzip_12Instance.address);
        console.log('Balance requester contract deployed at:', balanceRequesterInstance.address);
        tzip_12Storage = async () => await tzip_12Instance.storage();
        balanceRequesterStorage = async () => await balanceRequesterInstance.storage();
        expectedBalanceAlice = await getTokenBalance(tokenLookupIdAlice, tzip_12Storage);
    });

    describe('Balance_of', () => {
        it('should return a balance for the requested list of token_owner and token_ids', async () => {
            const balanceRequests = [
                {
                    owner: alice.pkh,
                    token_id: tokenId
                }
            ];
            await balanceRequesterInstance.request_balance(
                tzip_12Instance.address,
                balanceRequests
            );

            const currentBalanceRequesterStorage = await balanceRequesterStorage();
            const receivedBalanceOfAddress = currentBalanceRequesterStorage[0].request.owner;
            const receivedBalanceOfAlice = currentBalanceRequesterStorage[0].balance;
            assert.equal(receivedBalanceOfAddress, alice.pkh);
            /* TODO: why is this a BigNum? */
            assert(receivedBalanceOfAlice.isEqualTo(expectedBalanceAlice));
            assert.equal(currentBalanceRequesterStorage.length, balanceRequests.length);
        });

        it('should return a balance of 0 for a non existing address in the ledger', async () => {
            const balanceRequests = [
                {
                    owner: bob.pkh,
                    token_id: tokenId
                }
            ];
            await balanceRequesterInstance.request_balance(
                tzip_12Instance.address,
                balanceRequests
            );

            const currentBalanceRequesterStorage = await balanceRequesterStorage();
            const receivedBalanceOfAddress = currentBalanceRequesterStorage[0].request.owner;
            const receivedBalanceOfBob = currentBalanceRequesterStorage[0].balance;
            assert.equal(receivedBalanceOfAddress, bob.pkh);
            assert(receivedBalanceOfBob.isEqualTo(expectedBalanceBob));
            assert.equal(currentBalanceRequesterStorage.length, balanceRequests.length);
        });

        it('should return appropriate balances for a batch balance_of request', async () => {
            const balanceRequests = [
                {
                    owner: alice.pkh,
                    token_id: tokenId
                },
                {
                    owner: bob.pkh,
                    token_id: tokenId
                }
            ];
            await balanceRequesterInstance.request_balance(
                tzip_12Instance.address,
                balanceRequests
            );

            const currentBalanceRequesterStorage = await balanceRequesterStorage();
            
            /**
             * Smarter way to write this test would be to find the matching response to a request
             * by looking up the required address in the responses array
             */

            /**
             * Check balance for the first item in the responses array, which is supposed to be Alice
             */
            const receivedBalanceOfAddressAlice = currentBalanceRequesterStorage[0].request.owner;
            const receivedBalanceOfAlice = currentBalanceRequesterStorage[0].balance;

            assert.equal(receivedBalanceOfAddressAlice, alice.pkh);
            assert(receivedBalanceOfAlice.isEqualTo(expectedBalanceAlice));

            /**
             * Check balance for the second item in the responses array, which is supposed to be Bob
             */
            const receivedBalanceOfAddressBob = currentBalanceRequesterStorage[1].request.owner;
            const receivedBalanceOfBob = currentBalanceRequesterStorage[1].balance;
            
            assert.equal(receivedBalanceOfAddressBob, bob.pkh);
            assert(receivedBalanceOfBob.isEqualTo(expectedBalanceBob));

            assert.equal(currentBalanceRequesterStorage.length, balanceRequests.length);
        });
    });
});