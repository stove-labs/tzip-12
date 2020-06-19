#include "types.religo"
#include "../transfer/storage/storage.religo"
#include "../operators/storage/storage.religo"

type storage = {
    tokensLedger: tokensLedger,
    // TODO: operators should be usable regardless of the entrypoint availability, e.g. when operators are originated directly in the storage
#if FLAVOUR__ENTRYPOINT__UPDATE_OPERATORS__ENABLED
    tokenOperators: tokenOperators,
#endif
    u: unit
};