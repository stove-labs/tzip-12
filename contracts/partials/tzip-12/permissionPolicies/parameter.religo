type operatorTransferPolicyMichelson = michelson_or_right_comb(operatorTransferPolicy);
type ownerHookPolicyMichelson = michelson_or_right_comb(ownerHookPolicy);
type customPermissionPolicyMichelson = michelson_pair_right_comb(customPermissionPolicy);

type permissionsDescriptorAuxiliary = {
    operator: operatorTransferPolicyMichelson,
    receiver: ownerHookPolicyMichelson,
    sender: ownerHookPolicyMichelson,
    custom: option(customPermissionPolicyMichelson)
}

type permissionsDescriptorMichelson = michelson_pair_right_comb(permissionsDescriptorAuxiliary);

type permissionsDescriptorParameter = contract(permissionsDescriptorMichelson);