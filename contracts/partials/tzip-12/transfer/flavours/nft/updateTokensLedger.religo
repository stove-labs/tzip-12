let updateTokensLedger = ((from, fromTokenBalance, transferContents, tzip12Storage): (tokenOwner, tokenBalance, transferContents, tzip12Storage)): tzip12Storage => {
    let tokensLedger = setTokenBalance(
        transferContents.token_id,
        transferContents.to_,
        0n, // nat balance is irelevant for NFTs
        tzip12Storage  
    );
    let tzip12Storage = {
        ...tzip12Storage,
        tokensLedger: tokensLedger
    };
    tzip12Storage
};