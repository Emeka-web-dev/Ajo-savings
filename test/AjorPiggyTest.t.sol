// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {AjorPiggy} from "../src/AjorPiggy.sol";

contract AjorPiggyTest is Test {
    AjorPiggy public ajorPiggy;
    address public owner;
    address public user1;
    address public user2;

    // Setup function runs before each testj
    function setUp() public {
        owner = address(this);
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        
        // Deploy the contract
        ajorPiggy = new AjorPiggy();
        
        // Fund the test users
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    function testContribute() public {        
        vm.startPrank(user1);

        uint256 contributionAmount = 0.001 ether;
        ajorPiggy.contribute{value: contributionAmount}();

        bool hasContributed = ajorPiggy.hasContributed(user1);
        assertTrue(hasContributed, "User should have contributed");

        uint256 totalContributions = ajorPiggy.totalContributions();
        assertEq(totalContributions, contributionAmount, "Total contributions should be updated");

        uint256 balance = address(ajorPiggy).balance;
        assertEq(balance, contributionAmount, "Contract balance should be updated");
        
        vm.stopPrank();
    }

     function testCannotContributeTwice() public {        
        vm.startPrank(user1);

        uint256 contributionAmount = 0.001 ether;
        console.log(ajorPiggy.hasContributed(user1));
        ajorPiggy.contribute{value: contributionAmount}();
        console.log(ajorPiggy.hasContributed(user1));
        vm.expectRevert("Already contributed");
        ajorPiggy.contribute{value: contributionAmount}();
        vm.stopPrank();
    }

    function testCannotContributeBelowMinimum() public {        
        vm.startPrank(user1);
        uint256 lowContributionAmount = 0.0005 ether;
        vm.expectRevert("Contribution amount too low");
        ajorPiggy.contribute{value: lowContributionAmount}();

        vm.stopPrank();
    }

    function testWithdrawFunds() public {        
        vm.startPrank(user1);

        uint256 contributionAmount = 0.001 ether;
        ajorPiggy.contribute{value: contributionAmount}();

        vm.stopPrank();
        vm.startPrank(owner);

        uint256 initialOwnerBalance = owner.balance;
        console.log(initialOwnerBalance);
        ajorPiggy.withdraw();

        uint256 finalOwnerBalance = owner.balance;
        console.log(finalOwnerBalance);
        assertEq(finalOwnerBalance, initialOwnerBalance + contributionAmount, "Owner should have withdrawn the funds");

        vm.stopPrank();
    }

    // Test contract deployment
    // function testDeployment() public view {
    //     assertEq(ajorPiggy.name(), "AjorPiggy");
    //     assertEq(ajorPiggy.symbol(), "AJOR");
    // }

    // Test contribution functionality
    // function testContribution() public {
    //     // First contribution should work
       
    //     vm.prank(user1);
    //     ajorPiggy.contribute{value: 1 ether}();       
       
    //     assertEq(ajorPiggy.getContractBalance(), 1 ether);
    //     assertEq(ajorPiggy.addressToTotalContribution(user1), 1 ether);
    //     assertEq(ajorPiggy.totalSupply(), 1);
    //     assertEq(ajorPiggy.ownerOf(1), user1);
    //     assertEq(ajorPiggy.contributionAmount(1), 1 ether);
    // }

    // Test receiving ETH directly
    // function testReceiveFunction() public {
    //     // Send ETH directly to the contract
    //     vm.prank(user1);
    //     (bool success,) = address(ajorPiggy).call{value: 1 ether}("");
        
    //     assertTrue(success);
    //     assertEq(ajorPiggy.getContractBalance(), 1 ether);
    //     assertEq(ajorPiggy.totalSupply(), 1);
    // }

    // Test that users can't contribute multiple times
    // function testCannotContributeMultipleTimes() public {
    //     // First contribution
    //     vm.prank(user1);
    //     ajorPiggy.contribute{value: 1 ether}();
        
    //     // Second contribution should fail
    //     vm.prank(user1);
    //     ajorPiggy.contribute{value: 1 ether}();
    //     vm.expectRevert("Have already contributed");
    // }

    // Test contribution with zero value
    // function testZeroContribution() public {
    //     vm.prank(user1);
    //     ajorPiggy.contribute{value: 0}();
    //     vm.expectRevert("Not enough funds");
    // }

    // Test contribution from multiple users
    // function testMultipleUsers() public {
    //     // User 1 contributes
    //     vm.prank(user1);
    //     ajorPiggy.contribute{value: 1 ether}();
        
    //     // User 2 contributes
    //     vm.prank(user2);
    //     ajorPiggy.contribute{value: 2 ether}();
        
    //     // Check both contributions were recorded
    //     assertEq(ajorPiggy.getContractBalance(), 3 ether);
    //     assertEq(ajorPiggy.totalSupply(), 2);
    //     assertEq(ajorPiggy.ownerOf(1), user1);
    //     assertEq(ajorPiggy.ownerOf(2), user2);
    //     assertEq(ajorPiggy.contributionAmount(1), 1 ether);
    //     assertEq(ajorPiggy.contributionAmount(2), 2 ether);
    // }

    // Test for emitted events
    // function testContributionEvent() public {
    //     vm.prank(user1);
        
    //     // Check that the ContributionReceived event is emitted with correct parameters
    //     vm.expectEmit(true, false, false, true);
    //     emit ContributionReceived(user1, 1 ether, 1);
        
    //     ajorPiggy.contribute{value: 1 ether}();
    // }
}