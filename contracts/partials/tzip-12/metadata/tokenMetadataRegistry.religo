let tokenMetadataRegistry = ((tokenMetadataRegistryParameter, tzip12Storage): (tokenMetadataRegistryParameter, tzip12Storage)): tzip12EntrypointReturn => {
    let callbackTarget = tokenMetadataRegistryParameter;
    let callbackOperation: operation = Tezos.transaction(Tezos.self_address, 0tez, callbackTarget);
    ([callbackOperation], tzip12Storage);
}