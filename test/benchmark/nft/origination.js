const { MichelsonMap, UnitValue } = require('@taquito/taquito');
const { times, range } = require('lodash');
const generateAddress = require('../../../helpers/generateAddress');

const arrayChunks = require('array-chunk');
const arrayDistribute = require('distribute-array');

module.exports = (options) => {
    const initialStorage = {
        tokenOwners: new MichelsonMap(),
        u: UnitValue
    };

    const tokenIDs = range(options.numberOfTokenIDs);
    const tokenSupply = range(options.numberOfTokens);
    const owners = range(options.numberOfOwners)
        .map(() => generateAddress());

    const supplyChunks = arrayChunks(tokenSupply, options.numberOfTokens / options.numberOfTokenIDs);
    // make sure there is a tokenOwner for each issued token
    const distributedOwners = (() => {
        let counter = -1;
        const counterMax = options.numberOfOwners - 1;

        return supplyChunks.map((chunk,i) => {
            counter++
            if (counter > counterMax) counter = 0;
            return chunk.map(item => {
                return owners[counter];
            })
        });
    })();

    initialStorage.tokenOwners = tokenIDs.reduce((tokenOwners, tokenID, i) => {
        tokenOwners.set(tokenID, distributedOwners[i][0])
        return tokenOwners;
    }, initialStorage.tokenOwners);

    return { initialStorage };
};