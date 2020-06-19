#include "../../../storage/types.religo"
#if FLAVOUR__NFT__STORAGE__BIG_MAP__ENABLED
type tokensLedger = big_map(tokenId, tokenOwner);
#else
type tokensLedger = map(tokenId, tokenOwner);
#endif