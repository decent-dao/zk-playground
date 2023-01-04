// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PoHIdentityCommitments.sol";
import "../src/mocks/MockPoH.sol";

contract PoHIdentityCommitmentsTest is Test {
    MockPoH private mockPoH;
    PoHIdentityCommitments private pohIdentityCommitments;

    function setUp() public {
        mockPoH = new MockPoH();
        mockPoH.register(address(this));

        pohIdentityCommitments = new PoHIdentityCommitments(address(mockPoH));
    }

    function testRegister() public {
        pohIdentityCommitments.register(bytes32(abi.encode("abc")));
    }

    function testHasCommitment() public {
        pohIdentityCommitments.register(bytes32(abi.encode("abc")));
        assertTrue(pohIdentityCommitments.hasCommitment(address(this)));
    }

    function testDoesNotHaveCommitment() public {
        assertFalse(pohIdentityCommitments.hasCommitment(address(this)));
    }

    function testCannotRegisterBecauseNotPoH() public {
        vm.prank(address(0));
        vm.expectRevert(abi.encodePacked("not registered with PoH"));
        pohIdentityCommitments.register(bytes32(abi.encode("abc")));
    }

    function testCannotRegisterBecauseAlreadyRegistered() public {
        pohIdentityCommitments.register(bytes32(abi.encode("abc")));
        vm.expectRevert(abi.encodePacked("already registered"));
        pohIdentityCommitments.register(bytes32(abi.encode("def")));
    }

    function testCannotRegisterBecauseCommitmentAlreadyUsed() public {
        pohIdentityCommitments.register(bytes32(abi.encode("abc")));
        address anotherRegisteredAddress = address(1);
        mockPoH.register(anotherRegisteredAddress);
        vm.prank(anotherRegisteredAddress);
        vm.expectRevert(abi.encodePacked("commitment already used"));
        pohIdentityCommitments.register(bytes32(abi.encode("abc")));
    }
}
