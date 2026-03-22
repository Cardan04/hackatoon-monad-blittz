// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./HypeToken.sol";
import "./HypePass.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract HypeCore is Ownable, ReentrancyGuard {
    HypeToken public immutable hypeToken;
    HypePass public immutable hypePass;

    uint256 public constant ROYALTY_PERCENT = 10;

    address public admin;

    mapping(address => bool) public isOrganizer;

    struct Event {
        uint256 price;
        uint256 rewardAmount;     // cashback/recompensa em $HYPE
        address organizer;
        bool isActive;
    }

    struct Listing {
        address seller;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Event) public events;
    mapping(uint256 => Listing) public marketplace;

    event TicketPurchased(address indexed buyer, uint256 eventId, uint256 tokenId);
    event AchievementAdded(uint256 indexed tokenId, string label);
    event SecondarySale(uint256 indexed tokenId, address from, address to, uint256 price);
    event EventCreated(uint256 indexed eventId, address organizer, uint256 price, uint256 reward);

    constructor(address _token, address _pass) Ownable(msg.sender) {
        hypeToken = HypeToken(_token);
        hypePass = HypePass(_pass);
        admin = msg.sender;
        isOrganizer[msg.sender] = true;
    }

    // ── Organizers management ────────────────────────────────────────

    function addOrganizer(address newOrganizer) external {
        require(msg.sender == admin || msg.sender == owner(), "Not authorized");
        isOrganizer[newOrganizer] = true;
    }

    function removeOrganizer(address organizer) external {
        require(msg.sender == admin || msg.sender == owner(), "Not authorized");
        isOrganizer[organizer] = false;
    }

    // ── Event creation ───────────────────────────────────────────────

    function createEvent(
        uint256 eventId,
        uint256 price,
        uint256 rewardAmount
    ) external {
        require(isOrganizer[msg.sender], "Not an organizer");
        require(events[eventId].organizer == address(0), "Event ID already used");
        require(price > 0, "Price must be > 0");

        events[eventId] = Event({
            price: price,
            rewardAmount: rewardAmount,
            organizer: msg.sender,
            isActive: true
        });

        emit EventCreated(eventId, msg.sender, price, rewardAmount);
    }

    // ── Buy ticket (primary market) ─────────────────────────────────

    function buyTicket(uint256 eventId) external nonReentrant {
        Event memory ev = events[eventId];
        require(ev.isActive, "Event is not active");
        require(ev.price > 0, "Invalid event");

        // Pagamento para o organizador
        hypeToken.transferFrom(msg.sender, ev.organizer, ev.price);

        // Mint do cashback/recompensa (se configurado)
        if (ev.rewardAmount > 0) {
            hypeToken.mint(msg.sender, ev.rewardAmount);
        }

        // Mint do NFT
        uint256 tokenId = hypePass.mintTicket(msg.sender, eventId);

        emit TicketPurchased(msg.sender, eventId, tokenId);
    }

    // ── Marketplace (secondary market) ──────────────────────────────

    function listTicket(uint256 tokenId, uint256 price) external {
        require(hypePass.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be > 0");

        marketplace[tokenId] = Listing({
            seller: msg.sender,
            price: price,
            active: true
        });
    }

    function buyFromMarketplace(uint256 tokenId) external nonReentrant {
        Listing memory item = marketplace[tokenId];
        require(item.active, "Not for sale");

        uint256 eventId = hypePass.getEventId(tokenId);
        Event memory ev = events[eventId];
        require(ev.organizer != address(0), "Invalid event");

        uint256 royalty = (item.price * ROYALTY_PERCENT) / 100;
        uint256 sellerAmount = item.price - royalty;

        // Pagamentos
        hypeToken.transferFrom(msg.sender, item.seller, sellerAmount);
        hypeToken.transferFrom(msg.sender, ev.organizer, royalty);

        // Transferência do NFT
        hypePass.transferFrom(item.seller, msg.sender, tokenId);

        marketplace[tokenId].active = false;

        emit SecondarySale(tokenId, item.seller, msg.sender, item.price);
    }

    // ── Award achievement ("carimbo") ───────────────────────────────

    function awardAchievement(uint256 tokenId, string calldata label) external {
        uint256 eventId = hypePass.getEventId(tokenId);
        Event memory ev = events[eventId];

        require(
            msg.sender == ev.organizer || msg.sender == admin || msg.sender == owner(),
            "Not authorized"
        );

        hypePass.addAchievement(tokenId, label);
        emit AchievementAdded(tokenId, label);
    }

    // Admin pode pausar evento se necessário
    function setEventActive(uint256 eventId, bool active) external {
        require(msg.sender == admin || msg.sender == owner(), "Not authorized");
        require(events[eventId].organizer != address(0), "Event does not exist");
        events[eventId].isActive = active;
    }
}