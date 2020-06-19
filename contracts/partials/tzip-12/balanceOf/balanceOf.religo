#include "parameter.religo"

#if FLAVOUR__NFT
#include "../transfer/flavours/nft/getTokenBalance.religo"
#endif

type balanceOfRequestsIteratorAccumulator = (list(balanceOfResponseMichelson), storage);
let balanceOfRequestsIterator = 
    ((accumulator, balanceOfRequestMichelson): (balanceOfRequestsIteratorAccumulator, balanceOfRequestMichelson)): balanceOfRequestsIteratorAccumulator => {
        let (balanceOfResponses, storage): balanceOfRequestsIteratorAccumulator = accumulator;
        let balanceOfRequest: balanceOfRequest = Layout.convert_from_right_comb(balanceOfRequestMichelson);
        let tokenBalance: tokenBalance = getTokenBalance((balanceOfRequest.token_id, balanceOfRequest.owner, storage));

        let balanceOfResponseAuxiliary: balanceOfResponseAuxiliary = {
            request: balanceOfRequestMichelson,
            balance: tokenBalance
        };

        let balanceOfResponseMichelson: balanceOfResponseMichelson = Layout.convert_to_right_comb(balanceOfResponseAuxiliary);
        let balanceOfResponses: list(balanceOfResponseMichelson) = [balanceOfResponseMichelson, ...balanceOfResponses];

        (balanceOfResponses, storage);
    }

let balanceOf = ((balanceOfParameterMichelson, storage): (balanceOfParameterMichelson, storage)): entrypointReturn => {
    let balanceOfParameter: balanceOfParameterAuxiliary = Layout.convert_from_right_comb(balanceOfParameterMichelson);
    let (balanceOfResponses, _): balanceOfRequestsIteratorAccumulator = List.fold(
        balanceOfRequestsIterator,
        balanceOfParameter.requests,
        (([]: list(balanceOfResponseMichelson)), storage)
    );
    let callbackOperation: operation = Tezos.transaction(balanceOfResponses, 0tez, balanceOfParameter.callback);
    ([callbackOperation], storage);
}