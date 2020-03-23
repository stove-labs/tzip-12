#include "action/balance_of_param.ligo"

(*
    https://gitlab.com/tzip/tzip/-/blob/master/proposals/tzip-12/tzip-12.md#balance_of

    `Balance_of` allows for a batch balance request for multiple token_owner/token_id pairs.
    Response is delivered in a form of a contract callback.
*)
function balance_of(const balance_of_param : balance_of_param; const storage : storage) : (list(operation) * storage)
    is begin
        (* Iterate trough balance requests and map them to their respective balance responses *)
        function balance_of_request_iterator (const balance_of_request : balance_of_request) : balance_of_response
            is begin
                const requested_balance : token_balance = get_token_balance(
                    balance_of_request.owner,
                    balance_of_request.token_id, 
                    storage
                );
            end with record
                    request = balance_of_request;
                    balance = requested_balance;
                end;

        const balance_of_responses : balance_of_responses = list_map(balance_of_request_iterator, balance_of_param.requests);
        
        (* Compose the callback transaction/operation containing the mapped data from above *)
        const callback_operation : operation = transaction(
            balance_of_responses,
            0mutez,
            balance_of_param.callback
        );

        const operations : list(operation) = list
            callback_operation
        end;
    end with (operations, storage);