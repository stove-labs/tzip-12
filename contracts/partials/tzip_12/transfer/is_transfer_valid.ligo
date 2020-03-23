#include "../constants.ligo"
#include "storage/get_token_balance.ligo"

(*
    This function validates the provided transfer respective to the provided storage value.
    If the transfer is not valid, the function `fail(s)with` a predefined error code.

    Rules determining if a transfer is valid are specified as follows:
    https://gitlab.com/tzip/tzip/-/blob/master/proposals/tzip-12/tzip-12.md#transfer
*)
function is_transfer_valid (const transfer : transfer; const storage : storage) : unit
    is begin
        if sender =/= transfer.from_ then failwith(error_transfer_invalid_permissions) else skip;
        if get_token_balance(transfer.from_, transfer.token_id, storage) < transfer.amount then failwith(error_transfer_invalid_insufficient_balance) else skip;
    end with Unit;