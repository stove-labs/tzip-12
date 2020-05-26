type transferContentsIteratorAccumulator = (storage, tokenOwner);
let transferContentsIterator = ((accumulator, transferContentsMichelson): (transferContentsIteratorAccumulator, transferContentsMichelson)): transferContentsIteratorAccumulator => {
    let (storage, from_) = accumulator;
    let transferContents: transferContents = Layout.convert_from_right_comb(transferContentsMichelson);
    let tokenOwners: tokenOwners = storage.tokenOwners;
    /**
     * If a `tokenOwner` exists for a `token_id`, 
     * consider the `token_id` to be valid/existing for the current instance.
     * 
     * At the same time, each `token_id` is associated with only one `tokenOwner`,
     * this logic simultaneously concludes a balance validity check as well.
     */
    let tokenOwner: option(tokenOwner) = Map.find_opt(transferContents.token_id, tokenOwners);
    let tokenOwner = switch (tokenOwner) {
        | None => (failwith(errorTokenUndefined): tokenOwner)
        /**
         * If the existing `tokenOwner` for the given `token_id`
         * does not equal the provided `from_` address, then fail.
         */
        | Some(tokenOwner) => if (tokenOwner == from_) {
                tokenOwner
            } else {
                (failwith(errorInsufficientBalance): tokenOwner);
            }
    };
    /**
     * Apply the transfer assuming it passed the validation checks above
     */
    let tokenOwners = Map.update(
        // which `token_id` to update
        transferContents.token_id,
        // new `tokenOwner` for the `token_id` above
        Some(transferContents.to_),
        tokenOwners
    );
    let storage = {
        ...storage,
        tokenOwners: tokenOwners
    };
    (storage, from_)
};

/**
 * While the transfer configuration policies are not implemented,
 * allow only `owner` transfer a.k.a. from the `Tezos.sender` address.
 */
let allowOnlyOwnTransfer = (from: tokenOwner): unit => {
    if (from != Tezos.sender) {
        failwith(errorNotOwner)
    } else { (); }
}

let transferIterator = ((storage, transferMichelson): (storage, transferMichelson)): storage => {
    let transferAuxiliary: transferAuxiliary = Layout.convert_from_right_comb(transferMichelson);
    let from_: tokenOwner = transferAuxiliary.from_;
    allowOnlyOwnTransfer(from_);
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