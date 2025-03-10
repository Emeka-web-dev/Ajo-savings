// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {AjorPiggy} from "../src/AjorPiggy.sol";

contract AjorPiggyScript is Script {
    AjorPiggy public ajorpiggy;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        ajorpiggy = new AjorPiggy();
        vm.stopBroadcast();
    }
}
