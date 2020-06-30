const BigNumber = require('big-number');
const { charlie } = require('../../scripts/sandbox/accounts');

// TODO: find out why tokenId has to be a string when using taquito
const defaultTokenId = '0';

const tzip12NFTTableSpoonStorage = async (instance, storage) => {
    const getTokenBalance = async (tokenId, tokenOwner) => {
        let realTokenOwner;
        try {
            realTokenOwner = await storage.tokensLedger.get(tokenId);
        } catch (e) {
            console.error(e);
        }
        // TODO: check if tokenOwner is undefined then return 0;
        return (tokenOwner == realTokenOwner) ? BigNumber(1) : BigNumber(0);
    }

    const getOperators = async (tokenOwner) => {
        let operators;
        try {
            operators = await storage.tokenOperators.get(tokenOwner);
        } catch (e) {
            console.error(e);
        }
        // return a default value instead of undefined,
        // this might be counter-intuitive for certain tests
        return operators || [];
    }
    
    const isOperator = async (tokenOwner, tokenOperator) => {
        (await getOperators(tokenOwner)).indexOf(tokenOperator) > -1
    }

    return { getTokenBalance, getOperators, isOperator };
}

const tzip12FTTableSpoonStorage = async (instance, storage) => {
    const getTokenBalance = async (tokenId, tokenOwner) => {
        // TODO: why does taquito return a simple integer instead of a BigNumber here?
        let balance = (await storage.tokensLedger.get([tokenOwner, tokenId]));
        return balance ? BigNumber(parseInt(balance)) : BigNumber(0)
    }

    return { getTokenBalance };
}

module.exports = { tzip12NFTTableSpoonStorage, tzip12FTTableSpoonStorage, defaultTokenId };