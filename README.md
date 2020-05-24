# TZIP-12 👨‍🍳
<img src="https://stove-labs.com/logo_transparent.png" width="100px"/>

**🚨 This repository has not yet been audited, and should be considered experimental 🚨**

## Introduction
This repository contains a set of specific implementations of the TZIP-12 standard. Together with a set of compatible external smart-contracts, tests and benchmarking scripts. Please cook responsibly 👨‍🍳.

## Quick start

> ⚠️ Please refer to the [tezos-starter-kit](https://github.com/stove-labs/tezos-starter-kit#dependencies) project for a list of dependencies required to get started

```shell
$ git clone https://github.com/stove-labs/tzip-12 my-token
$ cd my-token && npm install
$ npm run env:start
$ npm run migrate 
$ # Navigate to http://localhost:8000 
$ # and search for the (multiple) migrated contract address(-es) [KT1..]
```

## SDK

Part of the TZIP-12 implementation suite is an equivalent Typescript/Javascript SDK, with adapters supporting each individual implementation available. Here's a quick overview of how the SDK can be used:

> Please refer to 👉 [it's dedicated repository](https://github.com/stove-labs/tzip-12-sdk) 👈 for more detailed documentation.

```typescript
// Initialize the SDK with an appropriate implementation adapter
const TZIP12SDK = new TZIP12SDK<StoveLabsPascaligoContractAdapter>({
    adapterFactory: stoveLabsPascaligoContractAdapterFactory(adapterConfig)
});

// Originate a new token contract with Alice owning 100 tokens with ID 0
const alice = 'tz1...';
const myTokenId = 0;
const myTokenOrigination = OriginationToken
    .withId(myTokenId)
    .setBalanceForOwner(
        alice,
        new BigNumber(100)
    );

const originationOperation = await TZIP12SDK.originate({
    tokens: [myTokenOrigination]
});

// Initialize the SDK for a specific TZIP-12 deployment
const TZIP12 = await TZIP12SDK.at(originationOperation.contractAddress!);
// Retrieve information for the given token ID
const myToken = TZIP12.getTokenWithId(0)
// Alice's balance is 100
const balanceForAlice = await myToken.getBalanceForOwner(alice)
```


## Implementation status [1/8]
|Entrypoint| Status
|:----|:----|
|**`transfer`**|✅
|**`balance_of`**|🚧
|**`total_supply`**|🚧
|**`token_metadata`**|🚧
|**`permissions_descriptor`**|🚧
|**`update_operators`**|🚧
|**`is_operator`**|🚧
|**`set_transfer_hook`**|🚧

## Operational costs

As part of this implementation suite rough estimations on operational costs
are provided:

|Operation|# of tokens<sup>1</sup>|# of token IDs<sup>1</sup>|# of owners<sup>2</sup>|👇 Generic|👇 NFT|
|:----|:----|:---|----|----|----|
|**Origination**|-|-|-|-|-|
|Basic|100|1|1|**0.07ꜩ**|**0.03ꜩ**|
|Multiple token IDs|100|2|1|**0.07ꜩ**|**0.03ꜩ**|
|**Transfer**|-|-|-|-|-|
|Basic|1|1|2|**0.07ꜩ**|**0.03ꜩ**|
|**Batch Transfer**|-|-|-|-|-|
|Basic|10|1|2|**0.07ꜩ**|**0.03ꜩ**|
|Multiple token IDs|10|2|2|**0.07ꜩ**|**0.03ꜩ**|
|Multiple recipients|10|1|3|**0.07ꜩ**|**0.03ꜩ**|
|Multiple token IDs & recipients|10|2|3|**0.07ꜩ**|**0.03ꜩ**|

> Please refer to the [Stove Labs' Kitchen](http://kitchen.stove-labs.com/) 👩‍🍳 for an in-depth overview and explanation of the operational costs.

<sup>1</sup>) Number of total tokens transfered in that operation

<sup>2</sup>) Number of different token owners (addresses) involved in that operation

## Documentation

You can find in depth guides and documentation at the [Stove Labs' Kitchen](http://kitchen.stove-labs.com/) 👩‍🍳.