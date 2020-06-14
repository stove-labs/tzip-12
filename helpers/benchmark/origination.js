const { Tezos } = require('@taquito/taquito');
const { saveBenchmark, benchmarkOperation } = require('./benchmark');
const { alice } = require('../../scripts/sandbox/accounts');

const originate = async (contractName, initialStorage) => {
    const { michelson } = require(`../../build/contracts/${contractName}.json`);
    const result = await Tezos.contract.originate({
        code: JSON.parse(michelson),
        storage: initialStorage
    });
    await result.confirmation(1);
    return result;
}

const benchmarkOrigination = (contractName) => (testGroup) => async (testCaseName, initialStorage, extras) => {
    it(testCaseName, async () => {
        const operationBenchmark = await benchmarkOperation(alice.pkh, async () => await originate(contractName, initialStorage));
        await saveBenchmark(contractName, testGroup, testCaseName, operationBenchmark, extras);
    })
};

const runOriginationBenchmark = async (contractName, benchmarkData) => {
    const originationGroup = benchmarkOrigination(contractName);

    Object.entries(benchmarkData)
        .forEach(([testGroup, testCases]) => {
            describe(testGroup, async () => {
                const originate = originationGroup(testGroup);
                Object.entries(testCases)
                    .forEach(async ([testCaseName, testCaseData]) => {
                        await originate(testCaseName, testCaseData.initialStorage, testCaseData.extras);
                    });
            });
        });
};
module.exports = { runOriginationBenchmark, originate };