/**
 * Flavourful switches to flip on/off functionality
 */
// #define WITH_BIG_MAP
// #define WITH_BALANCE_OF

#include "../../partials/tzip-12/errors.religo"
/**
 *  Support the simple implementation which uses maps instead of big_maps
 */
#if WITH_BIG_MAP
#include "../../partials/tzip-12/storage/nft/storage.religo"
#else
#include "../../partials/tzip-12/storage/nft-no-big-map/storage.religo"
#endif

#include "../../partials/tzip-12/parameter/parameter.religo"

type entrypointParameter = (parameter, storage);
type entrypointReturn = (list(operation), storage);

/**
 * Concrete NFT-optimized entrypoint implementations
 */
#include "../../partials/tzip-12/transfer/nft/transfer.religo"
#include "../../partials/tzip-12/balanceOf/nft/balanceOf.religo"


let main = ((parameter, storage): entrypointParameter): entrypointReturn => {
    switch (parameter) {
        | Transfer(transferParameter) => transfer((transferParameter, storage))
#if WITH_BALANCE_OF
        | Balance_of(balanceOfParameterMichelson) => balanceOf((balanceOfParameterMichelson, storage))
#endif
        | U => (([]: list(operation)), storage)
    }
}

