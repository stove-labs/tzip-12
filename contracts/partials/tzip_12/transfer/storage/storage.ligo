(* token_id is a nat, following the TZIP-12 spec *)
type token_id is nat;
type token_owner is address;
(* token_balance is either 0 or positive, therefore it's a nat *)
type token_balance is nat;

(* 
    token_lookup_id is always a unique combination of a token_id and a token_owner, 
    representing a key in the big_map of token_balances
*)
type token_lookup_id is record
    token_id : token_id;
    token_owner : token_owner;
end;

type token_balances is big_map(token_lookup_id, token_balance);