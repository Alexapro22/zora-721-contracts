// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import {EditionMetadataRenderer} from "../../src/metadata/EditionMetadataRenderer.sol";
import {MetadataRenderAdminCheck} from "../../src/metadata/MetadataRenderAdminCheck.sol";
import {DropMockBase} from "./DropMockBase.sol";
import {Test} from "forge-std/Test.sol";

contract TestAdmin is MetadataRenderAdminCheck {
    event Ok();
    function updateSomething(address target) external requireSenderAdmin(target) {
        emit Ok();
    }
}

contract EditionMetadataRendererTest is Test {
    DropMockBase public mockBase;
    TestAdmin public testAdmin;

    function setUp() public {
        mockBase = new DropMockBase();
        testAdmin = new TestAdmin();
    }

    function test_MetadataRenderAdminCheckSender() public {
        address testTarget = address(0x10);
        vm.startPrank(testTarget);
        testAdmin.updateSomething(testTarget); 
    }

    function test_MetadataRenderAdminCheckGetterFailure() public {
        address testTarget = address(mockBase);
        vm.startPrank(address(0x12));
        vm.expectRevert(MetadataRenderAdminCheck.Access_OnlyAdmin.selector);
        testAdmin.updateSomething(testTarget); 
    }

    function test_MetadataRenderAdminCheckSuccess() public {
        mockBase.setIsAdmin(address(0x12), true);
        address testTarget = address(mockBase);
        vm.startPrank(address(0x12));
        testAdmin.updateSomething(testTarget); 
    }


}
