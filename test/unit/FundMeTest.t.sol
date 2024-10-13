// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {FundMe} from "../../src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 SEND_VALUE = 1 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testMsgIsi_owner() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function test_GetVersion() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFailwithoutEth() public {
        vm.expectRevert(" NEEd to spend more ETH!");
        fundMe.fund{value: 0 ether}();
    }

    function testFundUpdatest() public {
        vm.prank(USER); //The next Tx will be sent by USER
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddFunderToArrayOfFunders() public {
        vm.prank(USER); // 使用 vm.prank(USER) 将 msg.sender 设置为 USER 地址
        fundMe.fund{value: SEND_VALUE}(); // 调用 fundMe 合约的 fund 函数，并发送 SEND_VALUE 数量的 ETH
        address funder = fundMe.getFunder(0); // 获取 s_funders 数组中的第一个出资者地址
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        fundMe.fund{value: SEND_VALUE};
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithDrawWithASingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 stratingfundMeBanalance = address(fundMe).balance;

        //AccountAccess
        vm.prank(fundMe.getOwner()); // 模拟合约所有者调用
        fundMe.withdraw(); // 调用 withdraw 函数

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingfundMeBanalance = address(fundMe).balance;
        assertEq(endingfundMeBanalance, 0);
        assertEq(
            startingOwnerBalance + stratingfundMeBanalance,
            endingOwnerBalance
        );
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //vm.prank new address
            //vm.deal new address          //address()
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 stratingfundMeBanalance = address(fundMe).balance;

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperwithdraw();
        vm.stopPrank();

        //assert
        assert(address(fundMe).balance == 0);
        assert(
            startingOwnerBalance + stratingfundMeBanalance ==
                fundMe.getOwner().balance
        );
    }

    function testWithdrawFromMultipleFunders() public funded {
        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //vm.prank new address
            //vm.deal new address          //address()
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 stratingfundMeBanalance = address(fundMe).balance;

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        //assert
        assert(address(fundMe).balance == 0);
        assert(
            startingOwnerBalance + stratingfundMeBanalance ==
                fundMe.getOwner().balance
        );
    }
}
