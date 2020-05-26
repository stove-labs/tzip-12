const { Tezos } = require('@taquito/taquito');
const { InMemorySigner } = require('@taquito/signer')
const { alice } = require('../../scripts/sandbox/accounts');
const { saveBenchmark, benchmarkOperation } = require('../../helpers/benchmark');

const testGroupOrigination = 'origination';
const contractNameNFTBigMap = 'tzip-12-nft';
const contractNameNFTSimpleMap = 'tzip-12-nft-no-big-map';

Tezos.setProvider({
    rpc: 'http://localhost:8732',
    signer: new InMemorySigner(alice.sk)
});

/**
 * Custom origination since truffle does not expose origination costs from the deployer
 * @param {*} contractName 
 * @param {*} testCase 
 * @param {*} initialStorage 
 */
const originate = async (contractName, testCase, initialStorage) => {
    const { michelson } = require(`../../build/contracts/${contractName}.json`);
    return await benchmarkOperation(alice.pkh, async () => {
        const result = await Tezos.contract.originate({
            code: JSON.parse(michelson),
            storage: initialStorage
        });
        await result.confirmation(1);
        return result;
    });
};

/**
 * Wrapper to generate test framework cases for each benchmark
 * @param {*} contractNameNFT 
 * @param {*} testCaseName 
 * @param {*} data 
 */
const benchmarkNFTOrigination = (contractName, testCaseName, data) => {
    const getInitialStorage = require('./nft/origination');
    it(testCaseName, async () => {
        const { initialStorage } = getInitialStorage(data);
        await saveBenchmark(contractName, testGroupOrigination, testCaseName,
            await originate(contractName, testCaseName, initialStorage),
            data
        )
    });
}

// TODO: figure out what overwrites global `contract` in benchmark tests
global.contractTruffle = contract;
contract('benchmark', () => {

    describe(testGroupOrigination, () => {
    
        const benchmark = (contractName) => {
            describe(contractName, () => {
                benchmarkNFTOrigination(contractName, 'Multiple tokens with a single owner', {
                    numberOfTokenIDs: 100,
                    numberOfTokens: 100,
                    numberOfOwners: 1
                });
        
                benchmarkNFTOrigination(contractName, 'Multiple tokens with a single owner', {
                    numberOfTokenIDs: 200,
                    numberOfTokens: 200,
                    numberOfOwners: 1
                });
        
                benchmarkNFTOrigination(contractName, 'Multiple tokens with multiple owners', {
                    numberOfTokenIDs: 200,
                    numberOfTokens: 200,
                    numberOfOwners: 10
                });

                benchmarkNFTOrigination(contractName, 'Multiple tokens with multiple owners', {
                    numberOfTokenIDs: 350,
                    numberOfTokens: 350,
                    numberOfOwners: 1
                });
            });
        }

        benchmark(contractNameNFTSimpleMap);
        benchmark(contractNameNFTBigMap);
    });
});