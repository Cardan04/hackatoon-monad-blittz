// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./HypeToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HypeSale is Ownable {
    HypeToken public immutable hypeToken;
    
    // Quanto $HYPE o usuário recebe por 1 MON
    // Exemplo: 1000 = 1 MON → 1000 $HYPE
    uint256 public hypePerMon = 1000 * 1e18;

    event HYPEPurchased(address indexed buyer, uint256 monAmount, uint256 hypeAmount);

    constructor(address _hypeToken) Ownable(msg.sender) {
        hypeToken = HypeToken(_hypeToken);
    }

    // ====================== COMPRA COM MON ======================
    function buyHYPE() external payable {
        require(msg.value > 0, "Envie MON");

        uint256 hypeAmount = (msg.value * hypePerMon) / 1e18;
        require(hypeAmount > 0, "Valor muito pequeno");

        hypeToken.mint(msg.sender, hypeAmount);

        emit HYPEPurchased(msg.sender, msg.value, hypeAmount);
    }

    // Dono do projeto pode mudar o preço quando quiser
    function setPrice(uint256 _hypePerMon) external onlyOwner {
        hypePerMon = _hypePerMon;
    }

    // Retira o MON acumulado (você recebe o dinheiro)
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}