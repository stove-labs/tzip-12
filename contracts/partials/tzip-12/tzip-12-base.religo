/**
 * All available flavour switches
 */
// #define FLAVOUR__NFT
// #define FLAVOUR__NFT__STORAGE__BIG_MAP__ENABLED
// #define FLAVOUR__ENTRYPOINT__BALANCE_OF__ENABLED
/**
 * Permissions
 */
// #define FLAVOUR__ENTRYPOINT__PERMISSIONS_DESCRIPTOR__ENABLED
// #define FLAVOUR__PERMISSION__DEFAULT
/**
 * Operators
 */
// #define FLAVOUR__ENTRYPOINT__UPDATE_OPERATORS__ENABLED


/**
 * Errors
 */
#include "errors.religo"

/**
 * Storage
 */
#include "storage/storage.religo"

/**
 * Permission policies
 * // TODO: figure out a better includes order for basic types such as `tokenOwner` or `tokenOperator`
 */
#if FLAVOUR__ENTRYPOINT__PERMISSIONS_DESCRIPTOR__ENABLED
#include "permissionPolicies/policies.religo"
#endif

#if FLAVOUR__PERMISSION__DEFAULT
#include "permissionPolicies/flavours/default.religo"
#endif

/**
 * Parameter
 */
#include "parameter/parameter.religo"

type entrypointParameter = (parameter, storage);
type entrypointReturn = (list(operation), storage);
/**
 * Transfer
 */
#include "transfer/transfer.religo"

/**
 * Permissions descriptor
 */
#if FLAVOUR__ENTRYPOINT__PERMISSIONS_DESCRIPTOR__ENABLED
#include "permissionPolicies/permissionsDescriptor.religo"
#endif

/**
 * Balance_of
 */
#if FLAVOUR__ENTRYPOINT__BALANCE_OF__ENABLED
#include "balanceOf/balanceOf.religo"
#endif

/**
 * Operators
 */
#if FLAVOUR__ENTRYPOINT__UPDATE_OPERATORS__ENABLED
#include "operators/updateOperators.religo"
#endif

/**
 * Token metadata registry
 */
#if FLAVOUR__ENTRYPOINT__TOKEN_METADATA_REGISTRY__ENABLED
#include "metadata/tokenMetadataRegistry.religo"
#endif

/**
 * TZIP-12
 */
let tzip12 = ((parameter, storage): (parameterTZIP12, storage)) => {
        switch (parameter) {
                /**
                 * Transfer
                 */
                | Transfer(transferParameter) => transfer((transferParameter, storage))
                /**
                 * Balance_of
                 */
#if FLAVOUR__ENTRYPOINT__BALANCE_OF__ENABLED
                | Balance_of(balanceOfParameterMichelson) => balanceOf((balanceOfParameterMichelson, storage))
#endif
                /**
                 * Permissions_descriptor
                 */
#if FLAVOUR__ENTRYPOINT__PERMISSIONS_DESCRIPTOR__ENABLED
                | Permissions_descriptor(permissionsDescriptorParameter) => permissionsDescriptor((permissionsDescriptorParameter, storage))
#endif
                /**
                 * Operators
                 */
#if FLAVOUR__ENTRYPOINT__UPDATE_OPERATORS__ENABLED
                | Update_operators(updateOperatorsParameter) => updateOperators((updateOperatorsParameter, storage))
#endif
                /**
                 * Token metadata registry
                 */
#if FLAVOUR__ENTRYPOINT__TOKEN_METADATA_REGISTRY__ENABLED
                | Token_metadata_registry(tokenMetadataRegistryParameter) => tokenMetadataRegistry((tokenMetadataRegistryParameter, storage))
#endif
                /**
                 * Placeholder to generate multiple entrypoints in case of just one actual entrypoint being used
                 */
                | U => (([]: list(operation)), storage)
        }
}

/**
 * Main
 */
let main = ((parameter, storage): entrypointParameter): entrypointReturn => {
        switch (parameter) {
                | TZIP12(tzip12Parameter) => tzip12((tzip12Parameter, storage))
        }
}

