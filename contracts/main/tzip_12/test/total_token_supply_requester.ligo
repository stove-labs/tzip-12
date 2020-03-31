#include "../../../partials/tzip_12/total_token_supply/action/total_token_supply_param.ligo"
#include "../../../partials/tzip_12/total_token_supply/action/entrypoint.ligo"

type storage is total_token_supply_response;
type request_total_token_supply_param is record
    request_from : address;
    requests : total_token_supply_requests;
end;

type action is 
| Request_total_token_supply of request_total_token_supply_param
| Receive_total_token_supply of total_token_supply_responses;
type storage is total_token_supply_responses;

function request_total_token_supply(const request_total_token_supply_param : request_total_token_supply_param; const storage : storage) : (list(operation) * storage)
    is begin
        (* TZIP-12 contract from which the total supply should be requested *)
        const tzip_12_instance : total_token_supply_contract = get_entrypoint(total_token_supply_entrypoint, request_total_token_supply_param.request_from);
        (* Current contract where the `Total_supply` responses should be received *)
        const callback : total_token_supply_callback = get_entrypoint("%receive_total_token_supply", self_address);

        (* Compose the parameter required for the `Total_supply` call *)
        const total_token_supply_param : total_token_supply_param = record
            token_ids = request_total_token_supply_param.requests;
            callback = callback;
        end;

        (* Compose the operation combining all of the above *)
        const total_token_supply_operation : operation = transaction(
            total_token_supply_param,
            0mutez,
            tzip_12_instance
        );

        const operations : list(operation) = list
            total_token_supply_operation
        end;
    end with (operations, storage);

(*
    This contract is used for testing purposes only.
    It allows the test suite to trigger a series of internal operations containing `Total_supply` via the `Request_total_token_supply` entrypoint.
    And subsequently receive it via the `Receive_total_token_supply` entrypoint.
*)
function main(const action : action; const storage : storage) : (list(operation) * storage)
    is case action of
    | Request_total_token_supply(request_total_token_supply_param) -> request_total_token_supply(request_total_token_supply_param, storage)
    | Receive_total_token_supply(total_token_supply_responses) -> ((nil : list(operation)), total_token_supply_responses)
    end