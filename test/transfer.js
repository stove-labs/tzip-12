const tzip12NFT = artifacts.require('tzip-12-nft-tablespoon');
const tzip12FT = artifacts.require('tzip-12-ft-tablespoon');

const { alice, bob } = require('../scripts/sandbox/accounts');

// TODO: figure out what overwrites global `contract` in benchmark tests
contractTruffle('tzip-12-nft-tablespoon', () => {
    describe('transfer', () => {
        it('should transfer 1 token from Alice to Bob', async () => {
            const tzip12Instance = await tzip12NFT.deployed();
            const tokenId = '0';
            const storage = await tzip12Instance.storage();
            const tokenOwnerBefore = await storage.tokensLedger.get(tokenId);

            const transferParam = [
                {
                    from_: alice.pkh,
                    txs: [
                        {
                            to_: bob.pkh,
                            token_id: tokenId,
                            amount: 1
                        }
                    ]
                }
            ];
            await tzip12Instance.transfer(transferParam);
            
            const tokenOwnerAfter = await storage.tokensLedger.get(tokenId);
            assert.equal(tokenOwnerBefore, alice.pkh);
            assert.equal(tokenOwnerAfter, bob.pkh);
        });

        it('should transfer 1 token from Bob to Alice using Alice as an operator/signer', async () => {
            const tzip12Instance = await tzip12NFT.deployed();
            const tokenId = '0';
            const storage = await tzip12Instance.storage();
            const tokenOwnerBefore = await storage.tokensLedger.get(tokenId);

            const transferParam = [
                {
                    from_: bob.pkh,
                    txs: [
                        {
                            to_: alice.pkh,
                            token_id: tokenId,
                            amount: 1
                        }
                    ]
                }
            ];
            await tzip12Instance.transfer(transferParam);
            
            const tokenOwnerAfter = await storage.tokensLedger.get(tokenId);
            assert.equal(tokenOwnerBefore, bob.pkh);
            assert.equal(tokenOwnerAfter, alice.pkh);
        });

    });
});

contractTruffle('tzip-12-ft-tablespoon', () => {
    describe('transfer', () => {

        let tzip12Instance;
        let storage;

        before(async () => {
            tzip12Instance = await tzip12FT.deployed();
            storage = await tzip12Instance.storage();
        });

        it('should transfer 1 token from Alice to Bob', async () => {
            const tokenId = '0';
            
            console.log('address', tzip12Instance.address);
            const tokenBalanceFromBefore = (await storage.tokensLedger.get([alice.pkh, tokenId])).toNumber();

            const transferParam = [
                {
                    from_: alice.pkh,
                    txs: [
                        {
                            to_: bob.pkh,
                            token_id: tokenId,
                            amount: 1
                        }
                    ]
                }
            ];
            await tzip12Instance.transfer(transferParam);
            
            const tokenBalanceFromAfter = (await storage.tokensLedger.get([alice.pkh, tokenId])).toNumber();
            const tokenBalanceToAfter = (await storage.tokensLedger.get([bob.pkh, tokenId])).toNumber();

            assert.equal(tokenBalanceFromBefore - 1, tokenBalanceFromAfter);
            assert.equal(tokenBalanceToAfter, 1);
        });

        it('should transfer 1 token from Bob to Alice using Alice as an operator/signer', async () => {
            const tokenId = '0';
            const tokenBalanceFromBefore = (await storage.tokensLedger.get([bob.pkh, tokenId])).toNumber();
            const tokenBalanceToBefore = (await storage.tokensLedger.get([alice.pkh, tokenId])).toNumber();
            console.log('address2', tzip12Instance.address);

            const transferParam = [
                {
                    from_: bob.pkh,
                    txs: [
                        {
                            to_: alice.pkh,
                            token_id: tokenId,
                            amount: 1
                        }
                    ]
                }
            ];
            await tzip12Instance.transfer(transferParam);
            
            const tokenBalanceFromAfter = (await storage.tokensLedger.get([bob.pkh, tokenId])).toNumber();
            const tokenBalanceToAfter = (await storage.tokensLedger.get([alice.pkh, tokenId])).toNumber();
            assert.equal(tokenBalanceFromBefore - 1, tokenBalanceFromAfter);
            assert.equal(tokenBalanceToBefore + 1, tokenBalanceToAfter);
        });

    });
});