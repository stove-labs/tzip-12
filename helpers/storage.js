/**
 * Set of helper functions to abstract/read the current contract storage
 *
 * `storage()` is always provided as an async function, 
 * in order to always fetch/obtain the latest storage from the RPC.
 */
const getTokenBalances = async (storage) => (await storage()).token_balances
const getTokenBalance = async (tokenLookupId, storage) => (await getTokenBalances(storage)).get(tokenLookupId)

module.exports = {
    getTokenBalances,
    getTokenBalance
};