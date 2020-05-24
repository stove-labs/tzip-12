type parameter = unit;
type storage = unit;

type entrypointParameter = (parameter, storage);
type entrypointReturn = (list(operation), storage);

let main = ((parameter, storage): entrypointParameter): entrypointReturn => {
    (([]: list(operation)), storage)
}

