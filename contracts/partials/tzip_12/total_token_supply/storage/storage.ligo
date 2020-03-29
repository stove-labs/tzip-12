#include "../../transfer/storage/storage.ligo"
(* 
    Total supply is persisted separately rather than computed at each request
    in order to optimise gas costs.
*)
type total_token_supply_count is nat;
type total_token_supply is big_map(token_id, total_token_supply_count);