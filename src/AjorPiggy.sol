// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721Enumerable, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
// import {} from "@openzeppelin/contract/"
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract AjorPiggy is ERC721Enumerable {
    using Strings for uint256;

   address public owner;
   uint256 public tokenId;

   uint256 public totalEtherRaised;

   mapping(uint256 => uint256) public contributionAmount;
   mapping(address => uint256) public addressToTotalContribution;

    event ContributionReceived(address indexed contributor, uint256 amount, uint256 tokenId);
    event FundsWithdrawn(address indexed owner, uint256 amount);
   constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    owner = msg.sender;
   }

   function contribute() public payable {
   require(msg.value > 0, "Not enough funds");
    require(addressToTotalContribution[msg.sender] == 0, "Have already contributed");
    tokenId += 1;
    _safeMint(msg.sender, tokenId);
      contributionAmount[tokenId] = msg.value;
   
      totalEtherRaised += msg.value;

      addressToTotalContribution[msg.sender] += msg.value;

      emit ContributionReceived(msg.sender, msg.value, tokenId);
   }

//    function tokenURI(int256 tokenId) public view override returns (string memory) {
//     require(contributionAmount[tokenId] > 0, "Token does not exist");

//     // Generate a simple SVG image with the token ID
//     string memory svg = string(
//             abi.encodePacked(
//                 "<svg xmlns='http://www.w3.org/2000/svg' width='200' height='200'>",
//                 "<rect width='200' height='200' fill='lightblue'/>",
//                 "<text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='24'>",
//                 "Token #",
//                 toString(tokenId),
//                 "</text>",
//                 "</svg>"
//             )
//         );
    
//     string memory image = string(
//             abi.encodePacked(
//                 "data:image/svg+xml;base64,",
//                 base64Encode(bytes(svg))
//             )
//         );

//      return string(
//             abi.encodePacked(
//                 "data:application/json;base64,",
//                 base64Encode(
//                     bytes(
//                         abi.encodePacked(
//                             '{"name":"Contribution NFT #',
//                             toString(tokenId),
//                             '","description":"An on-chain NFT for contributing Ether.",',
//                             '"image":"',
//                             image,
//                             '"}'
//                         )
//                     )
//                 )
//             )
//         );
//    }



   receive() external payable {
        contribute();
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
    