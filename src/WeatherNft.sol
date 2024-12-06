// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WeatherNft is ERC721, Ownable {
    uint256 public tokenCounter;

    struct WeatherData {
        int256 temperature;
        uint256 humidity;
        uint256 windSpeed;
        string conditionImageURI;
        uint256 timestamp;
    }
    mapping(uint256 => WeatherData[]) public tokenWeatherHistory;

    constructor(
        address initialOwner,
        string memory name,
        string memory symbol
    ) Ownable(initialOwner) ERC721(name, symbol) {
        tokenCounter = 0;
    }

    function mintNFT(address recipient) public onlyOwner returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(recipient, newTokenId);
        tokenCounter += 1;
        return newTokenId;
    }

    function updateWeatherData(
        uint256 tokenId,
        int256 temperature,
        uint256 humidity,
        uint256 windSpeed,
        string memory conditionImageURI
    ) public onlyOwner {
        WeatherData memory newWeatherData = WeatherData(
            temperature,
            humidity,
            windSpeed,
            conditionImageURI,
            block.timestamp
        );
        tokenWeatherHistory[tokenId].push(newWeatherData);
    }

    function getWeatherData(
        uint256 tokenId,
        uint256 index
    ) public view returns (WeatherData memory) {
        ownerOf(tokenId);
        return tokenWeatherHistory[tokenId][index];
    }

    function getWeatherDataByPeriod(
        uint256 tokenId,
        uint256 period
    ) public view returns (WeatherData[] memory) {
        ownerOf(tokenId);
        uint256 currentTime = block.timestamp;
        uint256 count;

        for (uint256 i = 0; i < tokenWeatherHistory[tokenId].length; i++) {
            if (
                currentTime - tokenWeatherHistory[tokenId][i].timestamp <=
                period
            ) {
                count++;
            }
        }

        WeatherData[] memory filteredData = new WeatherData[](count);
        uint256 index = 0;

        for (uint256 i = 0; i < tokenWeatherHistory[tokenId].length; i++) {
            if (
                currentTime - tokenWeatherHistory[tokenId][i].timestamp <=
                period
            ) {
                filteredData[index] = tokenWeatherHistory[tokenId][i];
                index++;
            }
        }

        return filteredData;
    }
}
