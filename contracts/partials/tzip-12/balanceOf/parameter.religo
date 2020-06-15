type balanceOfRequest = {
    owner: tokenOwner,
    token_id: tokenId,
};

type balanceOfResponse = {
    request: balanceOfRequest,
    balance: tokenBalance,
};

type balanceOfCallback = contract(list(balanceOfResponse));

type balanceOfParameter = {
    requests: list(balanceOfRequest),
    callback: balanceOfCallback,
};

type balanceOfRequestMichelson = michelson_pair_right_comb(balanceOfRequest);

type balanceOfResponseAuxiliary = {
    request: balanceOfRequestMichelson,
    balance: tokenBalance
};

type balanceOfResponseMichelson = michelson_pair_right_comb(balanceOfResponseAuxiliary);

type balanceOfCallbackMichelson = contract(list(balanceOfResponseMichelson));

type balanceOfParameterAuxiliary = {
    requests: list(balanceOfRequestMichelson),
    callback: balanceOfCallbackMichelson
};

type balanceOfParameterMichelson = michelson_pair_right_comb(balanceOfParameterAuxiliary);