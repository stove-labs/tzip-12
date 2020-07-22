let defaultBalance: tokenBalance = 0n;

let getTokenBalance = ((tokenId, tokenOwner, tzip12Storage): (tokenId, tokenOwner, tzip12Storage)): tokenBalance => {
    let tokensLedger: tokensLedger = tzip12Storage.tokensLedger;
    let tokenLookupId: tokenLookupId = (tokenOwner, tokenId);
    let tokenBalance: option(tokenBalance) = Map.find_opt(tokenLookupId, tokensLedger);
    switch (tokenBalance) {
        | None => defaultBalance
        | Some(tokenBalance) => tokenBalance
    }
}