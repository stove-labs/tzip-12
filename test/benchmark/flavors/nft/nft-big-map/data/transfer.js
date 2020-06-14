const { merge, times } = require('lodash');
const generateAddress = require('../../../../../../helpers/generateAddress');
const { alice, bob } = require('../../../../../../scripts/sandbox/accounts');

module.exports = () => {
    const originationData = require('./origination')();
    const originationTokens100owners1 = originationData.data.origination["100 tokens, 1 owner"];

    const data = {
        transfer: {
            ['100 tokens, 1 owner']: {
                initialStorage: originationTokens100owners1.initialStorage,
                transfers: {
                    ['1 token to 1 new owner']: {
                        signer: originationData.owners[0],
                        transfers: [
                            {
                                from_: originationData.owners[0].pkh,
                                txs: [
                                    {
                                        to_: alice.pkh,
                                        token_id: '0',
                                        amount: 1
                                    }
                                ]
                            }
                        ]
                    },
                    ['2 tokens to 1 new owner']: {
                        signer: originationData.owners[0],
                        transfers: [
                            {
                                from_: originationData.owners[0].pkh,
                                txs: times(2).map(token_id => ({
                                    to_: alice.pkh,
                                    amount: 1,
                                    token_id
                                }))
                            }
                        ]
                    },
                    ['6 tokens to 1 new owner']: {
                        signer: originationData.owners[0],
                        transfers: [
                            {
                                from_: originationData.owners[0].pkh,
                                txs: times(6).map(token_id => ({
                                    to_: alice.pkh,
                                    amount: 1,
                                    token_id
                                }))
                            }
                        ]
                    },
                    ['10 tokens to 1 new owner']: {
                        signer: originationData.owners[0],
                        transfers: [
                            {
                                from_: originationData.owners[0].pkh,
                                txs: times(10).map(token_id => ({
                                    to_: alice.pkh,
                                    amount: 1,
                                    token_id
                                }))
                            }
                        ]
                    }
                }
            }
        }
    };
    
    return { data };
};