#include "./default.religo"

let currentTokenMintingPermissionPolicy: tokenMintingPolicy = Unrestricted_mint;

let canMint = ((tokenMintContents, tzip12Storage): (tokenMintContents, tzip12Storage)): unit => {
    ();
}