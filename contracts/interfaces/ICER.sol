pragma solidity >= 0.6.6;

interface ICER {

    event RequestCertificateValidationFulfilled(
        bytes32 indexed requestId,
        bool indexed valid
    );

    event RequestDefiValidationFulfilled(
        bytes32 indexed requestId,
        bool indexed valid
    );

    event RequestCertificateCybersecurityScoreFulfilled(
        bytes32 indexed requestId,
        uint indexed cybersecurityScore
    );

    event RequestCertificatePenetrationTestStatusFulfilled(
        bytes32 indexed requestId,
        bytes32 indexed penetrationTestStatus
    );

    event RequestCertificatePenetrationTestActiveUntilFulfilled(
        bytes32 indexed requestId,
        uint indexed penetrationTestActiveUntil
    );

    event RequestCertificateBugBountyStatusFulfilled(
        bytes32 indexed requestId,
        bytes32 indexed bugBountyStatus
    );

    event RequestCertificateProofOfFundsStatusFulfilled(
        bytes32 indexed requestId,
        bytes32 indexed proofOfFundsStatus
    );

    event RequestDefiAuditFulfilled(
        bytes32 indexed requestId,
        bytes32 indexed audit
    );

    event RequestDefiLastAuditDateFulfilled(
        bytes32 indexed requestId,
        uint indexed lastAuditDate
    );

    event RequestDefiBugBountyFulfilled(
        bytes32 indexed requestId,
        bytes32 indexed bugBounty
    );

    function oraclePayment() external view returns (uint);
    function refillNodeETHBalance(address payable _node) external payable;

    function certificateCybersecurityScoreByExchange(string calldata) external view returns (uint);
    function certificatePenetrationTestStatusByExchange(string calldata) external view returns (string memory);
    function certificatePenetrationTestActiveUntilByExchange(string calldata) external view returns (uint);
    function certificateBugBountyStatusByExchange(string calldata) external view returns (string memory);
    function certificateProofOfFundsStatusByExchange(string calldata) external view returns (string memory);
    function exchangeDetails(string calldata) 
        external 
        view 
        returns (
            uint cybersecurityScore, 
            string memory penetrationTestStatus,
            uint penetrationTestActiveUntil,
            string memory bugBountyStatus,
            string memory proofOfFundsStatus
        );
    
    function defiAuditByProject(string calldata) external view returns (string memory);
    function defiLastAuditDateByProject(string calldata) external view returns (uint);
    function defiBugBountyByProject(string calldata) external view returns (string memory);
    function defiDetails(string calldata) 
        external 
        view 
        returns (
            string memory audit,
            uint lastAudit,
            string memory bugBounty
        );

    function updateOraclePayment(uint256 _oraclePayment) external;
    function updateOracleAddress(address _oracle) external;
    function updateChainlinkToken(address _link) external;
    function updateCalidationJobId(string calldata _validationJobId) external;
    function updateCertificateJobIds(
        string calldata _certificateCybersecurityScoreJobId,
        string calldata _certificatePenetrationTestStatusJobId,
        string calldata _certificatePenetrationTestActiveUntileJobId,
        string calldata _certificateBugBountyStatusJobId,
        string calldata _certificateProofOfFundsStatusJobId
    ) external;
    function updateDefiJobIds(
        string calldata _defiAuditJobId,
        string calldata _defiLastAuditDateJobId,
        string calldata _defiBugBountyJobId
    ) external;

    function requestCertificateValidation(string calldata _exchange) external;
    function requestDefiValidation(string calldata _projectName) external;
    function requestCertificateCybersecurityScore(string calldata _exchange) external;
    function requestCertificatePenetrationTestStatus(string calldata _exchange) external;
    function requestCertificatePenetrationTestActiveUntil(string calldata _exchange) external;
    function requestCertificateBugBountyStatus(string calldata _exchange) external;
    function requestCertificateProofOfFundsStatus(string calldata _exchange) external;
    function requestDefiAudit(string calldata _projectName) external;
    function requestDefiLastAuditDate(string calldata _projectName) external;
    function requestDefiBugBounty(string calldata _projectName) external;

    function fulfillCertificateValidation(bytes32 _requestId, bool _valid) external;
    function fulfillDefiValidation(bytes32 _requestId, bool _valid) external;
    function fulfillCertificateCybersecurityScore(bytes32 _requestId, uint _cybersecuityScore) external;
    function fulfillCertificatePenetrationTestStatus(bytes32 _requestId, bytes32 _penetrationTestStatus) external;
    function fulfillCertificatePenetrationTestActiveUntil(bytes32 _requestId, uint _penetrationTestActiveUntil) external;
    function fulfillCertificateBugBountyStatus(bytes32 _requestId, bytes32 _bugBountyStatus) external;
    function fulfillCertificateProofOfFundsStatus(bytes32 _requestId, bytes32 _proofOfFundsStatus) external;
    function fulfillDefiAudit(bytes32 _requestId, bytes32 _audit) external;
    function fulfillDefiLastAuditDate(bytes32 _requestId, uint _lastAuditDate) external;
    function fulfillDefiBugBounty(bytes32 _requestId, bytes32 _bugBounty) external;
}