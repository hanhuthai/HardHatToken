Deploy 1 token with Hard hat : https://docs.bnbchain.org/docs/hardhat-new/

npm install --save-dev hardhat
npm install @nomicfoundation/hardhat-toolbox
npx hardhat compile

npx hardhat run --network testnet scripts/deploy.js

note : use npm>=6 (nvm use 16)

Note: after deploy to blockchain successfully, you need to verify with hardhat