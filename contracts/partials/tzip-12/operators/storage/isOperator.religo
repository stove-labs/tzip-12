let isOperator = ((tokenOwner, tokenOperator, storage): (tokenOwner, tokenOperator, storage)): bool => {
    let tokenOperatorsSet: option(tokenOperatorsSet) = Map.find_opt(tokenOwner, storage.tokenOperators);
    switch(tokenOperatorsSet) {
        | None => false
        | Some(tokenOperatorsSet) => Set.mem(tokenOperator, tokenOperatorsSet);
    }
}