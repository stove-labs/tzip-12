#include "storage/get_token_balance.ligo"
#include "storage/set_token_balance.ligo"

(* 
    This function applies the provided transfer on top of the provided storage,
    by updating the respective balances accordingly.
*)
function apply_transfer(const transfer : transfer; var storage : storage) : storage
    is begin
        (* 
            Update the `from` and `to` balances.
            `token_balance` is a nat, hence we use `abs` to turn the integer resulting from the subtraction
            into a natural number.
        *)
        const new_from_token_balance : token_balance = abs(
            get_token_balance(transfer.from_, transfer.token_id, storage) - transfer.amount
        );
        const new_to_token_balance : token_balance = get_token_balance(transfer.to_, transfer.token_id, storage) + transfer.amount;

        (* Update storage with the computed balances from above *)
        storage := set_token_balance(transfer.from_, transfer.token_id, new_from_token_balance, storage);
        storage := set_token_balance(transfer.to_, transfer.token_id, new_to_token_balance, storage);
        skip;
    end with storage;