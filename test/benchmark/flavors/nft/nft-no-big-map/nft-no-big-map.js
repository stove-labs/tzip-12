const contractName = 'tzip-12-nft-no-big-map';
const { runOriginationBenchmark } = require('./../../../../../helpers/benchmark/origination');
const { runTransferBenchmark } = require('./../../../../../helpers/benchmark/transfer');


/**
 * Benchmarks have to be ran one by one at the moment, unless .forEach is replaced with an async-friendly `for of`
 */
describe(contractName, async () => {
    // await runOriginationBenchmark(contractName, require('./../nft-big-map/data/origination')().data);
    // runTransferBenchmark(contractName, require('./../nft-big-map/data/transfer')().data);
})