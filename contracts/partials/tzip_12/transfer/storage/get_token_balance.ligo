#include "get_token_lookup_id.ligo"
#include "../../constants.ligo"
#include "storage.ligo"
(* This getter serves as an abstraction over the current storage structure *)
(* Return the balance for the provided token_owner/token_id pair *)
function get_token_balance(const token_owner : token_owner; const token_id : token_id; const storage : storage) : token_balance
    is begin
        const token_lookup_id : token_lookup_id = get_token_lookup_id(token_owner, token_id);
        const token_balance : token_balance = case storage.token_balances[token_lookup_id] of
            | Some(token_balance) -> token_balance
            | None -> default_balance
        end
    end with token_balance;