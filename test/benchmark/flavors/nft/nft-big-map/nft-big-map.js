const contractName = 'tzip-12-nft-big-map';
const { runOriginationBenchmark } = require('./../../../../../helpers/benchmark/origination');
const { runTransferBenchmark } = require('./../../../../../helpers/benchmark/transfer');

/**
 * Benchmarks have to be ran one by one at the moment due to counter issues, unless .forEach is replaced with an async-friendly `for of`
 */
describe(contractName, async () => {
    // await runOriginationBenchmark(contractName, require('./data/origination')().data);
    // runTransferBenchmark(contractName, require('./data/transfer')().data);
})