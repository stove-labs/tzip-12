const benchmarkOrigination = require('../../../../../../helpers/benchmark/origination');
const { MichelsonMap, UnitValue } = require('@taquito/taquito');
const generateAddress = require('../../../../../../helpers/generateAddress');
const { times, merge } = require('lodash');

module.exports = () => {

    const owners = times(100).map(() => generateAddress());

    const tokensWithOneOwner = (numberOfTokens) => {
        const tokenOwner = owners[0].pkh;
        const michelsonMap = new MichelsonMap;
        // generate N token IDs and assign them a single tokenOwner
        times(numberOfTokens)
            .forEach(tokenId => michelsonMap.set(tokenId, tokenOwner));
        return michelsonMap;
    }

    const tokensWithUniqueOwners = (numberOfTokens) => {
        const michelsonMap = new MichelsonMap;
        // generate N token IDs and assign a unique tokenOwner to each
        times(numberOfTokens)
            .forEach(tokenId => michelsonMap.set(tokenId, owners[tokenId].pkh));
        return michelsonMap;
    }

    const tokens0owners0 = {
        initialStorage: {
            tokensLedger: tokensWithOneOwner(0),
            u: UnitValue
        },
        extras: {
            initialStorage: {
                numberOfTokens: 0,
                numberOfTokenIDs: 0,
                numberOfOwners: 0
            },
            operation: {},
            resultingStorage: {}
        }
    };

    const tokens1owners1 = merge({}, tokens0owners0, {
        initialStorage: {
            tokensLedger: tokensWithOneOwner(1),
        },
        extras: {
            initialStorage: {
                numberOfTokens: 1,
                numberOfTokenIDs: 1,
                numberOfOwners: 1
            }
        }
    });

    const tokens10owners1 = merge({}, tokens1owners1, {
        initialStorage: {
            tokensLedger: tokensWithOneOwner(10)
        }, 
        extras: {
            initialStorage: {
                numberOfTokens: 10,
                numberOfIDs: 10
            }
        }
    });

    const tokens100owners1 = merge({}, tokens1owners1, {
        initialStorage: {
            tokensLedger: tokensWithOneOwner(100)
        }, 
        extras: {
            initialStorage: {
                numberOfTokens: 100,
                numberOfIDs: 100
            }
        }
    });


    const tokens10owners10 = merge({}, tokens1owners1, {
        initialStorage: {
            tokensLedger: tokensWithUniqueOwners(10)
        }, 
        extras: {
            initialStorage: {
                numberOfTokens: 10,
                numberOfIDs: 10,
                numberOfOwners: 10,
            }
        }
    });

    return { 
        data: {
            origination: {
                [`0 tokens, 0 owners`]: tokens0owners0,
                [`1 token, 1 owner`]: tokens1owners1,
                [`10 tokens, 1 owner`]: tokens10owners1,
                [`100 tokens, 1 owner`]: tokens100owners1,
                [`10 tokens, 10 owners`]: tokens10owners10
            }
        },
        owners
    }
}
