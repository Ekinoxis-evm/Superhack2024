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

        // Increment the species counter
        numberOfSpecies++;

        // Create a new Species struct and store it in the mapping
        speciesMap[numberOfSpecies] = Species({
            speciesId: numberOfSpecies, // Assign the new ID
            name: _name,
            description: _description,
            targetAmount: _targetAmount,
            amountCollected: 0, // Initialize collected amount to 0
            nftPrice: _nftPrice,
            maxNFTs: _maxNFTs,
            totalMinted: 0,     // Initialize minted NFTs to 0
            image: _image,
            contributors: new address[](0), // Empty array for contributors
            contributions: new uint256[](0)  // Empty array for contribution amounts
        });
    }

    // Function to contribute to a specific species campaign
    function contributeToSpecies(uint256 _speciesId) public payable {
        // Get the species details from the mapping
        Species storage species = speciesMap[_speciesId];

        // Ensure the contribution is at least the NFT price
        require(msg.value >= species.nftPrice, "Insufficient funds to contribute");

        // Calculate how many NFTs to mint based on the contribution
        uint256 numNFTsToMint = msg.value / species.nftPrice;

        // Check if minting more NFTs would exceed the limit
        require(species.totalMinted + numNFTsToMint <= species.maxNFTs, "Minting limit reached");

        // Add the contributor and their contribution amount to the arrays
        species.contributors.push(msg.sender);
        species.contributions.push(msg.value);

        // Update the total amount collected
        species.amountCollected += msg.value;

        // Update the total number of NFTs minted
        species.totalMinted += numNFTsToMint;

        // Mint the NFTs and send them to the contributor
        for (uint256 i = 0; i < numNFTsToMint; i++) {
            _safeMint(msg.sender, species.totalMinted - numNFTsToMint + i); 
        }
    }

    // Function to get the list of contributors and their contributions for a species
    function getContributors(uint256 _speciesId) view public returns (address[] memory, uint256[] memory) {
        return (speciesMap[_speciesId].contributors, speciesMap[_speciesId].contributions);
    }

    // Function to get all the created species campaigns
    function getAllSpecies() public view returns (Species[] memory) {
        // Create an array to store all species
        Species[] memory allSpecies = new Species[](numberOfSpecies);

        // Iterate through the speciesMap and populate the array
        for (uint256 i = 1; i <= numberOfSpecies; i++) { 
            allSpecies[i - 1] = speciesMap[i];
        }

        return allSpecies;
    }
}
