#include "storage.ligo"
(* Compose a token_lookup_id from a token_owner/token_id pair *)
function get_token_lookup_id (const token_owner : token_owner; const token_id : token_id) : token_lookup_id
    is record
        token_owner = token_owner;
        token_id = token_id;
    end