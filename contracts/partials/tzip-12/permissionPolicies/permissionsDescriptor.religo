let permissionsDescriptor = ((permissionsDescriptorParameter, storage): (permissionsDescriptorParameter, storage)): entrypointReturn => {
    let permissionsDescriptorAuxiliary: permissionsDescriptorAuxiliary = {
        operator: Layout.convert_to_right_comb(currentPermissionsDescriptor.operator),
        receiver: Layout.convert_to_right_comb(currentPermissionsDescriptor.receiver),
        sender: Layout.convert_to_right_comb(currentPermissionsDescriptor.sender),
        // option type does not require a layout conversion
        custom: (switch (currentPermissionsDescriptor.custom) {
            | Some(custom) => Some(Layout.convert_to_right_comb(custom))
            | None => (None: option(customPermissionPolicyMichelson))
        })
    };
    let currentPermissionsDescriptorMichelson: permissionsDescriptorMichelson = Layout.convert_to_right_comb(permissionsDescriptorAuxiliary);
    let callbackOperation: operation = Tezos.transaction(currentPermissionsDescriptorMichelson, 0tez, permissionsDescriptorParameter); 
    ([callbackOperation], storage)
}