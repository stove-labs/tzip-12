#include "../transfer/action/action.ligo"
#include "../balance_of/action/action.ligo"

type action is
| Transfer of transfer_param
| Balance_of of balance_of_param