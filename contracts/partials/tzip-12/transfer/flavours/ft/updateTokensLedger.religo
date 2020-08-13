let updateTokensLedger = ((transferFrom, fromTokenBalance, transferContents, tzip12Storage): (tokenOwner, tokenBalance, transferContents, tzip12Storage)): tzip12Storage => {
    let tokenId: tokenId = transferContents.token_id;
    let transferTo: tokenOwner = transferContents.to_;
    let transferAmount: tokenAmount = transferContents.amount;
    let tokensLedger: tokensLedger = tzip12Storage.tokensLedger;

    // TODO: obtain balanceFrom here as well rather than from the function arguments
    let balanceTo: tokenBalance = getTokenBalance((tokenId, transferTo, tzip12Storage));
    
    let tokensLedger = setTokenBalance((
        tokenId,
        transferFrom,
        abs(fromTokenBalance - transferAmount),
        tzip12Storage
    ));

    let tokensLedger = setTokenBalance((
        tokenId,
        transferTo,
        balanceTo + transferAmount,
        tzip12Storage
    ));

    let tzip12Storage = {
        ...tzip12Storage,
        tokensLedger: tokensLedger
    };
    tzip12Storage
}