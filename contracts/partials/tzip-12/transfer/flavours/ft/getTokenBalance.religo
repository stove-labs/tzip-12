let defaultBalance: tokenBalance = 0n;

let getTokenBalance = ((tokenId, tokenOwner, storage): (tokenId, tokenOwner, storage)): tokenBalance => {
    let tokensLedger: tokensLedger = storage.tzip12.tokensLedger;
    let tokenLookupId: tokenLookupId = (tokenOwner, tokenId);
    let tokenBalance: option(tokenBalance) = Map.find_opt(tokenLookupId, tokensLedger);
    switch (tokenBalance) {
        | None => defaultBalance
        | Some(tokenBalance) => tokenBalance
    }
}