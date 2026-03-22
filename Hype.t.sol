// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/HypeToken.sol";
import "../src/HypePass.sol";
import "../src/HypeCore.sol";
import "../src/HypeSale.sol";

contract DeployHype is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        HypeToken token = new HypeToken();
        console.log("HypeToken     ->", address(token));

        HypePass pass = new HypePass();
        console.log("HypePass      ->", address(pass));

        HypeCore core = new HypeCore(address(token), address(pass));
        console.log("HypeCore      ->", address(core));

        HypeSale sale = new HypeSale(address(token));
        console.log("HypeSale      ->", address(sale));

        // Permissões
        token.addMinter(address(core));
        token.addMinter(address(sale));        // ← novo!
        pass.addController(address(core));

        console.log(unicode"Tudo deployado e permissões configuradas!");

        vm.stopBroadcast();
    }
}