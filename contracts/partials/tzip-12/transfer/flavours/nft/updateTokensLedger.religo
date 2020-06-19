let updateTokensLedger = ((from, fromTokenBalance, transferContents, storage): (tokenOwner, tokenBalance, transferContents, storage)): storage => {
    let tokensLedger = Map.update(
        // which `token_id` to update
        transferContents.token_id,
        // new `tokenOwner` for the `token_id` above
        Some(transferContents.to_),
        storage.tokensLedger
    );
    let storage = {
        ...storage,
        tokensLedger: tokensLedger
    };
    storage
};