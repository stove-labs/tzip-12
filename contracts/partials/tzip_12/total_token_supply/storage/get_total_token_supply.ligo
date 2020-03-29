#include "../../transfer/storage/storage.ligo"
(* This getter serves as an abstraction over the current storage structure *)
(* Return the total token supply based on the provided token_id and storage *)
function get_total_token_supply(const token_id : token_id; const storage : storage) : total_token_supply_count
    is case storage.total_token_supply[token_id] of
        | Some(total_token_supply_count) -> total_token_supply_count
        | None -> default_total_token_supply
    end