// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../IPoH.sol";

contract MockPoH is IPoH  {
    // on mainnet, the address for the contract that this mock implements is
    // 0xC5E9dDebb09Cd64DfaCab4011A0D5cEDaf7c9BDb

    mapping(address => bool) private registered;

    function register(address account) public {
        registered[account] = true;
    }

    function isRegistered(address account) public view returns (bool) {
        return registered[account];
    }
}
