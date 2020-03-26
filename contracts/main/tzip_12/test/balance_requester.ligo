#include "../../../partials/tzip_12/balance_of/action/balance_of_param.ligo"
#include "../../../partials/tzip_12/balance_of/action/entrypoint.ligo"
type storage is balance_of_responses;
type request_balance_param is record
    request_from : address;
    requests : balance_of_requests;
end;

type action is 
| Request_balance of request_balance_param
| Receive_balance of balance_of_responses

function request_balance(const request_balance_param : request_balance_param; const storage : storage) : (list(operation) * storage)
    is begin
        (* TZIP-12 contract from which the balance should be requested *)
        const tzip_12_instance : balance_of_contract = get_entrypoint(balance_of_entrypoint, request_balance_param.request_from);
        (* Current contract where the `Balance_of` responses should be received *)
        const callback : balance_of_callback = get_entrypoint("%receive_balance", self_address);

        (* Compose the parameter required for the `Balance_of` call *)
        const balance_of_param : balance_of_param = record
            requests = request_balance_param.requests;
            callback = callback
        end;
        
        (* Compose the operation combining all of the above *)
        const balance_of_operation : operation = transaction(
            balance_of_param,
            0mutez,
            tzip_12_instance
        );

        const operations : list(operation) = list
            balance_of_operation
        end;
    end with (operations, storage);

(*
    This contract is used for testing purposes only.
    It allows the test suite to trigger a series of internal operations containing `Balance_of` via the `Request_balance` entrypoint.
    And subsequently receive it via the `Receive_balance` entrypoint.
*)
function main(const action : action; var storage : storage) : (list(operation) * storage)
    is case action of 
        | Request_balance(request_balance_param) -> request_balance(request_balance_param, storage)
        | Receive_balance(balance_of_responses) -> ((nil : list(operation)), balance_of_responses)
    end
