#include "parameter.religo"

#if FLAVOUR__NFT
#include "../transfer/flavours/nft/getTokenBalance.religo"
#endif

type balanceOfRequestsIteratorAccumulator = (list(balanceOfResponseMichelson), tzip12Storage);
let balanceOfRequestsIterator = 
    ((accumulator, balanceOfRequestMichelson): (balanceOfRequestsIteratorAccumulator, balanceOfRequestMichelson)): balanceOfRequestsIteratorAccumulator => {
        let (balanceOfResponses, tzip12Storage): balanceOfRequestsIteratorAccumulator = accumulator;
        let balanceOfRequest: balanceOfRequest = Layout.convert_from_right_comb(balanceOfRequestMichelson);
        let tokenBalance: tokenBalance = getTokenBalance((balanceOfRequest.token_id, balanceOfRequest.owner, tzip12Storage));

        let balanceOfResponseAuxiliary: balanceOfResponseAuxiliary = {
            request: balanceOfRequestMichelson,
            balance: tokenBalance
        };

        let balanceOfResponseMichelson: balanceOfResponseMichelson = Layout.convert_to_right_comb(balanceOfResponseAuxiliary: balanceOfResponseAuxiliary);
        let balanceOfResponses: list(balanceOfResponseMichelson) = [balanceOfResponseMichelson, ...balanceOfResponses];

        (balanceOfResponses, tzip12Storage);
    }

let balanceOf = ((balanceOfParameterMichelson, tzip12Storage): (balanceOfParameterMichelson, tzip12Storage)): tzip12EntrypointReturn => {
    let balanceOfParameter: balanceOfParameterAuxiliary = Layout.convert_from_right_comb(balanceOfParameterMichelson);
    let (balanceOfResponses, _): balanceOfRequestsIteratorAccumulator = List.fold(
        balanceOfRequestsIterator,
        balanceOfParameter.requests,
        (([]: list(balanceOfResponseMichelson)), tzip12Storage)
    );
    let callbackOperation: operation = Tezos.transaction(balanceOfResponses, 0tez, balanceOfParameter.callback);
    ([callbackOperation], tzip12Storage);
}