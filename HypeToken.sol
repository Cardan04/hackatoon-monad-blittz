// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HypeToken is ERC20, Ownable {
    mapping(address => bool) public minters;

    constructor() ERC20("Hype Token", "HYPE") Ownable(msg.sender) {
        _mint(msg.sender, 100_000_000 * 10**decimals()); // supply inicial exemplo
        minters[msg.sender] = true;
    }

    modifier onlyMinter() {
        require(minters[msg.sender], "Caller is not a minter");
        _;
    }

    function addMinter(address account) external onlyOwner {
        minters[account] = true;
    }

    function removeMinter(address account) external onlyOwner {
        minters[account] = false;
    }

    function mint(address to, uint256 amount) external onlyMinter {
        _mint(to, amount);
    }
}