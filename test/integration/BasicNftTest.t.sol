// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {MintBasicNft} from "../../script/Interactions.s.sol";

contract BasicNftTest is Test {
    string constant NFT_NAME = "Dogie";
    string constant NFT_SYMBOL = "DOG";
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public {
        string memory actualName = basicNft.name();
        string memory expectedName = "Dogie";
        assertEq(actualName, expectedName);
    }

    function testNameIsCorrectView() public view {
        string memory actualName = basicNft.name();
        string memory expectedName = "Dogie";
        assert(keccak256(bytes(actualName)) == keccak256(bytes(expectedName)));
    }

    function testNameIsCorrectAbi() public view {
        string memory actualName = basicNft.name();
        string memory expectedName = "Dogie";
        assert(
            keccak256(abi.encodePacked(actualName)) ==
                keccak256(abi.encodePacked(expectedName))
        );
    }

    function testInitializedCorrectly() public view {
        assert(
            keccak256(abi.encodePacked(basicNft.name())) ==
                keccak256(abi.encodePacked((NFT_NAME)))
        );
        assert(
            keccak256(abi.encodePacked(basicNft.symbol())) ==
                keccak256(abi.encodePacked((NFT_SYMBOL)))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(basicNft.balanceOf(USER) == 1);
    }

    function testTokenURIIsCorrect() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(PUG_URI))
        );
    }

    function testMintWithScript() public {
        uint256 startingTokenCount = basicNft.getTokenCounter();
        MintBasicNft mintBasicNft = new MintBasicNft();
        mintBasicNft.mintNftOnContract(address(basicNft));
        assert(basicNft.getTokenCounter() == startingTokenCount + 1);
    }
}
