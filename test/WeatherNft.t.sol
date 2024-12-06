// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {WeatherNft} from "../src/WeatherNft.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Test, console} from "forge-std/Test.sol";

contract WeatherNftTest is Test {
    WeatherNft weatherNft;

    address user1 = address(0x123);
    address user2 = address(0x456);
    address user3 = address(0x976);

    function setUp() public {
        weatherNft = new WeatherNft(address(this), "WeatherNft", "WNFT");
        vm.deal(user1, 100 ether);
        vm.deal(user2, 1 ether);
        vm.deal(user3, 100 wei);

        console.log("WeatherNftTest contract address", address(this));
        console.log("WeatherNft contract address", address(weatherNft));
    }

    function test_mintNft() public {
        weatherNft.mintNFT(user1);
        assertEq(weatherNft.balanceOf(user1), 1);
    }

    function test_mintNft_fail_notOwner() public {
        vm.startPrank(user1);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                address(user1)
            )
        );
        weatherNft.mintNFT(user1);
        vm.stopPrank();
    }

    function test_updateAndGetWeatherData() public {
        weatherNft.mintNFT(user1);
        weatherNft.updateWeatherData(0, 10, 20, 30, "test");
        vm.startPrank(user1);
        WeatherNft.WeatherData memory data = weatherNft.getWeatherData(0, 0);
        assertEq(data.temperature, 10);
        assertEq(data.humidity, 20);
        assertEq(data.windSpeed, 30);
        assertEq(data.conditionImageURI, "test");
        vm.stopPrank();
    }

    function test_getWeatherDataByPeriod() public {
        weatherNft.mintNFT(user1);
        weatherNft.updateWeatherData(0, 10, 20, 30, "test");
        weatherNft.updateWeatherData(0, 20, 30, 40, "test2");
        vm.startPrank(user1);
        WeatherNft.WeatherData[] memory data = weatherNft
            .getWeatherDataByPeriod(0, 1);
        assertEq(data[1].temperature, 20);
        assertEq(data[1].humidity, 30);
        assertEq(data[1].windSpeed, 40);
        assertEq(data[1].conditionImageURI, "test2");
        vm.stopPrank();
    }
}
