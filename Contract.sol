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
// Mapping to store species information using their IDs
    mapping(uint256 => Species) public speciesMap;

    // Counter to keep track of the total number of species created
    uint256 public numberOfSpecies = 0; 

    // Constructor to initialize the ERC721 contract with a name and symbol
    constructor() ERC721("ConservationNFT", "CNFT") {} 

    // Function to create a new conservation species campaign
    function createSpecies(
        string memory _name,
        string memory _description,
        uint256 _targetAmount,
        uint256 _nftPrice,
        uint256 _maxNFTs,
        string memory _image
    ) public {
        // Ensure there's a limit on NFTs and they have a price
        require(_maxNFTs > 0, "Maximum NFTs must be greater than 0");
        require(_nftPrice > 0, "NFT price must be greater than 0");
