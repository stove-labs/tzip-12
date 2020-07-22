let isOperator = ((tokenOwner, tokenOperator, tzip12Storage): (tokenOwner, tokenOperator, tzip12Storage)): bool => {
    let tokenOperatorsSet: option(tokenOperatorsSet) = Map.find_opt(tokenOwner, tzip12Storage.tokenOperators);
    switch(tokenOperatorsSet) {
        | None => false
        | Some(tokenOperatorsSet) => Set.mem(tokenOperator, tokenOperatorsSet);
    }
}