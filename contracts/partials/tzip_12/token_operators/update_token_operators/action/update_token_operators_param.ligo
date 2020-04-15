type token_operator is address;
type set_of_unique_token_ids is set(token_id);
type token_operator_tokens is
| All_tokens of unit
| Some_tokens of set_of_unique_token_ids;

type token_operator_update_detail is record
    owner : token_owner;
    operator : token_operator;
    tokens : token_operator_tokens
end

type token_operator_update is
| Add_operator of token_operator_update_detail
| Remove_operator of token_operator_update_detail

type update_token_operators_param is list(token_operator_update);