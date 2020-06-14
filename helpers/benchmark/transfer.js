
const { originate } = require('./origination');
const { saveBenchmark, benchmarkOperation } = require('./benchmark');
const { Tezos } = require('@taquito/taquito');
const { InMemorySigner } = require('@taquito/signer');
const { alice } = require('../../scripts/sandbox/accounts');
const drip = require('../../helpers/faucet').faucet(alice.sk);

const reveal = async ({sk, pkh}) => {
    Tezos.setSignerProvider(new InMemorySigner(sk));
    const operation = await Tezos.contract.transfer({ to: pkh, amount: 1 });
    return await operation.confirmation(1);
};

const transfer = async (contractAddress, transfers) => {
    const contract = await Tezos.contract.at(contractAddress);
    console.log('running transfers', transfers);
    const result = await contract.methods.transfer(transfers).send();
    await result.confirmation(1);
    return result;
}

const benchmarkTransfer = (contractName) => (testGroup) => async (testCaseName, data, extras) => {
    const operationBenchmark = await benchmarkOperation(data.signer.pkh, async () => {
        return await transfer(data.at, data.transfers);
    });
    console.log('operation benchmark', operationBenchmark);
    await saveBenchmark(contractName, testGroup, testCaseName, operationBenchmark, extras);
};

const runTransferBenchmark = async (contractName, benchmarkData) => {
    const transferGroup = benchmarkTransfer(contractName);

    Object.entries(benchmarkData)
        .forEach(([testGroup, testCases]) => {
            // TODO: introduce dot-notation style test case naming for better benchmark result JSON saving
            describe(testGroup,async () => {
                const transfer = transferGroup(testGroup);
                Object.entries(testCases)
                    .forEach(([testCaseNameStorage, testCaseData]) => {
                        /**
                         * Create a describe block per each initial storage for transfer tests
                         */
                        describe(testCaseNameStorage, async () => {
                            Object.entries(testCaseData.transfers)
                                .forEach(([testCaseName, testCaseConcreteData]) => {
                                    const combinedTestCaseName = `(${testCaseNameStorage}) | (${testCaseName})`;
                                    
                                    describe(combinedTestCaseName, async () => {

                                        let contractAddress;
                                        before(async () => {
                                            /**
                                             * Originate a contract with the predefined storage to run transfers on
                                             */
                                            const operation = await originate(contractName, testCaseData.initialStorage);
                                            contractAddress = operation.contractAddress;
                                            // fund from_/sender addresses
                                            for (const { from_ } of testCaseConcreteData.transfers) {
                                                await drip(from_, 1000);
                                            }
                                            
                                            // reveal the signer in order to exclude the reveal operation from the benchmark below
                                            await reveal(testCaseConcreteData.signer);
                                        })
                                        
                                        /**
                                         * Test a specific transfer scenario within a predefined initial storage
                                         */
                                        it(testCaseName, async () => {
                                            console.log('running test case name', testCaseName);
                                            Tezos.setSignerProvider(new InMemorySigner(testCaseConcreteData.signer.sk));
                                            console.log('transfers', testCaseConcreteData);
                                            await transfer(combinedTestCaseName, {
                                                ...testCaseConcreteData,
                                                at: contractAddress
                                            })
                                        });
                                    });

                                });
                        });
                    });
            });
        });
};

module.exports = { runTransferBenchmark };