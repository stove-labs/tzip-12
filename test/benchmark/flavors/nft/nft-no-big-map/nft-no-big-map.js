const contractName = 'tzip-12-nft-no-big-map';
const { runOriginationBenchmark } = require('./../../../../../helpers/benchmark/origination');
const { runTransferBenchmark } = require('./../../../../../helpers/benchmark/transfer');

describe(contractName, () => {
    // await runOriginationBenchmark(contractName, require('./../nft-big-map/data/origination').data);
    runTransferBenchmark(contractName, require('./../nft-big-map/data/transfer')().data);
})