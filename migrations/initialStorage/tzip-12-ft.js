const { initial } = require("lodash");

const { MichelsonMap, UnitValue } = require('@taquito/taquito');
const { alice, bob, charlie } = require('../../scripts/sandbox/accounts');
const initialStorage = {};

initialStorage.base = {
    tzip12: {
        tokensLedger: new MichelsonMap,
        tokenOperators: new MichelsonMap,
        u: UnitValue
    },
    u: UnitValue
};

initialStorage.withBalances = {
    ...initialStorage.base,
    tzip12: {
        ...initialStorage.base.tzip12,
        tokensLedger: (()=> {
            const map = new MichelsonMap;
            map.set({0: alice.pkh , 1: 0}, 10);
            map.set({0: bob.pkh , 1: 2}, 10);
            map.set({0: charlie.pkh , 1: 3}, 10);
            return map;
        })()
    }
};

initialStorage.withOperators = {
    ...initialStorage.withBalances,
    tzip12: {
        ...initialStorage.withBalances.tzip12,
        tokenOperators: (() => {
            const map = new MichelsonMap;
            map.set(bob.pkh, [alice.pkh]);
            map.set(alice.pkh, [bob.pkh]);
            return map;
        })()
    }
}


module.exports = initialStorage;