#include "../transfer/action/action.ligo"
#include "../balance_of/action/action.ligo"
#include "../total_token_supply/action/action.ligo"
#include "../token_operators/update_token_operators/action/action.ligo"

type action is
| Transfer of transfer_param
| Balance_of of balance_of_param
| Total_supply of total_token_supply_param
| Update_operators of update_token_operators_param