// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./PoHIdentityCommitments.sol";
import "./CommitRevealProofVerifier.sol";

contract PoHAnon is PoHIdentityCommitments, Verifier {
    mapping(address => bool) private registered;

    constructor(address poh_) PoHIdentityCommitments(poh_) { }

    function registerAnon(Proof calldata proof) public {
        require(hasCommitment(msg.sender), "no commitment"); // fatal flaw, this doesn't work
        bool result = verifyTx(proof);
        require(result, "proof verification failed");
        registered[msg.sender] = true;
    }

    function isRegistered(address account) public view returns (bool) {
        return registered[account];
    }
}
