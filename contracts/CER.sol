pragma solidity >= 0.6.6;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.6/Oracle.sol";
import "@chainlink/contracts/src/v0.6/vendor/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CER is ChainlinkClient, Ownable {
    uint256 constant private ORACLE_PAYMENT = 1 * LINK;
    Oracle ORACLE;
    string REQUEST_CERTIFICATE_VALIDATION_JOB_ID;
    string REQUEST_CERTIFICATE_CERTIFICATION_JOB_ID;
    string REQUEST_DEFI_VALIDATION_JOB_ID;
    string REQUEST_DEFI_AUDIT_JOB_ID;
    string REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID;

    // TODO: remove before prod deployment
    bool REQUEST_CERTIFICATE_VALIDATION;
    bool REQUEST_CERTIFICATE_CERTIFICATION;
    bool REQUEST_DEFI_VALIDATION;
    bool REQUEST_DEFI_AUDIT;
    bool REQUEST_DEFI_LAST_AUDIT_DATE;

    event RequestCertificateValidationFulfilled(
        bytes32 indexed requestId,
        bool indexed valid
    );

    event RequestCertificateCertificationFulfilled(
        bytes32 indexed requestId,
        int256 indexed certification
    );

    event RequestDefiValidationFulfilled(
        bytes32 indexed requestId,
        bool indexed valid
    );

    event RequestDefiAuditFulfilled(
        bytes32 indexed requestId,
        string indexed audit
    );

    event RequestDefiLastAuditDateFulfilled(
        bytes32 indexed requestId,
        int256 indexed lastAuditDate
    );

    constructor(address _link) public Ownable() {
        // TODO: set link address from a constructor
        // TODO: add in ts 0x20fE562d797A42Dcb3399062AE9546cd06f63280
        setChainlinkToken(_link);
        ORACLE = new Oracle(_link);
        // TODO: check if this address is the same both on ropsten and mainnet
        ORACLE.setFulfillmentPermission(0xc33E8c08d9354D798786B956625FC07dfad97F61, true);
    }

    function requestCertificateValidation(string memory _exchange)
        public
    {
        IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), ORACLE_PAYMENT);
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/certificates/validate?exchange=");
        urlBytes = abi.encodePacked(urlBytes, _exchange);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_CERTIFICATE_VALIDATION_JOB_ID),
            address(this),
            this.fulfillCertificateValidation.selector
        );
        req.add("get", string(urlBytes));
        sendChainlinkRequestTo(address(ORACLE), req, ORACLE_PAYMENT);
    }

    function requestCertificateCertification(string memory _exchange)
        public
    {
        IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), ORACLE_PAYMENT);
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/certificates?exchange=");
        urlBytes = abi.encodePacked(urlBytes, _exchange);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_CERTIFICATE_CERTIFICATION_JOB_ID),
            address(this),
            this.fulfillCertificateValidation.selector
        );
        req.add("get", string(urlBytes));
        sendChainlinkRequestTo(address(ORACLE), req, ORACLE_PAYMENT);
    }

    function requestDefiValidation(string memory _projectName)
        public
    {
        IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), ORACLE_PAYMENT);
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/defi/validate?projectName=");
        urlBytes = abi.encodePacked(urlBytes, _projectName);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_DEFI_VALIDATION_JOB_ID),
            address(this),
            this.fulfillDefiValidation.selector
        );
        req.add("get", string(urlBytes));
        sendChainlinkRequestTo(address(ORACLE), req, ORACLE_PAYMENT);
    }

    function requestDefiAudit(string memory _projectName)
        public
    {
        IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), ORACLE_PAYMENT);
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/defi?projectName=");
        urlBytes = abi.encodePacked(urlBytes, _projectName);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_DEFI_AUDIT_JOB_ID),
            address(this),
            this.fulfillDefiValidation.selector
        );
        req.add("get", string(urlBytes));
        sendChainlinkRequestTo(address(ORACLE), req, ORACLE_PAYMENT);
    }

    function requestDefiLastAuditDate(string memory _projectName)
        public
    {
        IERC20(chainlinkTokenAddress()).transferFrom(msg.sender, address(this), ORACLE_PAYMENT);
        bytes memory urlBytes;
        urlBytes = abi.encodePacked("https://cer.live/historical/defi?projectName=");
        urlBytes = abi.encodePacked(urlBytes, _projectName);

        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(REQUEST_DEFI_LAST_AUDIT_DATE_JOB_ID),
            address(this),
            this.fulfillDefiValidation.selector
        );
        req.add("get", string(urlBytes));
        sendChainlinkRequestTo(address(ORACLE), req, ORACLE_PAYMENT);
    }

    function fulfillCertificateValidation(bytes32 _requestId, bool _valid)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestCertificateValidationFulfilled(_requestId, _valid);
        REQUEST_CERTIFICATE_VALIDATION = true;
    }

    function fulfillCertificateCertification(bytes32 _requestId, int256 _certification)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestCertificateCertificationFulfilled(_requestId, _certification);
        REQUEST_CERTIFICATE_CERTIFICATION = true;
    }

    function fulfillDefiValidation(bytes32 _requestId, bool _valid)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestDefiValidationFulfilled(_requestId, _valid);
        REQUEST_DEFI_VALIDATION = true;
    }

    function fulfillDefiAudit(bytes32 _requestId, string memory _audit)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestDefiAuditFulfilled(_requestId, _audit);
        REQUEST_DEFI_AUDIT = true;
    }

    function fulfillDefiLastAuditDate(bytes32 _requestId, int256 _lastAuditDate)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestDefiLastAuditDateFulfilled(_requestId, _lastAuditDate);
        REQUEST_DEFI_LAST_AUDIT_DATE = true;
    }

    function getChainlinkToken() public view returns (address) {
        return chainlinkTokenAddress();
    }

    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
    }

    function cancelRequest(
        bytes32 _requestId,
        uint256 _payment,
        bytes4 _callbackFunctionId,
        uint256 _expiration
    )
        public
    {
        cancelChainlinkRequest(_requestId, _payment, _callbackFunctionId, _expiration);
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

}
