// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IERC20 {
    function transfer(address _to, uint256 _value) external returns (bool);
    
    // don't need to define other functions, only using `transfer()` in this case
}

contract DeposWithdToken {
    // Do not use in production
    // This function can be executed by anyone
    function sendGHT(address _to, uint256 _amount) external {

        
         // This is the mainnet USDT contract address
         // Using on other networks (rinkeby, local, ...) would fail
         //  - there's no contract on this address on other networks
        IERC20 ght = IERC20(address(0x7dDf41C60930621c53027cbE51652FC577ce10D2));
       // require(ght.balanceOf(msg.sender) >= 100);

        // transfers USDT that belong to your contract to the specified address
        ght.transfer(_to, _amount);
    }
}