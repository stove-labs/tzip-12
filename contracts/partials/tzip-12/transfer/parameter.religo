#include "../storage/types.religo"

/**
 * Types used within the contract for development purposes
 */
type transferContents = {
    to_: tokenOwner,
    token_id: tokenId,
    amount: tokenAmount
};

type transfer = {
    from_: tokenOwner,
    txs: list(transferContents)
};

/**
 * Concrete parameter type definitions with
 * their Michelson representations.
 */
type transferContentsMichelson = michelson_pair_right_comb(transferContents);

type transferAuxiliary = {
    from_: tokenOwner,
    txs: list(transferContentsMichelson)
};

type transferMichelson = michelson_pair_right_comb(transferAuxiliary);

type transferParameter = list(transferMichelson);
