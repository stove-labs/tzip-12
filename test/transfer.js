const tzip12NFT = artifacts.require('tzip-12-nft-big-map');
const { alice, bob } = require('../scripts/sandbox/accounts');

// TODO: figure out what overwrites global `contract` in benchmark tests
contractTruffle('tzip-12-nft-big-map', () => {
    describe('transfer', () => {
        it('should transfer 1 token from Alice to Bob', async () => {
            const tzip12Instance = await tzip12NFT.deployed();
            const tokenId = '0';
            const storage = await tzip12Instance.storage();
            const tokenOwnerBefore = await storage.tokenOwners.get(tokenId);

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
            
            const tokenOwnerAfter = await storage.tokenOwners.get(tokenId);
            assert.equal(tokenOwnerBefore, alice.pkh);
            assert.equal(tokenOwnerAfter, bob.pkh);
        });
    });
});