// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.9; // Specifies the Solidity compiler version

// Import the ERC721 standard for creating NFTs
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AnimalConservation is ERC721 {
    // Struct to store information about each conservation species campaign
    struct Species {
        uint256 speciesId;        // Unique ID for each species
        string name;               // Name of the species
        string description;        // Description of the conservation effort
        uint256 targetAmount;      // Fundraising goal for this species
        uint256 amountCollected;   // Total funds collected so far
        uint256 nftPrice;          // Price of one NFT for this species
        uint256 maxNFTs;           // Maximum number of NFTs that can be minted
        uint256 totalMinted;       // Number of NFTs minted so far
        string image;              // Image URL representing the species
        address[] contributors;    // List of addresses who contributed
        uint256[] contributions;   // Corresponding contribution amounts
    }
