let updateOperators = ((tzip12Storage, updateOperatorsAddOrRemoveAuxiliary, operatorParameterMichelson): (tzip12Storage, updateOperatorsAddOrRemoveAuxiliary, operatorParameterMichelson)): tzip12Storage => {
    let operatorParameter: operatorParameter = Layout.convert_from_right_comb(operatorParameterMichelson);

    canUpdateOperators((operatorParameter.owner, tzip12Storage));

    let tokenOperatorsSet: option(tokenOperatorsSet) = Map.find_opt(
        operatorParameter.owner,
        tzip12Storage.tokenOperators
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
        tzip12Storage.tokenOperators
    );

    {
        ...tzip12Storage,
        tokenOperators: tokenOperators
    }
}

let updateOperatorsIterator = ((tzip12Storage, updateOperatorsAddOrRemoveMichelson): (tzip12Storage, updateOperatorsAddOrRemoveMichelson)): tzip12Storage => {
    let updateOperatorsAddOrRemoveAuxiliary: updateOperatorsAddOrRemoveAuxiliary = Layout.convert_from_right_comb(updateOperatorsAddOrRemoveMichelson);
    switch (updateOperatorsAddOrRemoveAuxiliary) {
        | Add_operator(operatorParameterMichelson) => updateOperators((tzip12Storage, updateOperatorsAddOrRemoveAuxiliary, operatorParameterMichelson));
        | Remove_operator(operatorParameterMichelson) => updateOperators((tzip12Storage, updateOperatorsAddOrRemoveAuxiliary, operatorParameterMichelson));
    }
}

let updateOperators = ((updateOperatorsParameter, tzip12Storage): (updateOperatorsParameter, tzip12Storage)): tzip12EntrypointReturn => {
    let tzip12Storage = List.fold(
        updateOperatorsIterator,
        updateOperatorsParameter,
        tzip12Storage
    );
    (([]: list(operation)), tzip12Storage)
}