#include "is_transfer_valid.ligo"
#include "apply_transfer.ligo"
#include "storage/set_token_balance.ligo"

function transfer (const transfer_param : transfer_param; var storage : storage) : (list(operation) * storage)
 is begin
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