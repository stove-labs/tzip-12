#include "../../partials/tzip-12/errors.religo"
/**
 *  Support the simple implementation which uses maps instead of big_maps
 */
#if NO_BIG_MAP
#include "../../partials/tzip-12/storage/nft-no-big-map/storage.religo"
#else
#include "../../partials/tzip-12/storage/nft/storage.religo"
#endif

#include "../../partials/tzip-12/parameter/parameter.religo"

type entrypointParameter = (parameter, storage);
type entrypointReturn = (list(operation), storage);

/**
 * Concrete NFT-optimized entrypoint implementations
 */
#include "../../partials/tzip-12/transfer/nft/transfer.religo"

let main = ((parameter, storage): entrypointParameter): entrypointReturn => {
    switch (parameter) {
        | Transfer(transferParameter) => transfer((transferParameter, storage))
        | U => (([]: list(operation)), storage)
    }
}

