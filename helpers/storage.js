const getTokenBalances = (storage) => storage.token_balances
const getTokenBalance = async (tokenLookupId, storage) => await getTokenBalances(storage).get(tokenLookupId)
module.exports = {
    getTokenBalances,
    getTokenBalance
};