/** 
 * Require the first test suite in the `alphabetically` first test suite.
 * This won't be necessary once every test suite deploys it's own contract instance.
 */
require('./../tzip_12.js');

const tzip_12 = artifacts.require('tzip_12');

const { initialStorage, tokenLookupIdAlice, tokenLookupIdBob, tokenId, tokenBalance } = require('../../../migrations/development/tzip_12');
const constants = require('../../../helpers/constants.js');
const { alice, bob } = require('../../../scripts/sandbox/accounts');
const { getTokenBalance } = require('../../../helpers/storage');

contract('tzip_12', () => {
    let tzip_12Storage;
    let tzip_12Instance;

    before(async () => {
        // TODO: deploy a fresh instance before each test suite
        tzip_12Instance = await tzip_12.deployed();
        /**
         * Display the current contract address for debugging purposes
         */
        console.log('TZIP-12 contract deployed at:', tzip_12Instance.address);
        tzip_12Storage = async () => await tzip_12Instance.storage();
    });

    describe('Token operators', () => {
        describe('Update token operators', () => {
            it.only('should add a new operator with access to all owner tokens', async () => {
                await tzip_12Instance.update_operators([{
                    'add_operator': {
                        owner: alice.pkh,
                        operator: bob.pkh,
                        tokens: {
                            'all_tokens': constants.unit
                        }
                    }
                }]);
            });
        });
    })
});