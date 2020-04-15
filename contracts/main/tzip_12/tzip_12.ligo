(* Import current variation variables for preprocessing purposes *)
#include "../../partials/tzip_12/variations/internal.ligo"

#include "../../partials/tzip_12/action/action.ligo"
#include "../../partials/tzip_12/storage/storage.ligo"
#include "../../partials/tzip_12/transfer/transfer.ligo"
#include "../../partials/tzip_12/balance_of/balance_of.ligo"
#include "../../partials/tzip_12/total_token_supply/total_token_supply.ligo"

(*
    Token operators
*)

(* Internal implementation *)
#if VARIATION_OPERATORS_INTERNAL
    #include "../../partials/tzip_12/token_operators/update_token_operators/variations/internal/update_token_operators.ligo"
#endif

(* External implementaiton *)
#if VARIATION_OPERATORS_EXTERNAL
    #include "../../partials/tzip_12/token_operators/update_token_operators/variations/external/update_token_operators.ligo"
#endif

(* Default function that represents our contract, it's sole purpose here is the entrypoint routing *)
function main (const action : action; var storage : storage) : (list(operation) * storage)
    is (case action of
    (* 
        Unwrap the `Transfer(...)` parameters and invoke the transfer function.
        The return value of `transfer(...)` is then returned as a result of `main(...)` as well.
     *)
    | Transfer(transfer_param) -> transfer(transfer_param, storage)
    | Balance_of(balance_of_param) -> balance_of(balance_of_param, storage)
    | Total_supply(total_token_supply_param) -> total_token_supply(total_token_supply_param, storage)
    | Update_operators(update_token_operators_param) -> update_token_operators(update_token_operators_param, storage)
    end)