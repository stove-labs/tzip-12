#include "types.religo"
#include "../transfer/storage/storage.religo"
#include "../operators/storage/storage.religo"
#include "../metadata/storage/storage.religo"

type storage = {
    tokensLedger: tokensLedger,
    // TODO: operators should be usable regardless of the entrypoint availability, e.g. when operators are originated directly in the storage
#if FLAVOUR__ENTRYPOINT__UPDATE_OPERATORS__ENABLED
    tokenOperators: tokenOperators,
#endif
#if FLAVOUR__ENTRYPOINT__TOKEN_METADATA_REGISTRY__ENABLED
    // snake_case as required by the standard definition
    token_metadata: tokenMetadataRegistry,
#endif
    u: unit
};