let updateTokensLedger = ((transferFrom, fromTokenBalance, transferContents, storage): (tokenOwner, tokenBalance, transferContents, storage)): storage => {
    let tokenId: tokenId = transferContents.token_id;
    let transferTo: tokenOwner = transferContents.to_;
    let transferAmount: tokenAmount = transferContents.amount;
    let tokensLedger: tokensLedger = storage.tokensLedger;

    let tokenLookupIdFrom = (transferFrom, tokenId);
    let tokenLookupIdTo = (transferTo, tokenId);
    let balanceTo: tokenBalance = getTokenBalance((tokenId, transferTo, storage));
    // update balance from
    let tokensLedger = Map.update(
        tokenLookupIdFrom,
        Some(abs(fromTokenBalance - transferAmount)),
        tokensLedger
    );
    // update balance to
    let tokensLedger = Map.update(
        tokenLookupIdTo,
        Some(balanceTo + transferAmount),
        tokensLedger
    );
    let storage = {
        ...storage,
        tokensLedger: tokensLedger
    };
    storage
}