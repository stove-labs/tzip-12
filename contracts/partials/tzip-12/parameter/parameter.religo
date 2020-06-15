#include "../transfer/parameter.religo"
#if WITH_BALANCE_OF
#include "../balanceOf/parameter.religo"
#endif

type balanceOfParameter = nat;
type parameter = 
| Transfer(transferParameter)
#if WITH_BALANCE_OF
| Balance_of(balanceOfParameterMichelson)
#endif
| U

