const tzip12NFT = artifacts.require('tzip-12-nft-tablespoon');

const tzip12NFTInitialStorage = require('../../migrations/initialStorage/tzip-12-nft-big-map');

const { alice, bob } = require('../../scripts/sandbox/accounts');
const { defaultTokenId, tzip12NFTTableSpoonStorage, getOperators, isOperator } = require('../helpers/storage');
const errors = require('../helpers/errors');

_contract('tzip-12-nft-big-map', () => {
    describe('update operators', () => {
        describe('add operator', () => {
        
            let instance, storage;
            beforeEach(async () => {
                instance = await tzip12NFT.new(tzip12NFTInitialStorage.withBalances);
                storage = await instance.storage();
                storage = await tzip12NFTTableSpoonStorage(instance, storage);
                console.log('contract', instance.address);
            });

            it('should add an operator for Alice', async () => {
                const tokenOwner = alice.pkh;
                const tokenOperator = bob.pkh;
                const operatorsBefore = await storage.getOperators(tokenOwner);
                await instance.update_operators([{
                    'add_operator': {
                        owner: tokenOwner,
                        operator: tokenOperator
                    }
                }]);
                const operatorsAfter = await storage.getOperators(tokenOwner);
                expect(operatorsBefore).to.deep.equal([])
                expect(operatorsAfter).to.deep.equal([tokenOperator]);
            });

            it('should not be possible to add an operator for someone else', (done) => {
                const tokenOwner = bob.pkh;
                const tokenOperator = alice.pkh;
                instance.update_operators([{
                    'add_operator': {
                        owner: tokenOwner,
                        operator: tokenOperator
                    }
                }])
                    .then(() => expect.fail('Operator update should not be allowed for someone else'))
                    .catch(e => expect(e.message).to.equal(errors.operatorUpdateDenied))
                    .finally(done);
            })

        });

        describe('remove operator', () => {

            let instance, storage;
            beforeEach(async () => {
                instance = await tzip12NFT.new(tzip12NFTInitialStorage.withOperators);
                storage = await instance.storage();
                storage = await tzip12NFTTableSpoonStorage(instance, storage);
                console.log('contract', instance.address);
            });

            it('should remove an operator for Alice', async () => {
                const tokenOwner = alice.pkh;
                const tokenOperator = bob.pkh;
                const operatorsBefore = await storage.getOperators(tokenOwner);
                await instance.update_operators([{
                    'remove_operator': {
                        owner: tokenOwner,
                        operator: tokenOperator
                    }
                }]);
                const operatorsAfter = await storage.getOperators(tokenOwner);
                expect(operatorsBefore).to.deep.equal([tokenOperator]);
                expect(operatorsAfter).to.deep.equal([]);
            })
        })

    });
});