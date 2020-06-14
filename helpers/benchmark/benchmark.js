const { alice } = require('../../scripts/sandbox/accounts');
const { uniq, merge } = require('lodash');
const { readJSON, outputFile } = require('fs-extra')
const { Tezos } = require('@taquito/taquito');
const jsonFormat = require('json-format')

const getBalance = async (pkh) => (await Tezos.tz.getBalance(pkh)).toNumber();
const benchmarkOperation = async (pkh, fn) => {
    const balanceBefore = await getBalance(pkh);
    const operation = await fn();
    const balanceAfter = await getBalance(pkh);
    const results = operation.results[0];
    /**
     * Use the estimated values for benchmark results
     */
    return {
        estimate: {
            fee: results.fee,
            storageLimit: results.storage_limit,
            gasLimit: results.gas_limit,
        },
        totalCost: balanceBefore - balanceAfter,
        address: operation.contractAddress
    };
}

const saveBenchmark = async (contractName, testGroup, testCase, results, extras = {}) => {
    const path = `${process.cwd()}/benchmarks.json`;
    let previousResults = {
        contracts: []
    };
    try { previousResults = await readJSON(path); } catch(e) {}
    previousResults.contracts.push(contractName);
    previousResults.contracts = uniq(previousResults.contracts);
    return outputFile(path, jsonFormat(merge({}, previousResults, {
        cases: {
            [testGroup]: {
                [`${testCase}`]: {
                    [contractName]: {
                        results,
                        extras
                    }
                }
            }
        }
    })));
}

module.exports = { saveBenchmark, benchmarkOperation, getBalance }