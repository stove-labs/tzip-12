#include "storage/get_token_balance.ligo"
#include "storage/set_token_balance.ligo"

function apply_transfer(const transfer : transfer; var storage : storage) : storage
    is begin
        const new_from_token_balance : token_balance = abs(
            get_token_balance(transfer.from_, transfer.token_id, storage) - transfer.amount
        );
        const new_to_token_balance : token_balance = get_token_balance(transfer.to_, transfer.token_id, storage) + transfer.amount;

        storage := set_token_balance(transfer.from_, transfer.token_id, new_from_token_balance, storage);
        storage := set_token_balance(transfer.to_, transfer.token_id, new_to_token_balance, storage);
        skip;
    end with storage;