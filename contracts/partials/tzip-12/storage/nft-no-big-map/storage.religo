#include "../types.religo"
type tokenOwners = map(tokenId, tokenOwner);
type storage = {
    tokenOwners: tokenOwners,
    u: unit
};