let setTokenBalance = ((tokenId, tokenOwner, tokenBalance, tzip12Storage): (tokenId, tokenOwner, tokenBalance, tzip12Storage)): tokensLedger => {
    let tokensLedger: tokensLedger = tzip12Storage.tokensLedger;
    Map.update(
        tokenId,
        Some(tokenOwner),
        tokensLedger
    );
}