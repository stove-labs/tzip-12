/**
 * Token lookup ID is currently in the format of an array,
 * to represent an un-annotated Michelson pair within taquito.
 * This may change in the upcoming Taquito versions, as it does not appear intentional.
 */
module.exports.getTokenLookupId = (token_id, token_owner) => [token_id, token_owner];