#include "storage/get_total_token_supply.ligo"

(*
    https://gitlab.com/tzip/tzip/-/blob/master/proposals/tzip-12/tzip-12.md#total_supply

    `Total_supply` allows 3rd party contracts to request the total supply of multiple token_ids at once.
    Response is delivered in a form of a contract callback.
*)
function total_token_supply(const total_token_supply_param : total_token_supply_param; const storage : storage) : (list(operation) * storage)
    is begin
        (* Iterate trough total_token_supply_requests and map them to their total_token_supply_responses *)
        function total_token_supply_request_iterator(const total_token_supply_request : total_token_supply_request) : total_token_supply_response
            is begin
                const total_token_supply_count : total_token_supply_count = get_total_token_supply(total_token_supply_request, storage);
            end with record
                token_id = total_token_supply_request;
                total_supply = total_token_supply_count;
            end;

        const total_token_supply_responses : total_token_supply_responses = list_map(
            total_token_supply_request_iterator, 
            total_token_supply_param.token_ids
        );

        (* Compose the callback transaction/operation containing the mapped data from above *)
        const callback_operation : operation = transaction(
            total_token_supply_responses,
            0mutez,
            total_token_supply_param.callback
        );

        const operations : list(operation) = list
            callback_operation
        end;
    end with (operations, storage);