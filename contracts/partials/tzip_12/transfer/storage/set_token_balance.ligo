#include "get_token_lookup_id.ligo"
#include "../../constants.ligo"
(* This setter serves as an abstraction over the current storage structure *)
(* Update the token_balance for the provided token_owner/token_id pair *)
function set_token_balance(const token_owner : token_owner; const token_id : token_id; const token_balance : token_balance; const storage : storage) : storage
    is begin
        const token_lookup_id : token_lookup_id = get_token_lookup_id(token_owner, token_id);
        storage.token_balances[token_lookup_id] := token_balance
    end with storage;