let updateTokensLedger = ((transferFrom, fromTokenBalance, transferContents, tzip12Storage): (tokenOwner, tokenBalance, transferContents, tzip12Storage)): tzip12Storage => {
    let tokenId: tokenId = transferContents.token_id;
    let transferTo: tokenOwner = transferContents.to_;
    let transferAmount: tokenAmount = transferContents.amount;
    let tokensLedger: tokensLedger = tzip12Storage.tokensLedger;

    let tokenLookupIdFrom = (transferFrom, tokenId);
    let tokenLookupIdTo = (transferTo, tokenId);
    let balanceTo: tokenBalance = getTokenBalance((tokenId, transferTo, tzip12Storage));
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
    let tzip12Storage = {
        ...tzip12Storage,
        tokensLedger: tokensLedger
    };
    tzip12Storage
}