#include "../../transfer/storage/storage.ligo"

type balance_of_request is record
    owner : token_owner;
    token_id : token_id;
end;

type balance_of_response is record
    request : balance_of_request;
    balance : token_balance;
end;

type balance_of_requests is list(balance_of_request);
type balance_of_responses is list(balance_of_response);

type balance_of_callback is contract(balance_of_responses);

type balance_of_param is record
    requests : balance_of_requests;
    callback : balance_of_callback;
end;

type balance_of_contract is contract(balance_of_param);