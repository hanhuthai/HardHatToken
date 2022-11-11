
**1. Deploy 1 token with Hard hat : https://docs.bnbchain.org/docs/hardhat-new/**
```console
   $ npm install --save-dev hardhat
   $ npm install @nomicfoundation/hardhat-toolbox
   $ npx hardhat compile

   $ npx hardhat run --network testnet scripts/deploy.js

   $ note : use npm>=6 (nvm use 16)

   $  Note: after deploy to blockchain successfully, you need to verify with hardhat
```
**2. token reference**
    $ htd: https://bscscan.com/token/0x5e2689412fae5c29bd575fbe1d5c1cd1e0622a8f#code
    $ aspo: https://bscscan.com/address/0x1a9b49e9f075c37fe5f86c916bac9deb33556d7e#code
    $ HE: https://bscscan.com/token/0x20d39a5130f799b95b55a930e5b7ebc589ea9ed8#code
    $ new  2021-12-30 F2C: https://bscscan.com/address/0x657b632714e08ac66b79444ad3f3875526ee6689#code antiwhale
  
    $mbox: token vesting follow year : https://bscscan.com/address/0x3203c9e46ca618c8c1ce5dc67e7e9d75f5da2377#code
**3. Note**
if rpc failed, change it in https://chainlist.org/chain/97, choose RPC green color