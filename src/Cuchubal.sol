// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Cuchubal {
    address public creator;
    uint256 public startDate;
    uint256 public contributionAmount;
    uint256 public frequency;
    uint256 public participantCount;
    string public name;
    uint256 public endDate;
    uint256 public penaltyPercentage;
    uint256 public penaltyQuotaPercentage;
    uint256 public totalContributionsRequired;
    uint256 public minimumQuota;
    mapping(address => uint256) public contributions; // Keep this declaration
    mapping(address => uint256) public lastContributionTime;

    address[] public participants;
    mapping(address => bool) public isParticipant;
    mapping(address => bool) public invitations;
    string public invitationCode;
    bool public codeGenerated = false;

    event ParticipantInvited(address indexed participant);
    event ParticipantAccepted(address indexed participant);
    //event ParticipantJoinedWithCode(address indexed participant);
    event ContributionMade(address indexed participant, uint256 amount);
    event RewardDistributed(address indexed participant, uint256 amount);
    event PenaltyApplied(address indexed participant, uint256 amount);

    constructor(
        address _creator,
        uint256 _startDate,
        uint256 _contributionAmount,
        uint256 _frequency,
        uint256 _participantCount,
        string memory _name,
        uint256 _endDate,
        uint256 _penaltyPercentage,
        uint256 _penaltyQuotaPercentage,
        //total contributions required
        uint256 _totalContributionsRequired
    ) {
        creator = _creator;
        startDate = _startDate;
        contributionAmount = _contributionAmount;
        frequency = _frequency;
        participantCount = _participantCount;
        name = _name;
        endDate = _endDate;
        penaltyPercentage = _penaltyPercentage;
        penaltyQuotaPercentage = _penaltyQuotaPercentage;
        totalContributionsRequired = _contributionAmount * (_endDate - _startDate) / _frequency;
    }

    function inviteParticipant(address participant) public {
        require(msg.sender == creator, "Only the creator can invite participants");
        require(participants.length < participantCount, "Participant limit reached");

        invitations[participant] = true;
        emit ParticipantInvited(participant);
    }

    function acceptInvitation() public {
        require(invitations[msg.sender], "No invitation found for this address");
        require(participants.length < participantCount, "Participant limit reached");

        participants.push(msg.sender);
        isParticipant[msg.sender] = true;
        invitations[msg.sender] = false;

        emit ParticipantAccepted(msg.sender);
    }

    /*function generateInvitationCode() public {
        require(msg.sender == creator, "Only the creator can generate the invitation code");
        require(!codeGenerated, "Invitation code already generated");

        // Generating a simple invitation code (could be more complex)
        invitationCode = keccak256(abi.encodePacked(block.timestamp, creator));
        codeGenerated = true;
    }*/

    /*function joinWithCode(string memory code) public {
        require(
            keccak256(abi.encodePacked(code)) == keccak256(abi.encodePacked(invitationCode)), "Invalid invitation code"
        );
        require(participants.length < participantCount, "Participant limit reached");
        require(!isParticipant[msg.sender], "Address already a participant");

        participants.push(msg.sender);
        isParticipant[msg.sender] = true;

        emit ParticipantJoinedWithCode(msg.sender);
    }*/

    //Contribuciones USDC/BASESC

    address private constant USDC_ADDRESS = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913; 
    IERC20 private usdc = IERC20(USDC_ADDRESS);

    function viewContributionStatus() public view returns (uint256) {
        return contributions[msg.sender];
    }

    function makeContribution(uint256 amount) public {
        require(isParticipant[msg.sender], "Solo los participantes pueden contribuir");
        require(amount >= minimumQuota, "La contribucion es menor que la cuota minima");
        require(contributions[msg.sender] + amount <= totalContributionsRequired, "El total de contribuciones excede el limite");
        require(amount <= totalContributionsRequired - contributions[msg.sender], "Monto de contribucion invalido");

        require(usdc.transferFrom(msg.sender, address(this), amount), "Fallo la transferencia de USDC");

        contributions[msg.sender] += amount;
        lastContributionTime[msg.sender] = block.timestamp;

        emit ContributionMade(msg.sender, amount);
    }
}