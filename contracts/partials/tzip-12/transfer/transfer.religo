#if FLAVOUR__NFT
#include "flavours/nft/getTokenBalance.religo"
#include "flavours/nft/updateTokensLedger.religo"
#endif

#if FLAVOUR__FT
#include "flavours/ft/getTokenBalance.religo"
#include "flavours/ft/updateTokensLedger.religo"
#endif

type transferContentsIteratorAccumulator = (tzip12Storage, tokenOwner);
let transferContentsIterator = ((accumulator, transferContentsMichelson): (transferContentsIteratorAccumulator, transferContentsMichelson)): transferContentsIteratorAccumulator => {
    let (tzip12Storage, from_) = accumulator;
    let transferContents: transferContents = Layout.convert_from_right_comb(transferContentsMichelson);
    let tokensLedger: tokensLedger = tzip12Storage.tokensLedger;
    let fromTokenBalance: tokenBalance = getTokenBalance((transferContents.token_id, from_, tzip12Storage));

    canTransfer((from_, transferContents, tzip12Storage));

    if (fromTokenBalance < transferContents.amount) {
        (failwith(errorInsufficientBalance): transferContentsIteratorAccumulator);
    } else { 
        /**
         * Apply the transfer assuming it passed the validation checks above
         */
        let tzip12Storage = updateTokensLedger((from_, fromTokenBalance, transferContents, tzip12Storage));
        (tzip12Storage, from_);
    }
};

let transferIterator = ((tzip12Storage, transferMichelson): (tzip12Storage, transferMichelson)): tzip12Storage => {
    let transferAuxiliary: transferAuxiliary = Layout.convert_from_right_comb(transferMichelson);
    let from_: tokenOwner = transferAuxiliary.from_;
    /**
     * Validate each transfer
     */
    let (tzip12Storage, _) = List.fold(
        transferContentsIterator, 
        transferAuxiliary.txs,
        (tzip12Storage, from_)
    );
    tzip12Storage
};

let transfer = ((transferParameter, tzip12Storage): (transferParameter, tzip12Storage)): tzip12EntrypointReturn => {
    let tzip12Storage = List.fold(transferIterator, transferParameter, tzip12Storage);
    (([]: list(operation)), tzip12Storage);
};