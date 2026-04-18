// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract JapaneseWashiCraftRegistry {

    struct WashiTechnique {
        string region;        // Echizen, Mino, Tosa, etc.
        string workshop;      // papermaking families or cooperatives
        string techniqueName; // nagashizuki, fiber preparation, drying method
        string materialType;  // kozo, mitsumata, gampi, wooden tools
        string culturalNote;  // historical or cultural context
        string ritualUse;     // ceremonial, archival, artistic, or traditional purpose
        address creator;
        uint256 likes;
        uint256 dislikes;
        uint256 createdAt;
    }

    WashiTechnique[] public techniques;

    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event TechniqueRecorded(
        uint256 indexed id,
        string techniqueName,
        string workshop,
        address indexed creator
    );

    event TechniqueVoted(
        uint256 indexed id,
        bool like,
        uint256 likes,
        uint256 dislikes
    );

    constructor() {
        techniques.push(
            WashiTechnique({
                region: "Japan",
                workshop: "ExampleWorkshop",
                techniqueName: "Example Technique (replace with real entries)",
                materialType: "example material",
                culturalNote: "This is an example entry to illustrate the format.",
                ritualUse: "Real entries should describe documented traditional use.",
                creator: address(0),
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );
    }

    function recordTechnique(
        string calldata region,
        string calldata workshop,
        string calldata techniqueName,
        string calldata materialType,
        string calldata culturalNote,
        string calldata ritualUse
    ) external {
        require(bytes(region).length > 0, "Region required");
        require(bytes(workshop).length > 0, "Workshop required");
        require(bytes(techniqueName).length > 0, "Technique name required");

        techniques.push(
            WashiTechnique({
                region: region,
                workshop: workshop,
                techniqueName: techniqueName,
                materialType: materialType,
                culturalNote: culturalNote,
                ritualUse: ritualUse,
                creator: msg.sender,
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );

        emit TechniqueRecorded(
            techniques.length - 1,
            techniqueName,
            workshop,
            msg.sender
        );
    }

    function voteTechnique(uint256 id, bool like) external {
        require(id < techniques.length, "Invalid ID");
        require(!hasVoted[id][msg.sender], "Already voted");

        hasVoted[id][msg.sender] = true;

        WashiTechnique storage t = techniques[id];

        if (like) {
            t.likes += 1;
        } else {
            t.dislikes += 1;
        }

        emit TechniqueVoted(id, like, t.likes, t.dislikes);
    }

    function totalTechniques() external view returns (uint256) {
        return techniques.length;
    }
}
