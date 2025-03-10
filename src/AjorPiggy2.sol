// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract ContributionNFT is ERC721, Ownable {
//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIdCounter;

//     // Event to log contributions
//     event ContributionMade(address indexed contributor, uint256 amount, uint256 tokenId);

//     constructor() ERC721("ContributionNFT", "CNFT") {}

//     // Function to contribute Ether and receive an NFT
//     function contribute() external payable {
//         require(msg.value > 0, "Must send Ether to contribute");

//         // Mint an NFT to the contributor
//         uint256 tokenId = _tokenIdCounter.current();
//         _safeMint(msg.sender, tokenId);
//         _tokenIdCounter.increment();

//         // Emit an event for the contribution
//         emit ContributionMade(msg.sender, msg.value, tokenId);
//     }

//     // Function to generate on-chain metadata (SVG image)
//     function tokenURI(uint256 tokenId) public view override returns (string memory) {
//         require(_exists(tokenId), "Token does not exist");

//         // Generate a simple SVG image with the token ID
//         string memory svg = string(
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

//         // Encode the SVG image in base64
//         string memory image = string(
//             abi.encodePacked(
//                 "data:image/svg+xml;base64,",
//                 base64Encode(bytes(svg))
//             )
//         );

//         // Return the metadata as a JSON object
//         return string(
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
//     }

//     // Helper function to convert uint256 to string
//     function toString(uint256 value) internal pure returns (string memory) {
//         if (value == 0) {
//             return "0";
//         }
//         uint256 temp = value;
//         uint256 digits;
//         while (temp != 0) {
//             digits++;
//             temp /= 10;
//         }
//         bytes memory buffer = new bytes(digits);
//         while (value != 0) {
//             digits -= 1;
//             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
//             value /= 10;
//         }
//         return string(buffer);
//     }

//     // Helper function to encode bytes in base64
//     function base64Encode(bytes memory data) internal pure returns (string memory) {
//         string memory table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//         uint256 length = data.length;
//         if (length == 0) return "";

//         // Encode the bytes
//         string memory result = new string(4 * ((length + 2) / 3));
//         assembly {
//             let tablePtr := add(table, 1)
//             let resultPtr := add(result, 32)

//             for {
//                 let i := 0
//             } lt(i, length) {

//             } {
//                 i := add(i, 3)
//                 let input := and(mload(add(data, i)), 0xFFFFFF)
//                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
//                 out := shl(8, out)
//                 out := add(out, mload(add(tablePtr, and(shr(12, input), 0x3F))))
//                 out := shl(8, out)
//                 out := add(out, mload(add(tablePtr, and(shr(6, input), 0x3F))))
//                 out := shl(8, out)
//                 out := add(out, mload(add(tablePtr, and(input, 0x3F))))
//                 out := shl(224, out)
//                 mstore(resultPtr, out)
//                 resultPtr := add(resultPtr, 4)
//             }

//             switch mod(length, 3)
//             case 1 {
//                 mstore(sub(resultPtr, 2), shl(240, 0x3D3D))
//             }
//             case 2 {
//                 mstore(sub(resultPtr, 1), shl(248, 0x3D))
//             }
//         }
//         return result;
//     }

//     // Withdraw Ether from the contract (only owner)
//     function withdraw() external onlyOwner {
//         payable(owner()).transfer(address(this).balance);
//     }
// }