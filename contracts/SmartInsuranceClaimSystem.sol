// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    Smart Insurance Claim System
    - Users submit insurance claims
    - Owner reviews and approves or rejects
    - Approved claims can be paid out
*/

contract Project {
    address public owner;

    struct Claim {
        address claimant;
        uint amount;
        string reason;
        bool approved;
        bool paid;
    }

    Claim[] public claims;

    constructor() {
        owner = msg.sender;
    }

    // ✅ 1. User submits a claim
    function submitClaim(uint _amount, string memory _reason) public {
        claims.push(Claim(msg.sender, _amount, _reason, false, false));
    }

    // ✅ 2. Owner approves claim
    function approveClaim(uint claimId) public {
        require(msg.sender == owner, "Only owner can approve claims");
        require(claimId < claims.length, "Invalid claim ID");
        claims[claimId].approved = true;
    }

    // ✅ 3. Owner pays the claim to user
    function payClaim(uint claimId) public payable {
        require(msg.sender == owner, "Only owner can pay claims");
        require(claimId < claims.length, "Invalid claim ID");
        Claim storage c = claims[claimId];
        require(c.approved == true, "Claim not approved");
        require(c.paid == false, "Already paid");
        require(msg.value == c.amount, "Send correct payout amount");

        c.paid = true;
        payable(c.claimant).transfer(msg.value);
    }

    // ✅ Helper: total number of claims
    function getTotalClaims() public view returns(uint) {
        return claims.length;
    }
}
