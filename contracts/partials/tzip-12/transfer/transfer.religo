#if FLAVOUR__NFT
#include "flavours/nft/getTokenBalance.religo"
#include "flavours/nft/updateTokensLedger.religo"
#endif

#if FLAVOUR__FT
#include "flavours/ft/getTokenBalance.religo"
#include "flavours/ft/updateTokensLedger.religo"
#endif

type transferContentsIteratorAccumulator = (storage, tokenOwner);
let transferContentsIterator = ((accumulator, transferContentsMichelson): (transferContentsIteratorAccumulator, transferContentsMichelson)): transferContentsIteratorAccumulator => {
    let (storage, from_) = accumulator;
    let transferContents: transferContents = Layout.convert_from_right_comb(transferContentsMichelson);
    let tokensLedger: tokensLedger = storage.tzip12.tokensLedger;
    let fromTokenBalance: tokenBalance = getTokenBalance((transferContents.token_id, from_, storage));

    canTransfer((from_, transferContents, storage));

    if (fromTokenBalance < transferContents.amount) {
        (failwith(errorInsufficientBalance): transferContentsIteratorAccumulator);
    } else { 
        /**
         * Apply the transfer assuming it passed the validation checks above
         */
        let storage = updateTokensLedger((from_, fromTokenBalance, transferContents, storage));
        (storage, from_);
    }
};

let transferIterator = ((storage, transferMichelson): (storage, transferMichelson)): storage => {
    let transferAuxiliary: transferAuxiliary = Layout.convert_from_right_comb(transferMichelson);
    let from_: tokenOwner = transferAuxiliary.from_;
    /**
     * Validate each transfer
     */
    let (storage, _) = List.fold(
        transferContentsIterator, 
        transferAuxiliary.txs,
        (storage, from_)
    );
    storage
};

let transfer = ((transferParameter, storage): (transferParameter, storage)): entrypointReturn => {
    let storage = List.fold(transferIterator, transferParameter, storage);
    (([]: list(operation)), storage);
};