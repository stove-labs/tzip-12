#include "../storage/storage.ligo"

type total_token_supply_request is token_id;
type total_token_supply_requests is list(total_token_supply_request);
type total_token_supply_response is record
    token_id : token_id;
    total_supply : total_token_supply_count
end
type total_token_supply_responses is list(total_token_supply_response);
type total_token_supply_callback is contract(total_token_supply_responses)

type total_token_supply_param is record
    token_ids : total_token_supply_requests;
    callback : total_token_supply_callback
end

type total_token_supply_contract is contract(total_token_supply_param);