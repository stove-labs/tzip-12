// TODO: figure out what overwrites global `contract` in benchmark tests
global._contract = contract;

const { Tezos } = require('@taquito/taquito');
const { InMemorySigner } = require('@taquito/signer');
const { alice } = require('../../scripts/sandbox/accounts');

Tezos.setProvider({
    rpc: 'http://localhost:8732',
    signer: new InMemorySigner(alice.sk)
});

contract('benchmark', () => {
    require('./flavors/nft/nft-big-map/nft-big-map');
    require('./flavors/nft/nft-no-big-map/nft-no-big-map');
});