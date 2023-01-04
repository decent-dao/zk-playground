// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PoHAnon.sol";
import "../src/mocks/MockPoH.sol";

contract PoHAnonTest is Test {
    PoHAnon private pohAnon;

    function setUp() public {
        MockPoH mockPoH = new MockPoH();
        mockPoH.register(address(this));

        pohAnon = new PoHAnon(address(mockPoH));
    }

    function testNotRegistered() public {
        assertFalse(pohAnon.isRegistered(address(this)));
    }

    function testCannotRegisterAnonBecauseNoCommitment() public {
        Verifier.Proof memory proof = Verifier.Proof({
            a: Pairing.G1Point({
                X: 1,
                Y: 2
            }),
            b: Pairing.G2Point({
                X: [uint256(1), uint256(2)],
                Y: [uint256(1), uint256(2)]
            }),
            c: Pairing.G1Point({
                X: 1,
                Y: 2
            })
        });

        vm.expectRevert(abi.encodePacked("no commitment"));
        pohAnon.registerAnon(proof);
    }
}
