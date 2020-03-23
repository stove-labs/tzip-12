#include "is_transfer_valid.ligo"
#include "apply_transfer.ligo"
#include "storage/set_token_balance.ligo"

(*
    https://gitlab.com/tzip/tzip/-/blob/master/proposals/tzip-12/tzip-12.md#transfer

    `Transfer` allows for a batch & atomic transfer of tokens between two or more addresses, 
    by accepting a list of multiple transfers. 
*)
function transfer (const transfer_param : transfer_param; var storage : storage) : (list(operation) * storage)
 is begin
    (* Iterate over the provided list of transfers *)
    function transfer_iterator (const storage : storage; const transfer : transfer) : storage
        is begin
            (* Check if the proposed transfer is valid *)
            is_transfer_valid(transfer, storage);
            (* Apply the requested transfer assuming it passed the validation check above *)
            storage := apply_transfer(transfer, storage);
            skip;
        end with storage;

    storage := list_fold(transfer_iterator, transfer_param, storage);
    skip;
 end with ((nil : list(operation)), storage)