// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {WeatherNft} from "../src/WeatherNft.sol";

contract CounterScript is Script {
    WeatherNft public weatherNft;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        weatherNft = new WeatherNft(address(this), "WeatherNft", "WNFT");

        vm.stopBroadcast();
    }
}
