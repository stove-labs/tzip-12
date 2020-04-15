(* This file contains the base preprocessing values for the TZIP-12 implementation *)

(* 
    Token operators

    Choose between two implementations of the operators entrypoint:
    
    - Internal:
        Stores all the relevant operator data within the current smart contract's storage.
    - External:
        Provides a TZIP-12-compatible facade for an external operators provider.
*)
#define VARIATION_OPERATORS_INTERNAL
//#define VARIATION_OPERATORS_EXTERNAL
