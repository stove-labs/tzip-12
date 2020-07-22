/**
 * If a `tokenOwner` exists for a `token_id`, 
 * consider the `token_id` to be valid/existing for the current instance.
 * 
 * At the same time, each `token_id` is associated with only one `tokenOwner`,
 * this logic simultaneously concludes a balance validity check as well.
 */
let defaultBalance: tokenBalance = 1n;
let defaultBalanceNoToken: tokenBalance = 0n;

let getTokenBalance = ((tokenId, tokenOwner, tzip12Storage): (tokenId, tokenOwner, tzip12Storage)): tokenBalance => {
    let tokensLedger: tokensLedger = tzip12Storage.tokensLedger;
    let existingTokenOwner: option(tokenOwner) = Map.find_opt(tokenId, tokensLedger);
    switch (existingTokenOwner) {
        | None => (failwith(errorTokenUndefined): tokenBalance)
        /**
         * If the existing `tokenOwner` for the given `token_id`
         * does not equal the provided `from_` address, then fail.
         */
        | Some(existingTokenOwner) => if (tokenOwner == existingTokenOwner) {
            defaultBalance;
        } else {
            defaultBalanceNoToken;
        }
    };
}