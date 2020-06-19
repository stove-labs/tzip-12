#include "../../transfer/parameter.religo"
#include "../../operators/storage/isOperator.religo"

// TODO: should the currentPermissionsDescriptor be part of the storage, rather than just a regular runtime variable?
let currentPermissionsDescriptor: permissionsDescriptor = {
    operator: Owner_or_operator_transfer,
    receiver: Owner_no_hook,
    sender: Owner_no_hook,
    custom: (None: option(customPermissionPolicy)) 
}

let currentOperatorUpdatePermissionPolicy: operatorUpdatePolicy = Owner_update;

// operatorUpdatePolicy = Owner_update
let canUpdateOperators = ((tokenOwner, storage): (tokenOwner, storage)): unit => {
    if (Tezos.sender != tokenOwner) {
        failwith(errorOperatorUpdateDenied)
    } else { (); }
}

// operatorTransferPolicy = Owner_or_operator_transfer
let canTransfer = ((from, transferContents, storage): (tokenOwner, transferContents, storage)): unit => {
    // can transfer own tokens
    if (from != Tezos.sender) {
        // operators can transfer tokens as well
        if (!isOperator((from, Tezos.sender, storage))) {
            failwith(errorNotOperator)
        } else { (); }
    } else { (); }
}