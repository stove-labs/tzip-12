const { Tezos } = require('@taquito/taquito');
const { InMemorySigner } = require('@taquito/signer');

const faucet = (fromSecretKey) => async (to, amount) => {
    const oldSigner = Tezos.signer;
    Tezos.setSignerProvider(new InMemorySigner(fromSecretKey));
    const operation = await Tezos.contract.transfer({ to, amount });
    return await operation.confirmation(1);
};

module.exports = { faucet };