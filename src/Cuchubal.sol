// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Cuchubal {
    address public creator;
    uint256 public startDate;
    uint256 public contributionAmount;
    uint256 public participantCount;
    string public name;
    uint256 public endDate;
    uint256 public penaltyPercentage;
    uint256 public penaltyQuotaPercentage;
    uint256 public totalContributionsRequired;
    uint256 public minimumQuota;
    mapping(address => uint256) public contributions;
    mapping(address => uint256) public lastContributionTime;
    
    address[] public participants;
    mapping(address => bool) public isParticipant;
    mapping(address => bool) public invitations;
    string public invitationCode;
    bool public codeGenerated = false;

    event ParticipantInvited(address indexed participant);
    event ParticipantAccepted(address indexed participant);
    event ContributionMade(address indexed participant, uint256 amount);
    event RewardDistributed(address indexed participant, uint256 amount);
    event PenaltyApplied(address indexed participant, uint256 amount);

    constructor(
        address _creator,
        uint256 _startDate,
        uint256 _contributionAmount,
        uint256 _participantCount,
        string memory _name,
        uint256 _penaltyPercentage,
        uint256 _penaltyQuotaPercentage,
        uint256 _totalContributionsRequired
    ) {
        creator = _creator;
        startDate = _startDate;
        contributionAmount = _contributionAmount;
        participantCount = _participantCount;
        name = _name;
        penaltyPercentage = _penaltyPercentage;
        penaltyQuotaPercentage = _penaltyQuotaPercentage;
        totalContributionsRequired = _totalContributionsRequired;
        endDate = _startDate + (_participantCount * 1 weeks); // Calcular la fecha de finalización
    }

    //Invitar participantes a mi cuchubal
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

    //Funcion para ver resumen de participación
    struct Contribution {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Contribution[]) public participantContributions;

    function viewParticipantSummary(address participant, address cuchubalAddress)
        public
        view
        returns (Contribution[] memory)
    {
        Cuchubal cuchubal = Cuchubal(cuchubalAddress);
        require(cuchubal.isParticipant(participant), "El participante no pertenece a este Cuchubal");

        return participantContributions[participant];
    }
    
    function contribute() external payable {
        require(isParticipant[msg.sender], "Solo los participantes pueden contribuir");
        require(msg.value >= minimumQuota, "La contribucion es menor que la cuota minima");
        require(
            contributions[msg.sender] + msg.value <= totalContributionsRequired,
            "El total de contribuciones excede el limite"
        );
        require(
            msg.value <= totalContributionsRequired - contributions[msg.sender],
            "Monto de contribucion es mayor a la cantidad ingresada"
        );
        //require(block.timestamp >= startDate && block.timestamp <= endDate, "Contribución fuera del período válido");

        contributions[msg.sender] += msg.value;
        lastContributionTime[msg.sender] = block.timestamp;

        emit ContributionMade(msg.sender, msg.value);
    }
}
