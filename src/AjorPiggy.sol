// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract AjorPiggy is ERC721, Ownable {
    using Strings for uint256;
    uint256 public contributionAmount = 0.001 ether;
    uint256 public totalContributions;
    uint256 private tokenIdCounter;
    mapping(address => bool) public hasContributed;
    mapping(uint256 => string) private tokenURIs;

    event NewContribution(address contributor, uint256 tokenId);

    modifier onlyOwner() override virtual {
        require(owner() == msg.sender, "Caller is not the owner");
        _;
    }

    constructor() ERC721("Ajor Piggy", "AJP") Ownable(msg.sender) {}

    function contribute() public payable {
        require(!hasContributed[msg.sender], "Already contributed");
        require(msg.value >= contributionAmount, "Contribution amount too low");

        ++tokenIdCounter;
        _safeMint(msg.sender, tokenIdCounter);

        hasContributed[msg.sender] = true;
        totalContributions += msg.value;
        emit NewContribution(msg.sender, tokenIdCounter);
    }

    function hasTicket(address user) public view returns (bool) {
        return hasContributed[user];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(tokenId <= tokenIdCounter, "ERC721Metadata: URI query for nonexistent token");
        string memory name = string(abi.encodePacked("AjoPiggy #", tokenId.toString()));
        string memory description = "You have a contributed";
        string memory image = _generateBase64Image();
        string memory json = string(
            abi.encodePacked('{"name":"', name, '",', '"description":"', description, '",', '"image":"', image, '"}')
        );
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(json))));
    }

    function _generateBase64Image() internal pure returns (string memory) {
        string memory svg =
            '<svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="300.000000pt" height="147.000000pt" viewBox="0 0 300.000000 147.000000" preserveAspectRatio="xMidYMid meet">'
            '<g transform="translate(0.000000,147.000000) scale(0.100000,-0.100000)" fill="#000000" stroke="none">'
            '<path d="M1622 1439 c-29 -11 -85 -24 -123 -29 -76 -11 -109 -25 -159 -66 l-31 -27 6 36 c4 21 5 37 2 37 -13 0 -129 -84 -146 -106 -10 -13 -26 -24 -34 -24 -8 0 -20 -6 -26 -14 -7 -8 -20 -12 -30 -9 -10 2 -35 -2 -55 -11 -43 -18 -120 -76 -112 -84 3 -3 14 2 23 10 24 20 79 38 118 38 l33 0 -5 -47 c-2 -27 -9 -61 -15 -76 -13 -33 -4 -122 18 -189 22 -68 34 -68 18 0 -8 31 -14 65 -14 75 0 27 17 20 23 -10 6 -30 57 -113 69 -113 4 0 5 7 2 15 -9 22 3 18 15 -4 8 -14 5 -32 -11 -71 -23 -55 -18 -69 25 -70 11 0 17 -8 17 -24 0 -13 6 -26 13 -29 7 -2 -6 -20 -33 -44 -25 -23 -51 -52 -58 -65 -11 -19 -29 -28 -84 -41 -45 -11 -84 -28 -110 -48 -21 -17 -37 -33 -34 -36 2 -2 39 10 83 27 43 18 85 35 93 38 10 3 7 -3 -7 -19 -11 -13 -26 -42 -32 -64 -13 -47 -15 -125 -3 -125 4 0 26 50 48 111 27 76 52 127 81 164 47 59 83 86 83 61 0 -8 8 -17 19 -21 10 -3 21 -19 25 -36 3 -16 12 -32 20 -35 8 -3 44 10 79 30 35 20 67 33 70 29 14 -13 6 -28 -23 -45 -36 -20 -70 -73 -70 -109 0 -23 -13 -34 -92 -80 -51 -30 -97 -56 -103 -57 -29 -10 -83 -37 -107 -53 -14 -11 -33 -19 -42 -19 -8 0 -19 -6 -23 -13 -13 -21 -110 -76 -119 -67 -5 4 -34 10 -65 14 -61 6 -87 -8 -75 -39 3 -9 -1 -18 -9 -21 -9 -4 -15 -18 -14 -38 1 -30 1 -30 9 -6 6 20 9 22 14 9 4 -9 6 -22 4 -29 -2 -7 2 -14 9 -17 8 -3 10 14 6 61 l-5 66 46 0 c35 0 46 -4 46 -15 0 -9 -7 -18 -16 -22 -20 -7 -34 -45 -27 -72 5 -22 39 -29 45 -10 2 7 17 7 48 0 25 -6 56 -11 69 -11 23 0 24 1 7 13 -17 13 -15 16 30 41 26 15 54 24 61 22 7 -3 17 4 23 14 18 34 30 22 30 -30 0 -27 4 -50 9 -50 5 0 18 -3 28 -6 15 -5 15 -4 3 5 -13 9 -12 11 4 11 16 0 18 6 11 56 -5 40 -3 54 4 50 6 -4 11 -28 11 -54 0 -46 13 -82 25 -70 6 6 -9 111 -20 141 -5 12 -2 17 10 17 10 0 23 6 29 13 13 16 166 100 166 91 0 -3 -15 -38 -34 -77 -19 -40 -43 -98 -55 -129 -19 -54 -19 -58 -3 -58 12 1 35 38 77 121 l60 121 56 2 57 3 -38 -56 c-20 -31 -54 -86 -74 -123 -35 -64 -36 -68 -17 -68 12 0 21 5 21 11 0 8 4 8 14 0 17 -14 20 -10 36 49 28 106 71 199 102 221 17 12 41 45 53 74 19 41 37 62 87 98 76 53 124 112 120 144 -2 15 2 23 11 23 8 0 22 9 33 21 l19 21 17 -22 c25 -31 23 -39 -16 -55 -19 -8 -47 -26 -63 -41 -25 -23 -26 -27 -10 -35 27 -16 21 -24 -40 -52 -32 -15 -71 -38 -88 -53 -32 -27 -17 -23 25 8"/>'
            "</g></svg>";

        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svg))));
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        (bool isSuccess, ) = payable(owner()).call{value: balance}("");
        require(isSuccess, "Transfer failed");
    }
}