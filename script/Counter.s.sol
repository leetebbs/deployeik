// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

contract CounterScript is Script {
    Counter public counter;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        console.log("Deploying Counter contract...");
        console.log("Using RPC URL:", vm.envString("RPC_URL"));
        
        // Get deployer address and initial balance
        address deployer = vm.addr(deployerPrivateKey);
        uint256 initialBalance = deployer.balance;
        console.log("Deployer address:", deployer);
        console.log("Initial balance:", initialBalance / 1e18, "ETH");
        
        vm.startBroadcast(deployerPrivateKey);

        counter = new Counter();
        
        vm.stopBroadcast();
        
        // Calculate deployment cost
        uint256 finalBalance = deployer.balance;
        uint256 deploymentCost = initialBalance - finalBalance;
        
        console.log("Counter deployed at:", address(counter));
        console.log("Final balance:", finalBalance / 1e18, "ETH");
        console.log("Deployment cost:", deploymentCost / 1e18, "ETH");
        console.log("Deployment cost (wei):", deploymentCost);
    }
}
