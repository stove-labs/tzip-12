let tokenMetadataRegistry = ((tokenMetadataRegistryParameter, storage): (tokenMetadataRegistryParameter, storage)): entrypointReturn => {
    let callbackTarget = tokenMetadataRegistryParameter;
    let callbackOperation: operation = Tezos.transaction(Tezos.self_address, 0tez, callbackTarget);
    ([callbackOperation], storage);
}