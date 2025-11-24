// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FHE, euint64, ebool, externalEuint64} from "@fhevm/solidity/lib/FHE.sol";
import {SepoliaConfig} from "@fhevm/solidity/config/SepoliaConfig.sol";

/**
 * @title GatewayTransaction
 * @dev Implements gateway callback pattern with request/response structure,
 * status tracking, refund mechanisms, and timeout protection for encrypted transactions.
 * This contract manages the lifecycle of decryption requests through the FHE gateway.
 */
contract GatewayTransaction {
    // ============ Types ============

    /**
     * @dev Request structure for gateway decryption
     */
    struct DecryptionRequest {
        address requester;
        euint64 encryptedValue;
        uint256 requestTime;
        uint256 fee;
        bool refundClaimed;
        RequestStatus status;
        string responseData;
    }

    /**
     * @dev Status enumeration for request tracking
     */
    enum RequestStatus {
        PENDING,
        PROCESSING,
        COMPLETED,
        FAILED,
        REFUNDED
    }

    // ============ State Variables ============

    /// @dev Mapping of request IDs to DecryptionRequest structures
    mapping(uint256 => DecryptionRequest) public requests;

    /// @dev Mapping of user addresses to their request count
    mapping(address => uint256) public userRequestCount;

    /// @dev Counter for generating unique request IDs
    uint256 public requestIdCounter;

    /// @dev Gateway address authorized to call callback functions
    address public gatewayAddress;

    /// @dev Owner of the contract for administrative functions
    address public owner;

    /// @dev Timeout period for requests (in seconds, default 1 day)
    uint256 public constant REQUEST_TIMEOUT = 1 days;

    /// @dev Accumulated fees from successful transactions
    uint256 public accumulatedFees;

    /// @dev Base fee required for each request
    uint256 public baseFee;

    // ============ Events ============

    /**
     * @dev Emitted when a new decryption request is submitted
     */
    event RequestSubmitted(
        uint256 indexed requestId,
        address indexed requester,
        uint256 timestamp,
        uint256 fee
    );

    /**
     * @dev Emitted when gateway processes the callback
     */
    event GatewayCallbackProcessed(
        uint256 indexed requestId,
        RequestStatus newStatus,
        string responseData,
        uint256 timestamp
    );

    /**
     * @dev Emitted when refund is claimed for failed request
     */
    event RefundClaimed(
        uint256 indexed requestId,
        address indexed claimer,
        uint256 amount,
        uint256 timestamp
    );

    /**
     * @dev Emitted when request times out
     */
    event RequestTimeout(
        uint256 indexed requestId,
        address indexed requester,
        uint256 timestamp
    );

    /**
     * @dev Emitted when fees are withdrawn
     */
    event FeesWithdrawn(
        address indexed recipient,
        uint256 amount,
        uint256 timestamp
    );

    /**
     * @dev Emitted when gateway address is updated
     */
    event GatewayAddressUpdated(
        address indexed oldGateway,
        address indexed newGateway,
        uint256 timestamp
    );

    /**
     * @dev Emitted for audit trail of sensitive operations
     */
    event AuditLog(
        uint256 indexed requestId,
        string operation,
        address indexed actor,
        uint256 timestamp
    );

    // ============ Modifiers ============

    /**
     * @dev Ensures only the owner can call the function
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "GatewayTransaction: caller is not owner");
        _;
    }

    /**
     * @dev Ensures only the gateway can call the function
     */
    modifier onlyGateway() {
        require(
            msg.sender == gatewayAddress,
            "GatewayTransaction: caller is not gateway"
        );
        _;
    }

    /**
     * @dev Ensures the request exists and belongs to caller
     */
    modifier validRequest(uint256 _requestId) {
        require(
            _requestId < requestIdCounter,
            "GatewayTransaction: invalid request ID"
        );
        require(
            requests[_requestId].requester == msg.sender,
            "GatewayTransaction: unauthorized access to request"
        );
        _;
    }

    /**
     * @dev Ensures the request has not timed out
     */
    modifier notTimedOut(uint256 _requestId) {
        require(
            !hasRequestTimedOut(_requestId),
            "GatewayTransaction: request has timed out"
        );
        _;
    }

    /**
     * @dev Ensures sufficient fee is provided
     */
    modifier sufficientFee() {
        require(msg.value >= baseFee, "GatewayTransaction: insufficient fee");
        _;
    }

    // ============ Constructor ============

    /**
     * @dev Initialize the contract with owner and gateway address
     * @param _gatewayAddress Address of the FHE gateway
     * @param _baseFee Base fee for each request in wei
     */
    constructor(address _gatewayAddress, uint256 _baseFee) {
        require(
            _gatewayAddress != address(0),
            "GatewayTransaction: invalid gateway address"
        );
        require(_baseFee > 0, "GatewayTransaction: invalid base fee");

        owner = msg.sender;
        gatewayAddress = _gatewayAddress;
        baseFee = _baseFee;
        requestIdCounter = 0;
        accumulatedFees = 0;

        emit AuditLog(0, "ContractInitialized", msg.sender, block.timestamp);
    }

    // ============ Core Functions ============

    /**
     * @dev Submit a decryption request to the gateway
     * @param _encryptedValue The encrypted value to be decrypted
     * @return requestId Unique identifier for this request
     */
    function submitRequest(euint64 _encryptedValue)
        external
        payable
        sufficientFee
        returns (uint256)
    {
        // Validate input
        require(
            euint64.unwrap(_encryptedValue) != 0,
            "GatewayTransaction: invalid encrypted value"
        );

        uint256 currentRequestId = requestIdCounter;
        uint256 fee = msg.value;

        // Create and store request
        requests[currentRequestId] = DecryptionRequest({
            requester: msg.sender,
            encryptedValue: _encryptedValue,
            requestTime: block.timestamp,
            fee: fee,
            refundClaimed: false,
            status: RequestStatus.PENDING,
            responseData: ""
        });

        userRequestCount[msg.sender]++;
        accumulatedFees += fee;
        requestIdCounter++;

        emit RequestSubmitted(currentRequestId, msg.sender, block.timestamp, fee);
        emit AuditLog(
            currentRequestId,
            "RequestSubmitted",
            msg.sender,
            block.timestamp
        );

        return currentRequestId;
    }

    /**
     * @dev Gateway callback function to process decryption results
     * @param _requestId The request ID being processed
     * @param _responseData The decrypted data response
     * @param _success Whether decryption was successful
     */
    function gatewayCallback(
        uint256 _requestId,
        string calldata _responseData,
        bool _success
    ) external onlyGateway {
        require(
            _requestId < requestIdCounter,
            "GatewayTransaction: invalid request ID"
        );

        DecryptionRequest storage request = requests[_requestId];
        require(
            request.status == RequestStatus.PENDING ||
                request.status == RequestStatus.PROCESSING,
            "GatewayTransaction: invalid request status for callback"
        );

        // Update request status based on success
        if (_success) {
            request.status = RequestStatus.COMPLETED;
            request.responseData = _responseData;
        } else {
            request.status = RequestStatus.FAILED;
            request.responseData = _responseData;
        }

        emit GatewayCallbackProcessed(
            _requestId,
            request.status,
            _responseData,
            block.timestamp
        );
        emit AuditLog(
            _requestId,
            _success ? "CallbackSuccess" : "CallbackFailed",
            msg.sender,
            block.timestamp
        );
    }

    /**
     * @dev Claim refund for a failed or timed-out request
     * @param _requestId The request ID to claim refund for
     */
    function claimRefund(uint256 _requestId)
        external
        validRequest(_requestId)
        returns (bool)
    {
        DecryptionRequest storage request = requests[_requestId];

        // Validate refund conditions
        require(
            !request.refundClaimed,
            "GatewayTransaction: refund already claimed"
        );
        require(
            request.status == RequestStatus.FAILED ||
                hasRequestTimedOut(_requestId),
            "GatewayTransaction: request not eligible for refund"
        );

        // Mark refund as claimed
        request.refundClaimed = true;
        request.status = RequestStatus.REFUNDED;

        // Reduce accumulated fees
        accumulatedFees -= request.fee;

        // Transfer refund to requester
        (bool success, ) = payable(request.requester).call{
            value: request.fee
        }("");
        require(success, "GatewayTransaction: refund transfer failed");

        emit RefundClaimed(
            _requestId,
            msg.sender,
            request.fee,
            block.timestamp
        );
        emit AuditLog(
            _requestId,
            "RefundClaimed",
            msg.sender,
            block.timestamp
        );

        return true;
    }

    /**
     * @dev Check if a request has timed out
     * @param _requestId The request ID to check
     * @return True if the request has timed out
     */
    function hasRequestTimedOut(uint256 _requestId)
        public
        view
        returns (bool)
    {
        require(
            _requestId < requestIdCounter,
            "GatewayTransaction: invalid request ID"
        );

        DecryptionRequest storage request = requests[_requestId];

        // Check if timeout period has elapsed
        return (block.timestamp - request.requestTime) > REQUEST_TIMEOUT;
    }

    /**
     * @dev Get time remaining until a request times out
     * @param _requestId The request ID to check
     * @return Time in seconds until timeout (0 if already timed out)
     */
    function getTimeUntilTimeout(uint256 _requestId)
        external
        view
        returns (uint256)
    {
        require(
            _requestId < requestIdCounter,
            "GatewayTransaction: invalid request ID"
        );

        DecryptionRequest storage request = requests[_requestId];
        uint256 elapsedTime = block.timestamp - request.requestTime;

        if (elapsedTime >= REQUEST_TIMEOUT) {
            return 0;
        }

        return REQUEST_TIMEOUT - elapsedTime;
    }

    /**
     * @dev Withdraw accumulated fees (owner only)
     * @return Amount withdrawn
     */
    function withdrawFees() external onlyOwner returns (uint256) {
        uint256 feeAmount = accumulatedFees;
        require(feeAmount > 0, "GatewayTransaction: no fees to withdraw");

        accumulatedFees = 0;

        (bool success, ) = payable(owner).call{value: feeAmount}("");
        require(success, "GatewayTransaction: fee withdrawal failed");

        emit FeesWithdrawn(owner, feeAmount, block.timestamp);
        emit AuditLog(0, "FeesWithdrawn", owner, block.timestamp);

        return feeAmount;
    }

    // ============ Admin Functions ============

    /**
     * @dev Update the gateway address
     * @param _newGatewayAddress New gateway address
     */
    function updateGatewayAddress(address _newGatewayAddress)
        external
        onlyOwner
    {
        require(
            _newGatewayAddress != address(0),
            "GatewayTransaction: invalid gateway address"
        );
        require(
            _newGatewayAddress != gatewayAddress,
            "GatewayTransaction: same gateway address"
        );

        address oldGateway = gatewayAddress;
        gatewayAddress = _newGatewayAddress;

        emit GatewayAddressUpdated(oldGateway, _newGatewayAddress, block.timestamp);
        emit AuditLog(0, "GatewayAddressUpdated", msg.sender, block.timestamp);
    }

    /**
     * @dev Update the base fee
     * @param _newBaseFee New base fee in wei
     */
    function updateBaseFee(uint256 _newBaseFee) external onlyOwner {
        require(_newBaseFee > 0, "GatewayTransaction: invalid base fee");
        baseFee = _newBaseFee;
        emit AuditLog(0, "BaseFeeUpdated", msg.sender, block.timestamp);
    }

    // ============ View Functions ============

    /**
     * @dev Get request details
     * @param _requestId The request ID
     * @return The DecryptionRequest structure
     */
    function getRequest(uint256 _requestId)
        external
        view
        returns (DecryptionRequest memory)
    {
        require(
            _requestId < requestIdCounter,
            "GatewayTransaction: invalid request ID"
        );
        return requests[_requestId];
    }

    /**
     * @dev Get user's total request count
     * @param _user The user address
     * @return Number of requests submitted by user
     */
    function getUserRequestCount(address _user)
        external
        view
        returns (uint256)
    {
        return userRequestCount[_user];
    }

    /**
     * @dev Get total accumulated fees
     * @return Total fees in wei
     */
    function getAccumulatedFees() external view returns (uint256) {
        return accumulatedFees;
    }

    /**
     * @dev Get the current request ID counter
     * @return Current counter value
     */
    function getRequestIdCounter() external view returns (uint256) {
        return requestIdCounter;
    }
}
