// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./IPoH.sol";

contract PoHIdentityCommitments {
    IPoH public poh;

    mapping(address => bool) private committed;
    mapping(bytes32 => bool) private commitments;

    constructor(address poh_) {
        poh = IPoH(poh_);
    }

    function register(bytes32 commitment) public {
        require(poh.isRegistered(msg.sender), "not registered with PoH");
        require(!committed[msg.sender], "already registered");
        require(!commitments[commitment], "commitment already used");
        committed[msg.sender] = true;
        commitments[commitment] = true;
    }

    function hasCommitment(address account) public view returns (bool) {
        return committed[account];
    }
}
