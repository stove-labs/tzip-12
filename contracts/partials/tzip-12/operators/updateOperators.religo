let updateOperators = ((storage, updateOperatorsAddOrRemoveAuxiliary, operatorParameterMichelson): (storage, updateOperatorsAddOrRemoveAuxiliary, operatorParameterMichelson)): storage => {
    let operatorParameter: operatorParameter = Layout.convert_from_right_comb(operatorParameterMichelson);

    canUpdateOperators((operatorParameter.owner, storage));

    let tokenOperatorsSet: option(tokenOperatorsSet) = Map.find_opt(
        operatorParameter.owner,
        storage.tzip12.tokenOperators
    );
    let tokenOperatorsSet: option(tokenOperatorsSet) = switch (updateOperatorsAddOrRemoveAuxiliary) {
        | Add_operator(n) => {
            switch (tokenOperatorsSet) {
                // if there is an existing operator set, add an operator to it
                | Some(tokenOperatorsSet) => Some(Set.add(operatorParameter.operator, tokenOperatorsSet))
                // if there are no operators, create a new set with the given operator
                | None => Some(Set.literal([operatorParameter.operator]))
            }
        }
        | Remove_operator(n) => {
            switch (tokenOperatorsSet) {
                // if there is an existing operator set, remove an operator from it
                | Some(tokenOperatorsSet) => Some(Set.remove(operatorParameter.operator, tokenOperatorsSet))
                // if there are no operators, don't create a new set for a removal
                | None => (None: option(tokenOperatorsSet))
            }
        }
    };

    let tokenOperators: tokenOperators = Map.update(
        operatorParameter.owner,
        tokenOperatorsSet,
        storage.tzip12.tokenOperators
    );

    {
        ...storage,
        tzip12: {
            ...storage.tzip12,
            tokenOperators: tokenOperators
        }
    }
}

let updateOperatorsIterator = ((storage, updateOperatorsAddOrRemoveMichelson): (storage, updateOperatorsAddOrRemoveMichelson)): storage => {
    let updateOperatorsAddOrRemoveAuxiliary: updateOperatorsAddOrRemoveAuxiliary = Layout.convert_from_right_comb(updateOperatorsAddOrRemoveMichelson);
    switch (updateOperatorsAddOrRemoveAuxiliary) {
        | Add_operator(operatorParameterMichelson) => updateOperators((storage, updateOperatorsAddOrRemoveAuxiliary, operatorParameterMichelson));
        | Remove_operator(operatorParameterMichelson) => updateOperators((storage, updateOperatorsAddOrRemoveAuxiliary, operatorParameterMichelson));
    }
}

let updateOperators = ((updateOperatorsParameter, storage): (updateOperatorsParameter, storage)): entrypointReturn => {
    let storage = List.fold(
        updateOperatorsIterator,
        updateOperatorsParameter,
        storage
    );
    (([]: list(operation)), storage)
}