#include "../../transfer/storage/storage.ligo"
function get_total_token_supply(const token_id : token_id; const storage : storage) : total_token_supply_count
    is case storage.total_token_supply[token_id] of
        | Some(total_token_supply_count) -> total_token_supply_count
        | None -> default_total_token_supply
    end