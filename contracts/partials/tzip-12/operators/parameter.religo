#include "storage/storage.religo"

type operatorParameter = {
    owner: tokenOwner,
    operator: tokenOperator,
}

type updateOperatorsAddOrRemove =
// There's an extra `_p` in the constructors below to avoid 'redundant constructor' error 
// due to the interop type conversions below
| Add_operator_p(operatorParameter)
| Remove_operator_p(operatorParameter)

type operatorParameterMichelson = michelson_pair_right_comb(operatorParameter);

type updateOperatorsAddOrRemoveAuxiliary =
| Add_operator(operatorParameterMichelson)
| Remove_operator(operatorParameterMichelson)

type updateOperatorsAddOrRemoveMichelson = michelson_or_right_comb(updateOperatorsAddOrRemoveAuxiliary);

type updateOperatorsParameter = list(updateOperatorsAddOrRemoveMichelson);