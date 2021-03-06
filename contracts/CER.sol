pragma solidity >= 0.6.6;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.6/vendor/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.6/interfaces/OracleInterface.sol";
import "./interfaces/ICER.sol";

contract CER is ICER, ChainlinkClient, Ownable {
    string private REQUEST_VALIDATION_JOB_ID;

    string private REQUEST_CERTIFICATE_CYBERSECURITY_SCORE_JOB_ID;
    string private REQUEST_CERTIFICATE_PENETRATION_TEST_STATUS_JOB_ID;
    string private REQUEST_CERTIFICATE_PENETRATION_TEST_ACTIVE_UNTIL_JOB_ID;
    string private REQUEST_CERTIFICATE_BUG_BOUNTY_STATUS_JOB_ID;
    string private REQUEST_CERTIFICATE_PROOF_OF_FUNDS_STATUS_JOB_ID;

    string private REQUEST_DEFI_AUDIT_JOB_ID;
    string private REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID;
    string private REQUEST_DEFI_BUG_BOUNTY_JOB_ID;

    uint public override oraclePayment;

    mapping (bytes32 => string) private _exchangeNameByRequestId;
    mapping (bytes32 => string) private _projectNameByRequestId;

    mapping (string => uint) public override certificateCybersecurityScoreByExchange;
    mapping (string => string) public override certificatePenetrationTestStatusByExchange;
    mapping (string => uint) public override certificatePenetrationTestActiveUntilByExchange;
    mapping (string => string) public override certificateBugBountyStatusByExchange;
    mapping (string => string) public override certificateProofOfFundsStatusByExchange;

    mapping (string => string) public override defiAuditByProject;
    mapping (string => uint) public override defiLastAuditDateByProject;
    mapping (string => string) public override defiBugBountyByProject;

    constructor(
        address _link,
        address _oracle,
        string memory _validationJobId,
        string memory _certificateCybersecurityScoreJobId,
        string memory _certificatePenetrationTestStatusJobId,
        string memory _certificatePenetrationTestActiveUntileJobId,
        string memory _certificateBugBountyStatusJobId,
        string memory _certificateProofOfFundsStatusJobId,
        string memory _defiAuditJobId,
        string memory _defiLastAuditDateJobId,
        string memory _defiBugBountyJobId,
        uint256 _oraclePayment
    ) public {
        setChainlinkToken(_link);
        setChainlinkOracle(_oracle);
        REQUEST_VALIDATION_JOB_ID = _validationJobId;

        REQUEST_CERTIFICATE_CYBERSECURITY_SCORE_JOB_ID = _certificateCybersecurityScoreJobId;
        REQUEST_CERTIFICATE_PENETRATION_TEST_STATUS_JOB_ID = _certificatePenetrationTestStatusJobId;
        REQUEST_CERTIFICATE_PENETRATION_TEST_ACTIVE_UNTIL_JOB_ID = _certificatePenetrationTestActiveUntileJobId;
        REQUEST_CERTIFICATE_BUG_BOUNTY_STATUS_JOB_ID = _certificateBugBountyStatusJobId;
        REQUEST_CERTIFICATE_PROOF_OF_FUNDS_STATUS_JOB_ID = _certificateProofOfFundsStatusJobId;

        REQUEST_DEFI_AUDIT_JOB_ID = _defiAuditJobId;
        REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID = _defiLastAuditDateJobId;
        REQUEST_DEFI_BUG_BOUNTY_JOB_ID = _defiBugBountyJobId;

        oraclePayment = _oraclePayment;
    }

    function refillNodeETHBalance(address payable _node) external payable override {
        require(OracleInterface(chainlinkOracleAddress()).getAuthorizationStatus(_node), "CER: unauthorized node");
        _node.transfer(msg.value);
    }

    function updateOraclePayment(uint256 _oraclePayment) external override onlyOwner {
        oraclePayment = _oraclePayment;
    }

    function updateOracleAddress(address _oracle) external override onlyOwner {
        setChainlinkOracle(_oracle);
    }

    function updateChainlinkToken(address _link) external override onlyOwner {
        setChainlinkToken(_link);
    }

    function updateCalidationJobId(string calldata _validationJobId) external override onlyOwner {
        REQUEST_VALIDATION_JOB_ID = _validationJobId;
    }

    function updateCertificateJobIds(
        string calldata _certificateCybersecurityScoreJobId,
        string calldata _certificatePenetrationTestStatusJobId,
        string calldata _certificatePenetrationTestActiveUntileJobId,
        string calldata _certificateBugBountyStatusJobId,
        string calldata _certificateProofOfFundsStatusJobId
    )
        external
        override
        onlyOwner
    {
        REQUEST_CERTIFICATE_CYBERSECURITY_SCORE_JOB_ID = _certificateCybersecurityScoreJobId;
        REQUEST_CERTIFICATE_PENETRATION_TEST_STATUS_JOB_ID = _certificatePenetrationTestStatusJobId;
        REQUEST_CERTIFICATE_PENETRATION_TEST_ACTIVE_UNTIL_JOB_ID = _certificatePenetrationTestActiveUntileJobId;
        REQUEST_CERTIFICATE_BUG_BOUNTY_STATUS_JOB_ID = _certificateBugBountyStatusJobId;
        REQUEST_CERTIFICATE_PROOF_OF_FUNDS_STATUS_JOB_ID = _certificateProofOfFundsStatusJobId;
    }

    function updateDefiJobIds(
        string calldata _defiAuditJobId,
        string calldata _defiLastAuditDateJobId,
        string calldata _defiBugBountyJobId
    )
        external
        override
        onlyOwner
    {
        REQUEST_DEFI_AUDIT_JOB_ID = _defiAuditJobId;
        REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID = _defiLastAuditDateJobId;
        REQUEST_DEFI_BUG_BOUNTY_JOB_ID = _defiBugBountyJobId;
    }

    function exchangeDetails(string calldata exchange) 
        external 
        view 
        override
        returns (
            uint cybersecurityScore, 
            string memory penetrationTestStatus,
            uint penetrationTestActiveUntil,
            string memory bugBountyStatus,
            string memory proofOfFundsStatus
        ) 
    {
        cybersecurityScore = certificateCybersecurityScoreByExchange[exchange];
        penetrationTestStatus = certificatePenetrationTestStatusByExchange[exchange];
        penetrationTestActiveUntil = certificatePenetrationTestActiveUntilByExchange[exchange];
        bugBountyStatus = certificateBugBountyStatusByExchange[exchange];
        proofOfFundsStatus = certificateProofOfFundsStatusByExchange[exchange];
    }

    function defiDetails(string calldata project) 
        external 
        view 
        override
        returns (
            string memory audit,
            uint lastAudit,
            string memory bugBounty
        ) 
    {
        audit = defiAuditByProject[project];
        lastAudit = defiLastAuditDateByProject[project];
        bugBounty = defiBugBountyByProject[project];
    }

    function requestCertificateValidation(string calldata _exchange) external override {
        require(IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), oraclePayment), "Unable to transfer");
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/certificates/validate?exchange=");
        urlBytes = abi.encodePacked(urlBytes, _exchange);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_VALIDATION_JOB_ID),
            address(this),
            this.fulfillCertificateValidation.selector
        );
        req.add("get", string(urlBytes));
        bytes32 id = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePayment);
        _exchangeNameByRequestId[id] = _exchange;
    }

    function requestDefiValidation(string calldata _projectName) external override {
        require(IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), oraclePayment), "Unable to transfer");
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/defi/validate?projectName=");
        urlBytes = abi.encodePacked(urlBytes, _projectName);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_VALIDATION_JOB_ID),
            address(this),
            this.fulfillDefiValidation.selector
        );
        req.add("get", string(urlBytes));
        bytes32 id = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePayment);
        _projectNameByRequestId[id] = _projectName;
    }

    function requestCertificateCybersecurityScore(string calldata _exchange) external override {
        require(IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), oraclePayment), "Unable to transfer");
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/certificates?exchange=");
        urlBytes = abi.encodePacked(urlBytes, _exchange);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_CERTIFICATE_CYBERSECURITY_SCORE_JOB_ID),
            address(this),
            this.fulfillCertificateCybersecurityScore.selector
        );

        req.add("get", string(urlBytes));
        bytes32 id = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePayment);
        _exchangeNameByRequestId[id] = _exchange;
    }

    function requestCertificatePenetrationTestStatus(string calldata _exchange) external override {
        require(IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), oraclePayment), "Unable to transfer");
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/certificates?exchange=");
        urlBytes = abi.encodePacked(urlBytes, _exchange);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_CERTIFICATE_PENETRATION_TEST_STATUS_JOB_ID),
            address(this),
            this.fulfillCertificatePenetrationTestStatus.selector
        );

        req.add("get", string(urlBytes));
        bytes32 id = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePayment);
        _exchangeNameByRequestId[id] = _exchange;
    }

    function requestCertificatePenetrationTestActiveUntil(string calldata _exchange) external override {
        require(IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), oraclePayment), "Unable to transfer");
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/certificates?exchange=");
        urlBytes = abi.encodePacked(urlBytes, _exchange);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_CERTIFICATE_PENETRATION_TEST_ACTIVE_UNTIL_JOB_ID),
            address(this),
            this.fulfillCertificatePenetrationTestActiveUntil.selector
        );

        req.add("get", string(urlBytes));
        bytes32 id = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePayment);
        _exchangeNameByRequestId[id] = _exchange;
    }

    function requestCertificateBugBountyStatus(string calldata _exchange) external override {
        require(IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), oraclePayment), "Unable to transfer");
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/certificates?exchange=");
        urlBytes = abi.encodePacked(urlBytes, _exchange);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_CERTIFICATE_BUG_BOUNTY_STATUS_JOB_ID),
            address(this),
            this.fulfillCertificateBugBountyStatus.selector
        );

        req.add("get", string(urlBytes));
        bytes32 id = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePayment);
        _exchangeNameByRequestId[id] = _exchange;
    }

    function requestCertificateProofOfFundsStatus(string calldata _exchange) external override {
        require(IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), oraclePayment), "Unable to transfer");
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/certificates?exchange=");
        urlBytes = abi.encodePacked(urlBytes, _exchange);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_CERTIFICATE_PROOF_OF_FUNDS_STATUS_JOB_ID),
            address(this),
            this.fulfillCertificateProofOfFundsStatus.selector
        );

        req.add("get", string(urlBytes));
        bytes32 id = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePayment);
        _exchangeNameByRequestId[id] = _exchange;
    }

    function requestDefiAudit(string calldata _projectName) external override {
        require(IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), oraclePayment), "Unable to transfer");
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/defi?projectName=");
        urlBytes = abi.encodePacked(urlBytes, _projectName);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_DEFI_AUDIT_JOB_ID),
            address(this),
            this.fulfillDefiAudit.selector
        );

        req.add("get", string(urlBytes));
        bytes32 id = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePayment);
        _projectNameByRequestId[id] = _projectName;
    }

    function requestDefiLastAuditDate(string calldata _projectName) external override {
        require(IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), oraclePayment), "Unable to transfer");
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/defi?projectName=");
        urlBytes = abi.encodePacked(urlBytes, _projectName);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID),
            address(this),
            this.fulfillDefiLastAuditDate.selector
        );

        req.add("get", string(urlBytes));
        bytes32 id = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePayment);
        _projectNameByRequestId[id] = _projectName;
    }

    function requestDefiBugBounty(string calldata _projectName) external override {
        require(IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), oraclePayment), "Unable to transfer");
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/defi?projectName=");
        urlBytes = abi.encodePacked(urlBytes, _projectName);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_DEFI_BUG_BOUNTY_JOB_ID),
            address(this),
            this.fulfillDefiBugBounty.selector
        );

        req.add("get", string(urlBytes));
        bytes32 id = sendChainlinkRequestTo(chainlinkOracleAddress(), req, oraclePayment);
        _projectNameByRequestId[id] = _projectName;
    }

    function fulfillCertificateValidation(bytes32 _requestId, bool _valid)
        external
        override
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestCertificateValidationFulfilled(_requestId, _valid);
        if (!_valid) {
            string memory exchange = _exchangeNameByRequestId[_requestId];
            delete certificateCybersecurityScoreByExchange[exchange];
            delete certificatePenetrationTestStatusByExchange[exchange];
            delete certificatePenetrationTestActiveUntilByExchange[exchange];
            delete certificateBugBountyStatusByExchange[exchange];
            delete certificateProofOfFundsStatusByExchange[exchange];
        }
        delete _exchangeNameByRequestId[_requestId];
    }

    function fulfillDefiValidation(bytes32 _requestId, bool _valid)
        external
        override 
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestDefiValidationFulfilled(_requestId, _valid);
        if (!_valid) {
            string memory project = _projectNameByRequestId[_requestId];
            delete defiAuditByProject[project];
            delete defiLastAuditDateByProject[project];
            delete defiBugBountyByProject[project];
        }
        delete _projectNameByRequestId[_requestId];
    }

    function fulfillCertificateCybersecurityScore(bytes32 _requestId, uint _cybersecuityScore)
        external
        override 
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestCertificateCybersecurityScoreFulfilled(_requestId, _cybersecuityScore);
        certificateCybersecurityScoreByExchange[_exchangeNameByRequestId[_requestId]] = _cybersecuityScore;
        delete _exchangeNameByRequestId[_requestId];
    }

    function fulfillCertificatePenetrationTestStatus(bytes32 _requestId, bytes32 _penetrationTestStatus)
        external
        override 
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestCertificatePenetrationTestStatusFulfilled(_requestId, _penetrationTestStatus);
        certificatePenetrationTestStatusByExchange[_exchangeNameByRequestId[_requestId]] = bytes32ToString(_penetrationTestStatus);
        delete _exchangeNameByRequestId[_requestId];
    }

    function fulfillCertificatePenetrationTestActiveUntil(bytes32 _requestId, uint _penetrationTestActiveUntil)
        external
        override 
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestCertificatePenetrationTestActiveUntilFulfilled(_requestId, _penetrationTestActiveUntil);
        certificatePenetrationTestActiveUntilByExchange[_exchangeNameByRequestId[_requestId]] = _penetrationTestActiveUntil;
        delete _exchangeNameByRequestId[_requestId];
    }

    function fulfillCertificateBugBountyStatus(bytes32 _requestId, bytes32 _bugBountyStatus)
        external
        override 
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestCertificateBugBountyStatusFulfilled(_requestId, _bugBountyStatus);
        certificateBugBountyStatusByExchange[_exchangeNameByRequestId[_requestId]] = bytes32ToString(_bugBountyStatus);
        delete _exchangeNameByRequestId[_requestId];
    }

    function fulfillCertificateProofOfFundsStatus(bytes32 _requestId, bytes32 _proofOfFundsStatus)
        external
        override 
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestCertificateProofOfFundsStatusFulfilled(_requestId, _proofOfFundsStatus);
        certificateProofOfFundsStatusByExchange[_exchangeNameByRequestId[_requestId]] = bytes32ToString(_proofOfFundsStatus);
        delete _exchangeNameByRequestId[_requestId];
    }

    function fulfillDefiAudit(bytes32 _requestId, bytes32 _audit)
        external
        override 
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestDefiAuditFulfilled(_requestId, _audit);
        defiAuditByProject[_projectNameByRequestId[_requestId]] = bytes32ToString(_audit);
        delete _projectNameByRequestId[_requestId];
    }

    function fulfillDefiLastAuditDate(bytes32 _requestId, uint _lastAuditDate)
        external
        override 
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestDefiLastAuditDateFulfilled(_requestId, _lastAuditDate);
        defiLastAuditDateByProject[_projectNameByRequestId[_requestId]] = _lastAuditDate;
        delete _projectNameByRequestId[_requestId];
    }

    function fulfillDefiBugBounty(bytes32 _requestId, bytes32 _bugBounty)
        external
        override 
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestDefiBugBountyFulfilled(_requestId, _bugBounty);
        defiBugBountyByProject[_projectNameByRequestId[_requestId]] = bytes32ToString(_bugBounty);
        delete _projectNameByRequestId[_requestId];
    }

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {// solhint-disable-line no-inline-assembly
            result := mload(add(source, 32))
        }
    }

    function bytes32ToString(bytes32 x) private pure returns (string memory) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (uint j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
}
