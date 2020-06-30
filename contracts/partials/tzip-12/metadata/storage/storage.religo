type tokenSymbol = string;
type tokenName = string;
type tokenDecimals = nat;
type tokenExtrasKey = string;
type tokenExtrasValue = string;
type tokenExtras = map(tokenExtrasKey, tokenExtrasValue);

type tokenMetadata = {
    token_id: tokenId,
    symbol: tokenSymbol,
    name: tokenName,
    decimals: tokenDecimals,
    extras: tokenExtras
};

#if FLAVOUR__TOKEN_METADATA_REGISTRY__STORAGE__BIG_MAP__ENABLED
type tokenMetadataRegistry = big_map(tokenId, tokenMetadata);
#else
type tokenMetadataRegistry = map(tokenId, tokenMetadata);
#endif