/** 
 * Require the first test suite in the `alphabetically` first test suite.
 * This won't be necessary once every test suite deploys it's own contract instance.
 */
require('./tzip_12.js');

const tzip_12 = artifacts.require('tzip_12');
const totalTokenSupplyRequester = artifacts.require('total_token_supply_requester');

const { initialStorage, tokenLookupIdAlice, tokenLookupIdBob, tokenId, tokenBalance } = require('../../migrations/development/tzip_12');
const constants = require('../../helpers/constants.js');
const { alice, bob } = require('../../scripts/sandbox/accounts');
const { getTokenBalance } = require('../../helpers/storage');

contract('tzip_12', () => {
    let tzip_12Storage;
    let tzip_12Instance;
    let totalTokenSupplyRequesterInstance;
    let totalTokenSupplyRequesterStorage;

    before(async () => {
        // TODO: deploy a fresh instance before each test suite
        tzip_12Instance = await tzip_12.deployed();
        totalTokenSupplyRequesterInstance = await totalTokenSupplyRequester.deployed();
        /**
         * Display the current contract address for debugging purposes
         */
        console.log('TZIP-12 contract deployed at:', tzip_12Instance.address);
        console.log('Total token supply requester contract deployed at:', totalTokenSupplyRequesterInstance.address);
        tzip_12Storage = async () => await tzip_12Instance.storage();
        totalTokenSupplyRequesterStorage = async () => await totalTokenSupplyRequesterInstance.storage();
    });

    describe('Total_supply', () => {
        it('should return return the total token supply for the requested set of tokenIDs', async () => {
            const totalTokenSupplyRequests = [
                tokenId
            ];

            await totalTokenSupplyRequesterInstance.request_total_token_supply(
                tzip_12Instance.address,
                totalTokenSupplyRequests
            )

            /**
             * TODO: Decide if we should test against the real contract storage, or initialStorage
             */
            const receivedTotalTokenSupplyResponse = (await totalTokenSupplyRequesterStorage())[0];
            const currentTzip12Storage = await tzip_12Storage();
            const currentDeployedTokenSupply = await currentTzip12Storage.total_token_supply.get(`${tokenId}`);
            assert.equal(receivedTotalTokenSupplyResponse.token_id, tokenId);
            assert(receivedTotalTokenSupplyResponse.total_supply.isEqualTo(currentDeployedTokenSupply));
        });
    });
});