#include "is_transfer_valid.ligo"
#include "../storage/set_token_balance.ligo"

function transfer (const transfer_param : transfer_param; var storage : storage) : (list(operation) * storage)
 is begin
    function transfer_iterator (const storage : storage; const transfer : transfer) : storage
        is begin
            (* Check if the proposed transfer is valid *)
            is_transfer_valid(transfer, storage);

            const new_from_token_balance : token_balance = abs(
                get_token_balance(transfer.from_, transfer.token_id, storage) - transfer.amount
            );
            const new_to_token_balance : token_balance = get_token_balance(transfer.to_, transfer.token_id, storage) + transfer.amount;

            storage := set_token_balance(transfer.from_, transfer.token_id, new_from_token_balance, storage);
            storage := set_token_balance(transfer.to_, transfer.token_id, new_to_token_balance, storage);
            skip;
        end with storage;

    storage := list_fold(transfer_iterator, transfer_param, storage);
    skip;
 end with ((nil : list(operation)), storage)