let setTokenBalance = ((tokenId, tokenOwner, tokenBalance, tzip12Storage): (tokenId, tokenOwner, tokenBalance, tzip12Storage)): tokensLedger => {
    let tokensLedger: tokensLedger = tzip12Storage.tokensLedger;
    let tokenLookupId: tokenLookupId = (tokenOwner, tokenId);
    Map.update(
        tokenLookupId,
        Some(tokenBalance),
        tokensLedger
    );
}