/**
 * Calculates the current totalTokenSupply based on 
 * the balances found in the provided storage
 */
module.exports.calculateTotalTokenSupply = (storage) => {
    let totalTokenSupply = 0;
    storage.token_balances.forEach((tokenBalance, tokenOwner) => {
        totalTokenSupply += tokenBalance;
    });
    return totalTokenSupply;
};
