// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title SecurityValidator
 * @dev Provides input validation, overflow/underflow protection, access control,
 * secure random number generation, rate limiting, and audit logging capabilities.
 */
contract SecurityValidator {
    // ============ Types ============

    /**
     * @dev Structure for rate limiting
     */
    struct RateLimitConfig {
        uint256 maxCallsPerWindow;
        uint256 windowSize;
        bool enabled;
    }

    /**
     * @dev Structure for tracking user calls
     */
    struct UserCallTracker {
        uint256 lastCallTime;
        uint256 callCount;
        uint256 windowStartTime;
    }

    /**
     * @dev Validation result structure
     */
    struct ValidationResult {
        bool isValid;
        string errorMessage;
        uint256 validationTime;
    }

    // ============ Constants ============

    /// @dev Maximum value for 256-bit unsigned integer
    uint256 public constant MAX_UINT256 = 2**256 - 1;

    /// @dev Maximum value for 128-bit unsigned integer
    uint256 public constant MAX_UINT128 = 2**128 - 1;

    /// @dev Maximum value for 64-bit unsigned integer
    uint256 public constant MAX_UINT64 = 2**64 - 1;

    /// @dev Maximum value for 32-bit unsigned integer
    uint256 public constant MAX_UINT32 = 2**32 - 1;

    /// @dev Default rate limit: 100 calls per hour
    uint256 public constant DEFAULT_MAX_CALLS = 100;

    /// @dev Default rate limit window: 1 hour
    uint256 public constant DEFAULT_WINDOW_SIZE = 1 hours;

    // ============ State Variables ============

    /// @dev Owner of the contract
    address public owner;

    /// @dev Whitelist mapping for access control
    mapping(address => bool) public whitelist;

    /// @dev Blacklist mapping for access control
    mapping(address => bool) public blacklist;

    /// @dev Rate limit configuration per function
    mapping(bytes4 => RateLimitConfig) public rateLimitConfigs;

    /// @dev User call tracking for rate limiting
    mapping(address => mapping(bytes4 => UserCallTracker)) public userCallTrackers;

    /// @dev Counter for generating secure random numbers
    uint256 private randomCounter;

    /// @dev Audit log entries
    mapping(uint256 => string) public auditLog;

    /// @dev Total audit log count
    uint256 public auditLogCounter;

    /// @dev Maximum address value for validation
    uint256 public constant MAX_ADDRESS = 2**160 - 1;

    // ============ Events ============

    /**
     * @dev Emitted when address is added to whitelist
     */
    event AddressWhitelisted(
        address indexed account,
        uint256 timestamp
    );

    /**
     * @dev Emitted when address is removed from whitelist
     */
    event AddressRemovedFromWhitelist(
        address indexed account,
        uint256 timestamp
    );

    /**
     * @dev Emitted when address is added to blacklist
     */
    event AddressBlacklisted(
        address indexed account,
        string reason,
        uint256 timestamp
    );

    /**
     * @dev Emitted when address is removed from blacklist
     */
    event AddressRemovedFromBlacklist(
        address indexed account,
        uint256 timestamp
    );

    /**
     * @dev Emitted when rate limit is exceeded
     */
    event RateLimitExceeded(
        address indexed account,
        bytes4 indexed functionSelector,
        uint256 currentCount,
        uint256 maxAllowed,
        uint256 timestamp
    );

    /**
     * @dev Emitted when validation fails
     */
    event ValidationFailed(
        address indexed caller,
        string validationType,
        string reason,
        uint256 timestamp
    );

    /**
     * @dev Emitted when overflow/underflow risk is detected
     */
    event ArithmeticRiskDetected(
        string operationType,
        uint256 value1,
        uint256 value2,
        string reason,
        uint256 timestamp
    );

    /**
     * @dev Emitted when rate limit configuration is updated
     */
    event RateLimitConfigUpdated(
        bytes4 indexed functionSelector,
        uint256 maxCalls,
        uint256 windowSize,
        bool enabled,
        uint256 timestamp
    );

    /**
     * @dev Emitted for audit trail logging
     */
    event AuditLogEntry(
        uint256 indexed logId,
        string operation,
        address indexed actor,
        string details,
        uint256 timestamp
    );

    /**
     * @dev Emitted when random number is generated
     */
    event RandomNumberGenerated(
        uint256 randomNumber,
        uint256 timestamp
    );

    // ============ Modifiers ============

    /**
     * @dev Ensures only the owner can call the function
     */
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "SecurityValidator: caller is not owner"
        );
        _;
    }

    /**
     * @dev Ensures address is whitelisted
     */
    modifier onlyWhitelisted() {
        require(
            whitelist[msg.sender],
            "SecurityValidator: caller not whitelisted"
        );
        _;
    }

    /**
     * @dev Ensures address is not blacklisted
     */
    modifier notBlacklisted() {
        require(
            !blacklist[msg.sender],
            "SecurityValidator: caller is blacklisted"
        );
        _;
    }

    /**
     * @dev Checks rate limit for function call
     */
    modifier checkRateLimit(bytes4 _functionSelector) {
        _enforceRateLimit(msg.sender, _functionSelector);
        _;
    }

    /**
     * @dev Validates input address
     */
    modifier validAddress(address _addr) {
        require(
            _addr != address(0),
            "SecurityValidator: invalid address (zero address)"
        );
        _;
    }

    // ============ Constructor ============

    /**
     * @dev Initialize the contract
     */
    constructor() {
        owner = msg.sender;
        randomCounter = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        auditLogCounter = 0;

        // Initialize default rate limit config
        rateLimitConfigs[bytes4(0)] = RateLimitConfig({
            maxCallsPerWindow: DEFAULT_MAX_CALLS,
            windowSize: DEFAULT_WINDOW_SIZE,
            enabled: true
        });

        _logAudit("ContractInitialized", "SecurityValidator initialized");
    }

    // ============ Whitelist/Blacklist Management ============

    /**
     * @dev Add address to whitelist
     * @param _account Address to whitelist
     */
    function addToWhitelist(address _account)
        external
        onlyOwner
        validAddress(_account)
    {
        require(
            !whitelist[_account],
            "SecurityValidator: address already whitelisted"
        );

        whitelist[_account] = true;

        emit AddressWhitelisted(_account, block.timestamp);
        _logAudit("AddToWhitelist", _concatenateStrings("Added: ", _addressToString(_account)));
    }

    /**
     * @dev Remove address from whitelist
     * @param _account Address to remove
     */
    function removeFromWhitelist(address _account)
        external
        onlyOwner
        validAddress(_account)
    {
        require(
            whitelist[_account],
            "SecurityValidator: address not whitelisted"
        );

        whitelist[_account] = false;

        emit AddressRemovedFromWhitelist(_account, block.timestamp);
        _logAudit("RemoveFromWhitelist", _concatenateStrings("Removed: ", _addressToString(_account)));
    }

    /**
     * @dev Add address to blacklist
     * @param _account Address to blacklist
     * @param _reason Reason for blacklisting
     */
    function addToBlacklist(address _account, string calldata _reason)
        external
        onlyOwner
        validAddress(_account)
    {
        require(
            !blacklist[_account],
            "SecurityValidator: address already blacklisted"
        );

        blacklist[_account] = true;

        emit AddressBlacklisted(_account, _reason, block.timestamp);
        _logAudit("AddToBlacklist", _concatenateStrings("Reason: ", _reason));
    }

    /**
     * @dev Remove address from blacklist
     * @param _account Address to remove
     */
    function removeFromBlacklist(address _account)
        external
        onlyOwner
        validAddress(_account)
    {
        require(
            blacklist[_account],
            "SecurityValidator: address not blacklisted"
        );

        blacklist[_account] = false;

        emit AddressRemovedFromBlacklist(_account, block.timestamp);
        _logAudit("RemoveFromBlacklist", _concatenateStrings("Removed: ", _addressToString(_account)));
    }

    // ============ Input Validation Functions ============

    /**
     * @dev Validate address input
     * @param _address Address to validate
     * @return result Validation result
     */
    function validateAddress(address _address)
        external
        returns (ValidationResult memory)
    {
        if (_address == address(0)) {
            emit ValidationFailed(msg.sender, "AddressValidation", "Zero address not allowed", block.timestamp);
            return ValidationResult({
                isValid: false,
                errorMessage: "Zero address",
                validationTime: block.timestamp
            });
        }

        if (blacklist[_address]) {
            emit ValidationFailed(msg.sender, "AddressValidation", "Address is blacklisted", block.timestamp);
            return ValidationResult({
                isValid: false,
                errorMessage: "Address is blacklisted",
                validationTime: block.timestamp
            });
        }

        return ValidationResult({
            isValid: true,
            errorMessage: "",
            validationTime: block.timestamp
        });
    }

    /**
     * @dev Validate unsigned integer range
     * @param _value Value to validate
     * @param _minValue Minimum allowed value
     * @param _maxValue Maximum allowed value
     * @return result Validation result
     */
    function validateUintRange(
        uint256 _value,
        uint256 _minValue,
        uint256 _maxValue
    ) external returns (ValidationResult memory) {
        if (_minValue > _maxValue) {
            emit ValidationFailed(msg.sender, "RangeValidation", "Invalid range bounds", block.timestamp);
            return ValidationResult({
                isValid: false,
                errorMessage: "Invalid range bounds",
                validationTime: block.timestamp
            });
        }

        if (_value < _minValue || _value > _maxValue) {
            emit ValidationFailed(msg.sender, "RangeValidation", "Value out of range", block.timestamp);
            return ValidationResult({
                isValid: false,
                errorMessage: "Value out of range",
                validationTime: block.timestamp
            });
        }

        return ValidationResult({
            isValid: true,
            errorMessage: "",
            validationTime: block.timestamp
        });
    }

    /**
     * @dev Validate addition won't overflow
     * @param _a First value
     * @param _b Second value
     * @return result Validation result
     */
    function validateAddition(uint256 _a, uint256 _b)
        external
        returns (ValidationResult memory)
    {
        if (_a > MAX_UINT256 - _b) {
            emit ArithmeticRiskDetected("Addition", _a, _b, "Overflow detected", block.timestamp);
            emit ValidationFailed(msg.sender, "OverflowValidation", "Addition overflow", block.timestamp);
            return ValidationResult({
                isValid: false,
                errorMessage: "Addition would overflow",
                validationTime: block.timestamp
            });
        }

        return ValidationResult({
            isValid: true,
            errorMessage: "",
            validationTime: block.timestamp
        });
    }

    /**
     * @dev Validate subtraction won't underflow
     * @param _a First value
     * @param _b Second value
     * @return result Validation result
     */
    function validateSubtraction(uint256 _a, uint256 _b)
        external
        returns (ValidationResult memory)
    {
        if (_b > _a) {
            emit ArithmeticRiskDetected("Subtraction", _a, _b, "Underflow detected", block.timestamp);
            emit ValidationFailed(msg.sender, "UnderflowValidation", "Subtraction underflow", block.timestamp);
            return ValidationResult({
                isValid: false,
                errorMessage: "Subtraction would underflow",
                validationTime: block.timestamp
            });
        }

        return ValidationResult({
            isValid: true,
            errorMessage: "",
            validationTime: block.timestamp
        });
    }

    /**
     * @dev Validate multiplication won't overflow
     * @param _a First value
     * @param _b Second value
     * @return result Validation result
     */
    function validateMultiplication(uint256 _a, uint256 _b)
        external
        returns (ValidationResult memory)
    {
        if (_a == 0 || _b == 0) {
            return ValidationResult({
                isValid: true,
                errorMessage: "",
                validationTime: block.timestamp
            });
        }

        if (_a > MAX_UINT256 / _b) {
            emit ArithmeticRiskDetected("Multiplication", _a, _b, "Overflow detected", block.timestamp);
            emit ValidationFailed(msg.sender, "OverflowValidation", "Multiplication overflow", block.timestamp);
            return ValidationResult({
                isValid: false,
                errorMessage: "Multiplication would overflow",
                validationTime: block.timestamp
            });
        }

        return ValidationResult({
            isValid: true,
            errorMessage: "",
            validationTime: block.timestamp
        });
    }

    /**
     * @dev Validate division by non-zero
     * @param _denominator Denominator value
     * @return result Validation result
     */
    function validateDivision(uint256 _denominator)
        external
        returns (ValidationResult memory)
    {
        if (_denominator == 0) {
            emit ValidationFailed(msg.sender, "DivisionValidation", "Division by zero", block.timestamp);
            return ValidationResult({
                isValid: false,
                errorMessage: "Division by zero",
                validationTime: block.timestamp
            });
        }

        return ValidationResult({
            isValid: true,
            errorMessage: "",
            validationTime: block.timestamp
        });
    }

    // ============ Safe Arithmetic Functions ============

    /**
     * @dev Safely add two unsigned integers
     * @param _a First value
     * @param _b Second value
     * @return result Sum if valid
     */
    function safeAdd(uint256 _a, uint256 _b)
        external
        pure
        returns (uint256)
    {
        require(_a <= MAX_UINT256 - _b, "SecurityValidator: addition overflow");
        return _a + _b;
    }

    /**
     * @dev Safely subtract two unsigned integers
     * @param _a First value
     * @param _b Second value
     * @return result Difference if valid
     */
    function safeSubtract(uint256 _a, uint256 _b)
        external
        pure
        returns (uint256)
    {
        require(_b <= _a, "SecurityValidator: subtraction underflow");
        return _a - _b;
    }

    /**
     * @dev Safely multiply two unsigned integers
     * @param _a First value
     * @param _b Second value
     * @return result Product if valid
     */
    function safeMultiply(uint256 _a, uint256 _b)
        external
        pure
        returns (uint256)
    {
        if (_a == 0 || _b == 0) {
            return 0;
        }
        require(_a <= MAX_UINT256 / _b, "SecurityValidator: multiplication overflow");
        return _a * _b;
    }

    /**
     * @dev Safely divide two unsigned integers
     * @param _numerator Numerator
     * @param _denominator Denominator
     * @return result Quotient if valid
     */
    function safeDivide(uint256 _numerator, uint256 _denominator)
        external
        pure
        returns (uint256)
    {
        require(_denominator != 0, "SecurityValidator: division by zero");
        return _numerator / _denominator;
    }

    // ============ Rate Limiting Functions ============

    /**
     * @dev Update rate limit configuration for a function
     * @param _functionSelector Function selector (first 4 bytes of function signature)
     * @param _maxCalls Maximum calls allowed
     * @param _windowSize Time window size in seconds
     * @param _enabled Whether rate limiting is enabled
     */
    function updateRateLimitConfig(
        bytes4 _functionSelector,
        uint256 _maxCalls,
        uint256 _windowSize,
        bool _enabled
    ) external onlyOwner {
        require(_maxCalls > 0, "SecurityValidator: max calls must be positive");
        require(_windowSize > 0, "SecurityValidator: window size must be positive");

        rateLimitConfigs[_functionSelector] = RateLimitConfig({
            maxCallsPerWindow: _maxCalls,
            windowSize: _windowSize,
            enabled: _enabled
        });

        emit RateLimitConfigUpdated(_functionSelector, _maxCalls, _windowSize, _enabled, block.timestamp);
        _logAudit("UpdateRateLimitConfig", _concatenateStrings("Function: ", _bytes4ToString(_functionSelector)));
    }

    /**
     * @dev Enforce rate limit for a function
     * @param _caller Caller address
     * @param _functionSelector Function selector
     */
    function _enforceRateLimit(address _caller, bytes4 _functionSelector)
        internal
    {
        RateLimitConfig storage config = rateLimitConfigs[_functionSelector];

        if (!config.enabled) {
            return;
        }

        UserCallTracker storage tracker = userCallTrackers[_caller][_functionSelector];

        // Reset counter if outside window
        if (block.timestamp - tracker.windowStartTime > config.windowSize) {
            tracker.windowStartTime = block.timestamp;
            tracker.callCount = 0;
        }

        // Check if limit exceeded
        if (tracker.callCount >= config.maxCallsPerWindow) {
            emit RateLimitExceeded(
                _caller,
                _functionSelector,
                tracker.callCount + 1,
                config.maxCallsPerWindow,
                block.timestamp
            );
            revert("SecurityValidator: rate limit exceeded");
        }

        tracker.callCount++;
        tracker.lastCallTime = block.timestamp;
    }

    /**
     * @dev Check remaining calls for a user and function
     * @param _user User address
     * @param _functionSelector Function selector
     * @return Remaining calls in current window
     */
    function getRemainingCalls(address _user, bytes4 _functionSelector)
        external
        view
        returns (uint256)
    {
        RateLimitConfig storage config = rateLimitConfigs[_functionSelector];
        UserCallTracker storage tracker = userCallTrackers[_user][_functionSelector];

        if (!config.enabled) {
            return type(uint256).max;
        }

        // Check if outside window
        if (block.timestamp - tracker.windowStartTime > config.windowSize) {
            return config.maxCallsPerWindow;
        }

        if (tracker.callCount >= config.maxCallsPerWindow) {
            return 0;
        }

        return config.maxCallsPerWindow - tracker.callCount;
    }

    // ============ Secure Random Number Generation ============

    /**
     * @dev Generate secure random number
     * @return Random number
     */
    function generateSecureRandom() external returns (uint256) {
        randomCounter = uint256(
            keccak256(
                abi.encodePacked(randomCounter, block.timestamp, block.number, msg.sender)
            )
        );

        emit RandomNumberGenerated(randomCounter, block.timestamp);
        _logAudit("GenerateSecureRandom", "Random number generated");

        return randomCounter;
    }

    /**
     * @dev Generate secure random number in range
     * @param _min Minimum value (inclusive)
     * @param _max Maximum value (inclusive)
     * @return Random number in range
     */
    function generateSecureRandomInRange(uint256 _min, uint256 _max)
        external
        returns (uint256)
    {
        require(_min <= _max, "SecurityValidator: invalid range");

        randomCounter = uint256(
            keccak256(
                abi.encodePacked(randomCounter, block.timestamp, block.number, msg.sender)
            )
        );

        uint256 range = _max - _min + 1;
        uint256 randomInRange = _min + (randomCounter % range);

        emit RandomNumberGenerated(randomInRange, block.timestamp);
        _logAudit("GenerateSecureRandomInRange", _concatenateStrings(
            "Range: ",
            _uint2str(_min),
            " - ",
            _uint2str(_max)
        ));

        return randomInRange;
    }

    // ============ Audit Logging ============

    /**
     * @dev Internal function to log audit entries
     * @param _operation Operation name
     * @param _details Operation details
     */
    function _logAudit(string memory _operation, string memory _details)
        internal
    {
        uint256 logId = auditLogCounter++;
        string memory logEntry = _concatenateStrings(
            "[",
            _uint2str(logId),
            "] ",
            _operation,
            ": ",
            _details,
            " at ",
            _uint2str(block.timestamp)
        );

        auditLog[logId] = logEntry;

        emit AuditLogEntry(logId, _operation, msg.sender, _details, block.timestamp);
    }

    /**
     * @dev Get audit log entry
     * @param _logId Log ID
     * @return Audit log entry string
     */
    function getAuditLogEntry(uint256 _logId)
        external
        view
        returns (string memory)
    {
        return auditLog[_logId];
    }

    /**
     * @dev Get total audit log count
     * @return Total count
     */
    function getAuditLogCount() external view returns (uint256) {
        return auditLogCounter;
    }

    // ============ Utility Functions ============

    /**
     * @dev Convert uint256 to string
     * @param _value Value to convert
     * @return String representation
     */
    function _uint2str(uint256 _value) internal pure returns (string memory) {
        if (_value == 0) {
            return "0";
        }

        uint256 temp = _value;
        uint256 digits;

        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);
        temp = _value;

        while (temp != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + (temp % 10)));
            temp /= 10;
        }

        return string(buffer);
    }

    /**
     * @dev Convert address to string
     * @param _address Address to convert
     * @return String representation
     */
    function _addressToString(address _address)
        internal
        pure
        returns (string memory)
    {
        bytes memory buffer = new bytes(42);
        buffer[0] = "0";
        buffer[1] = "x";

        uint256 value = uint256(uint160(_address));

        for (uint256 i = 41; i > 1; i--) {
            buffer[i] = _toHexChar(uint8(value & 0x0f));
            value >>= 4;
        }

        return string(buffer);
    }

    /**
     * @dev Convert bytes4 to string
     * @param _selector Selector to convert
     * @return String representation
     */
    function _bytes4ToString(bytes4 _selector)
        internal
        pure
        returns (string memory)
    {
        bytes memory buffer = new bytes(10);
        buffer[0] = "0";
        buffer[1] = "x";

        uint256 value = uint256(uint32(_selector));

        for (uint256 i = 9; i > 1; i--) {
            buffer[i] = _toHexChar(uint8(value & 0x0f));
            value >>= 4;
        }

        return string(buffer);
    }

    /**
     * @dev Convert uint to hex character
     * @param _value Value to convert
     * @return Hex character byte
     */
    function _toHexChar(uint8 _value) internal pure returns (bytes1) {
        if (_value < 10) {
            return bytes1(uint8(48 + _value));
        } else {
            return bytes1(uint8(87 + _value));
        }
    }

    /**
     * @dev Concatenate two strings
     * @param _str1 First string
     * @param _str2 Second string
     * @return Concatenated string
     */
    function _concatenateStrings(
        string memory _str1,
        string memory _str2
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(_str1, _str2));
    }

    /**
     * @dev Concatenate three strings
     * @return Concatenated string
     */
    function _concatenateStrings(
        string memory _str1,
        string memory _str2,
        string memory _str3
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(_str1, _str2, _str3));
    }

    /**
     * @dev Concatenate four strings
     * @return Concatenated string
     */
    function _concatenateStrings(
        string memory _str1,
        string memory _str2,
        string memory _str3,
        string memory _str4
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(_str1, _str2, _str3, _str4));
    }

    /**
     * @dev Concatenate five strings
     * @return Concatenated string
     */
    function _concatenateStrings(
        string memory _str1,
        string memory _str2,
        string memory _str3,
        string memory _str4,
        string memory _str5
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(_str1, _str2, _str3, _str4, _str5));
    }

    /**
     * @dev Concatenate six strings
     * @return Concatenated string
     */
    function _concatenateStrings(
        string memory _str1,
        string memory _str2,
        string memory _str3,
        string memory _str4,
        string memory _str5,
        string memory _str6
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(_str1, _str2, _str3, _str4, _str5, _str6));
    }

    /**
     * @dev Concatenate eight strings
     * @return Concatenated string
     */
    function _concatenateStrings(
        string memory _str1,
        string memory _str2,
        string memory _str3,
        string memory _str4,
        string memory _str5,
        string memory _str6,
        string memory _str7,
        string memory _str8
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(_str1, _str2, _str3, _str4, _str5, _str6, _str7, _str8));
    }
}
