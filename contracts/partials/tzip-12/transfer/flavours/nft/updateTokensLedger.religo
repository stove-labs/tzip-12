let updateTokensLedger = ((from, fromTokenBalance, transferContents, tzip12Storage): (tokenOwner, tokenBalance, transferContents, tzip12Storage)): tzip12Storage => {
    let tokensLedger = Map.update(
        // which `token_id` to update
        transferContents.token_id,
        // new `tokenOwner` for the `token_id` above
        Some(transferContents.to_),
        tzip12Storage.tokensLedger
    );
    let tzip12Storage = {
        ...tzip12Storage,
        tokensLedger: tokensLedger
    };
    tzip12Storage
};