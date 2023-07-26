// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleEscrow {
    address public partyA; // The address of Party A (the depositor)
    address public partyB; // The address of Party B

    uint256 public depositAmount; // The amount of Ether deposited by Party A
    bool public releaseFundsRequested; // Boolean flag to indicate if Party B has requested to release funds

    // Constructor - Party A initializes the contract and deposits some amount of Ether
    constructor(address _partyB) payable {
        partyA = msg.sender;
        partyB = _partyB;
        depositAmount = msg.value;
        releaseFundsRequested = false;
    }

    // Function to allow Party B to request the release of funds
    function requestReleaseFunds() external onlyPartyB {
        releaseFundsRequested = true;
    }

    // Function to release the funds to Party B
    function releaseFunds() external onlyPartyB {
        require(releaseFundsRequested, "Funds release not requested by Party B yet");
        payable(partyB).transfer(depositAmount);
        releaseFundsRequested = false; // Reset the flag after transferring the funds
    }

    // Function to get the deposited amount
    function getDepositAmount() external view returns (uint256) {
        return depositAmount;
    }

    // Modifier to ensure that only Party B can call certain functions
    modifier onlyPartyB() {
        require(msg.sender == partyB, "Only Party B can call this function");
        _;
    }
}
