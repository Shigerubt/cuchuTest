// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Cuchubal.sol";

contract CuchubalFactory {
    event CuchubalCreated(
        address indexed creator,
        address indexed cuchubalAddress,
        uint256 startDate,
        uint256 contributionAmount,
        uint256 participantCount,
        string name,
        uint256 endDate,
        uint256 penaltyPercentage,
        uint256 penaltyQuotaPercentage
    );

    struct CuchubalInfo {
        address cuchubalAddress;
        uint256 startDate;
        uint256 contributionAmount;
        uint256 participantCount;
        string name;
        uint256 endDate;
        uint256 penaltyPercentage;
        uint256 penaltyQuotaPercentage;
    }

    mapping(address => CuchubalInfo[]) public cuchubalesByCreator;

    function createCuchubal(
        uint256 startDate,
        uint256 contributionAmount,
        uint256 participantCount,
        string memory name,
        uint256 penaltyPercentage,
        uint256 penaltyQuotaPercentage
    ) public {
        uint256 totalContributionsRequired = contributionAmount * participantCount;
        uint256 endDate = startDate + (participantCount * 1 weeks); // Calcular la fecha de finalización

        Cuchubal newCuchubal = new Cuchubal(
            msg.sender,
            startDate,
            contributionAmount,
            participantCount,
            name,
            penaltyPercentage,
            penaltyQuotaPercentage,
            totalContributionsRequired
        );

        CuchubalInfo memory newCuchubalInfo = CuchubalInfo({
            cuchubalAddress: address(newCuchubal),
            startDate: startDate,
            contributionAmount: contributionAmount,
            participantCount: participantCount,
            name: name,
            endDate: endDate,
            penaltyPercentage: penaltyPercentage,
            penaltyQuotaPercentage: penaltyQuotaPercentage
        });

        cuchubalesByCreator[msg.sender].push(newCuchubalInfo);

        emit CuchubalCreated(
            msg.sender,
            address(newCuchubal),
            startDate,
            contributionAmount,
            participantCount,
            name,
            endDate,
            penaltyPercentage,
            penaltyQuotaPercentage
        );
    }

    function getCuchubalesByCreator(address creator) public view returns (CuchubalInfo[] memory) {
        return cuchubalesByCreator[creator];
    }
}
