#include "../transfer/parameter.religo"
#include "../permissionPolicies/parameter.religo"

#if FLAVOUR__ENTRYPOINT__BALANCE_OF__ENABLED
#include "../balanceOf/parameter.religo"
#endif

#if FLAVOUR__ENTRYPOINT__UPDATE_OPERATORS__ENABLED
#include "../operators/parameter.religo"
#endif

#if FLAVOUR__ENTRYPOINT__TOKEN_METADATA_REGISTRY__ENABLED
#include "../metadata/parameter.religo"
#endif

type parameter = 
| Transfer(transferParameter)
#if FLAVOUR__ENTRYPOINT__BALANCE_OF__ENABLED
| Balance_of(balanceOfParameterMichelson)
#endif
#if FLAVOUR__ENTRYPOINT__PERMISSIONS_DESCRIPTOR__ENABLED
| Permissions_descriptor(permissionsDescriptorParameter)
#endif
#if FLAVOUR__ENTRYPOINT__UPDATE_OPERATORS__ENABLED
| Update_operators(updateOperatorsParameter)
#endif
#if FLAVOUR__ENTRYPOINT__TOKEN_METADATA_REGISTRY__ENABLED
| Token_metadata_registry(tokenMetadataRegistryParameter)
#endif
| U

