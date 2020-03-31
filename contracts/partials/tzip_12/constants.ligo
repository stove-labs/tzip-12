(* 
    Default balance for any given address that,
    does not have an existing entry in the `token_balances` ledger.
*)
const default_balance : nat = 0n;
const default_total_token_supply : nat = 0n;

(*
    Error codes used for `failwith` contract execution termination.
*)
const error_transfer_invalid_permissions : string = "0";
const error_transfer_invalid_insufficient_balance : string = "1";