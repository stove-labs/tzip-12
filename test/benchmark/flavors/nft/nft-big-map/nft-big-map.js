const contractName = 'tzip-12-nft-big-map';
const { runOriginationBenchmark } = require('./../../../../../helpers/benchmark/origination');
const { runTransferBenchmark } = require('./../../../../../helpers/benchmark/transfer');

describe(contractName, () => {
    // await runOriginationBenchmark(contractName, require('./data/origination').data);
    runTransferBenchmark(contractName, require('./data/transfer')().data);
})