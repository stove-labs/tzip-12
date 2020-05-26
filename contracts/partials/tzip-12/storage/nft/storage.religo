#include "../types.religo"
type tokenOwners = big_map(tokenId, tokenOwner);
type storage = {
    tokenOwners: tokenOwners,
    u: unit
};