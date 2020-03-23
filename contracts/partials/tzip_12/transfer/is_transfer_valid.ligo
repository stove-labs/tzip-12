#include "../constants.ligo"
#include "storage/get_token_balance.ligo"

function is_transfer_valid (const transfer : transfer; const storage : storage) : unit
    is begin
        if sender =/= transfer.from_ then failwith(error_transfer_invalid_permissions) else skip;
        if get_token_balance(transfer.from_, transfer.token_id, storage) < transfer.amount then failwith(error_transfer_invalid_insufficient_balance) else skip;
    end with Unit;