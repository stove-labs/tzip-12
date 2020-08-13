type tokenMintContentsIteratorAccumulator = tzip12Storage;
let tokenMintContentsIterator = ((tzip12Storage, tokenMintContentsMichelson): (tokenMintContentsIteratorAccumulator, tokenMintContentsMichelson)): tokenMintContentsIteratorAccumulator => {
    let tokenMintContents: tokenMintContents = Layout.convert_from_right_comb(tokenMintContentsMichelson);
    canMint((tokenMintContents, tzip12Storage));
    
    let currentBalance = getTokenBalance((
        tokenMintContents.token_id,
        tokenMintContents.to_,
        tzip12Storage
    ));

    let tokensLedger = setTokenBalance((
        tokenMintContents.token_id,
        tokenMintContents.to_,
        currentBalance + tokenMintContents.amount,
        tzip12Storage
    ));

    let tzip12Storage = {
        ...tzip12Storage,
        tokensLedger: tokensLedger
    };
    tzip12Storage
}

let mint = ((tokenMintParameter, tzip12Storage): (tokenMintParameter, tzip12Storage)) => {
    let tzip12Storage: tzip12Storage = List.fold(
        tokenMintContentsIterator,
        tokenMintParameter,
        tzip12Storage
    );

    (([]: list(operation)), tzip12Storage);
};