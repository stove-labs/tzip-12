const { initial } = require("lodash");

const { MichelsonMap, UnitValue } = require('@taquito/taquito');
const { alice, bob, charlie } = require('../../scripts/sandbox/accounts');
const initialStorage = {};

initialStorage.base = {
    tokensLedger: new MichelsonMap,
    tokenOperators: new MichelsonMap,
    token_metadata: new MichelsonMap,
    u: UnitValue
};

initialStorage.withBalances = {
    ...initialStorage.base,
    tokensLedger: (()=> {
        const map = new MichelsonMap;
        map.set(0, alice.pkh);
        map.set(1, bob.pkh);
        map.set(2, charlie.pkh);
        return map;
    })()
};

initialStorage.withOperators = {
    ...initialStorage.withBalances,
    tokenOperators: (() => {
        const map = new MichelsonMap;
        map.set(bob.pkh, [alice.pkh]);
        map.set(alice.pkh, [bob.pkh]);
        return map;
    })()
}


module.exports = initialStorage;