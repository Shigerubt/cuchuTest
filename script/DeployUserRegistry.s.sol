// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/Vm.sol";
import "../src/UserRegistry.sol";

contract DeployUserRegistry is Script {
    Vm vm = Vm(HEVM_ADDRESS); // HEVM_ADDRESS is a constant provided by forge-std that points to the address of the Vm

    function run() external returns(UserRegistry) {
       vm.startBroadcasting();
       UserRegistry userRegistry = new UserRegistry();
       vm.stopBroadcasting();
       return userRegistry;
    }
}