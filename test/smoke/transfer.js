const tzip12NFT = artifacts.require('tzip-12-nft-tablespoon');

const tzip12NFTInitialStorage = require('../../migrations/initialStorage/tzip-12-nft-big-map');

const { alice, bob, charlie } = require('../../scripts/sandbox/accounts');
const { defaultTokenId, tzip12NFTTableSpoonStorage } = require('../helpers/storage');
const errors = require('../helpers/errors');

const errorBalanceFromNotDecreased = 'Balance from has not decreased after the transfer';
const errorBalanceToNotIncreased = 'Balance from has not increased after the transfer';

_contract('tzip-12-nft-big-map', () => {
    describe('transfer', () => {
        describe('simple transfers', () => {

            let instance, storage;

            let getBalances = async (tokenId) => ({
                alice: (await storage.getTokenBalance(tokenId, alice.pkh)),
                bob: (await storage.getTokenBalance(tokenId, bob.pkh))
            });

            beforeEach(async () => {
                instance = await tzip12NFT.new(tzip12NFTInitialStorage.withBalances);
                storage = await instance.storage();
                storage = await tzip12NFTTableSpoonStorage(instance, storage);
                console.log('Contract address', instance.address);
            }); 
            
            it(`should transfer 1 token from Alice to Bob`, async () => {
                // TODO: why does the token_id need to be a string in taquito?
                const tokenId = '0';
                const amount = 1;
                
                const balancesBefore = await getBalances(tokenId);
                
                await instance.transfer([{
                    from_: alice.pkh,
                    txs: [{
                        to_: bob.pkh,
                        token_id: tokenId,
                        amount
                    }]
                }]);

                const balancesAfter = await getBalances(tokenId);

                assert(balancesBefore.alice.minus(amount).equals(balancesAfter.alice), errorBalanceFromNotDecreased);
                assert(balancesBefore.bob.plus(amount).equals(balancesAfter.bob), errorBalanceToNotIncreased);

            });

            it(`should fail with a 'token undefined error' if the requested tokenId does not exist`, (done) => {
                // tokenId that does not exist in the contract
                const tokenId = '9999'; 
                const amount = 1;
                // revert to promise API since chai-as-promise can't be configured in truffle
                // https://github.com/trufflesuite/truffle/issues/2090#issuecomment-613076632
                instance.transfer([{
                    from_: alice.pkh,
                    txs: [{
                        to_: bob.pkh,
                        token_id: tokenId,
                        amount
                    }]
                }])
                    .then(() => expect.fail(`Transfer did not fail with 'token undefined error'`))
                    .catch(e => expect(e.message).to.equal(errors.tokenUndefined))
                    .finally(done);
            });

            it(`should fail with an 'insufficient balance error' if Alice does not have enough tokens to transfer`, (done) => {
                const tokenId = '0';
                const amount = 99999;

                instance.transfer([{
                    from_: alice.pkh,
                    txs: [{
                        to_: bob.pkh,
                        token_id: tokenId,
                        amount
                    }]
                }])
                    .then(() => expect.fail(`Transfer did not fail with 'insufficient balance error'`))
                    .catch(e => expect(e.message).to.equal(errors.insufficientBalance))
                    .finally(done);
            });
            
        });

        describe('operator transfers', () => {

            let instance, storage;

            let getBalances = async (tokenId) => ({
                alice: (await storage.getTokenBalance(tokenId, alice.pkh)),
                bob: (await storage.getTokenBalance(tokenId, bob.pkh))
            });

            beforeEach(async () => {
                instance = await tzip12NFT.new(tzip12NFTInitialStorage.withOperators);
                storage = await instance.storage();
                storage = await tzip12NFTTableSpoonStorage(instance, storage);
                console.log('Contract address', instance.address);
            });

            it(`should allow a transfer where the 'from_' address is different from the signer, but the signer is an operator for that address`, async () => {
                const tokenId = '1';
                const amount = 1;

                const balancesBefore = await getBalances(tokenId);

                await instance.transfer([{
                    from_: bob.pkh,
                    txs: [{
                        to_: alice.pkh,
                        token_id: tokenId,
                        amount
                    }]
                }]);

                const balancesAfter = await getBalances(tokenId);
                assert(balancesBefore.bob.minus(amount).equals(balancesAfter.bob), errorBalanceFromNotDecreased);
                assert(balancesBefore.alice.plus(amount).equals(balancesAfter.alice), errorBalanceToNotIncreased);
            });

            // TODO: should the permissioning policy be validated before tha balance or not?
            it(`should fail with 'not an operator' error if Charlie has a sufficient balance but Charlie isn't his operator`, (done) => {
                const tokenId = '2';
                const amount = 1;

                instance.transfer([{
                    from_: charlie.pkh,
                    txs: [{
                        to_: alice.pkh,
                        token_id: tokenId,
                        amount
                    }]
                }])
                    .then(() => expect.fail(`Transfer did not fail with 'not an operator error'`))
                    .catch(e => expect(e.message).to.equal(errors.notOperator))
                    .finally(done);
            });
        })
    });
});