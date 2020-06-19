#include "../../../storage/types.religo"
type tokenLookupId = (tokenOwner, tokenId);
#if FLAVOUR__FT__STORAGE__BIG_MAP__ENABLED
type tokensLedger = big_map(tokenLookupId, tokenBalance);
#else
type tokensLedger = map(tokenLookupId, tokenBalance);
#endif

