#include "../transfer/storage/storage.ligo"
#include "../total_token_supply/storage/storage.ligo"

type storage is record
    token_balances : token_balances;
    (* See https://www.wordhippo.com/what-is/the-plural-of/supply.html *)
    total_token_supply : total_token_supply;
end;