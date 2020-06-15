#include "../parameter.religo"

let defaultTokenBalance: tokenBalance = 1n;

type balanceOfRequestsIteratorAccumulator = (list(balanceOfResponseMichelson), storage);
let balanceOfRequestsIterator = 
    ((accumulator, balanceOfRequestMichelson): (balanceOfRequestsIteratorAccumulator, balanceOfRequestMichelson)): balanceOfRequestsIteratorAccumulator => {
        let (balanceOfResponses, storage): balanceOfRequestsIteratorAccumulator = accumulator;
        let balanceOfRequest: balanceOfRequest = Layout.convert_from_right_comb(balanceOfRequestMichelson);
        let tokenOwner: option(tokenOwner) = Map.find_opt(balanceOfRequest.token_id, storage.tokenOwners);
        let tokenBalance: tokenBalance = switch (tokenOwner) {
            | None => (failwith(errorTokenUndefined): tokenBalance)
            | Some(tokenOwner) => defaultTokenBalance
        };
        
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