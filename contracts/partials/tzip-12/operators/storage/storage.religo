type tokenOperator = address;
type tokenOperatorsSet = set(tokenOperator);

#if FLAVOUR__OPERATORS__STORAGE__BIG_MAP__ENABLED
type tokenOperators = big_map(tokenOwner, tokenOperatorsSet);
#else
type tokenOperators = map(tokenOwner, tokenOperatorsSet);
#endif