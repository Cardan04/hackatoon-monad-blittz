// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract HypePass is ERC721, Ownable {
    uint256 private _nextTokenId;

    mapping(address => bool) public controllers;

    mapping(uint256 => uint256) public tokenToEventId;
    mapping(uint256 => string[]) public tokenAchievements;

    constructor() ERC721("Hype Pass", "HYPEPASS") Ownable(msg.sender) {
        controllers[msg.sender] = true;
    }

    modifier onlyController() {
        require(controllers[msg.sender], "Not controller");
        _;
    }

    function addController(address controller) external onlyOwner {
        controllers[controller] = true;
    }

    function removeController(address controller) external onlyOwner {
        controllers[controller] = false;
    }

    function mintTicket(address to, uint256 eventId) external onlyController returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        tokenToEventId[tokenId] = eventId;
        return tokenId;
    }

    function addAchievement(uint256 tokenId, string calldata label) external onlyController {
        require(ownerOf(tokenId) != address(0), "Token does not exist");
        tokenAchievements[tokenId].push(label);
    }

    function getEventId(uint256 tokenId) external view returns (uint256) {
        require(ownerOf(tokenId) != address(0), "Token does not exist");
        return tokenToEventId[tokenId];
    }

    function getAchievements(uint256 tokenId) external view returns (string[] memory) {
        require(ownerOf(tokenId) != address(0), "Token does not exist");
        return tokenAchievements[tokenId];
    }

    // Sobrescrevendo para melhorar UX (opcional)
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);
        return string(abi.encodePacked(
            "ipfs://SEU_BASE_IPFS/",
            Strings.toString(tokenId),
            ".json"
        ));
    }
}