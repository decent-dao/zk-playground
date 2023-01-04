// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/mocks/MockPoH.sol";

contract MockPoHTest is Test {
    MockPoH private mockPoH;
    address private unregisteredAddress = address(0x1);
    address private registeredAddress   = address(0x2);

    function setUp() public {
        mockPoH = new MockPoH();
        mockPoH.register(registeredAddress);
    }

    function testNotIsPoHRegistered() public {
        bool result = mockPoH.isRegistered(unregisteredAddress);
        assertFalse(result);
    }

    function testIsPoHRegistered() public {
        bool result = mockPoH.isRegistered(registeredAddress);
        assertTrue(result);
    }
}
