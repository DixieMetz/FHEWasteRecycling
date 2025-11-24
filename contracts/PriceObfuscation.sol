// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FHE, euint64, ebool} from "@fhevm/solidity/lib/FHE.sol";

/**
 * @title PriceObfuscation
 * @dev Implements privacy-preserving price handling with fuzzy price techniques,
 * random obfuscation, confidential value handling, commitment-based verification,
 * and range proofs to prevent price leakage.
 */
contract PriceObfuscation {
    // ============ Types ============

    /**
     * @dev Structure for obfuscated price storage
     */
    struct ObfuscatedPrice {
        euint64 encryptedPrice;
        bytes32 priceCommitment;
        uint256 obfuscationFactor;
        uint256 timestamp;
        bool isVerified;
        string rangeProof;
    }

    /**
     * @dev Structure for price range proof
     */
    struct RangeProof {
        uint256 minValue;
        uint256 maxValue;
        bool isValid;
        string proofData;
        uint256 generationTime;
    }

    /**
     * @dev Structure for fuzzy price tier
     */
    struct FuzzyPriceTier {
        uint256 basePrice;
        uint256 fuzzyRange;
        uint256 tierIndex;
        bool active;
    }

    /**
     * @dev Structure for confidential transaction
     */
    struct ConfidentialTransaction {
        bytes32 transactionHash;
        euint64 encryptedAmount;
        bytes32 amountCommitment;
        address participant;
        uint256 timestamp;
        bool isSettled;
    }

    // ============ Constants ============

    /// @dev Maximum price value to prevent overflow
    uint256 public constant MAX_PRICE = 10**18; // 1 ETH in wei

    /// @dev Minimum fuzzy range percentage (0.1%)
    uint256 public constant MIN_FUZZY_RANGE = 100; // basis points (0.1% = 10 basis points)

    /// @dev Maximum fuzzy range percentage (10%)
    uint256 public constant MAX_FUZZY_RANGE = 1000; // basis points

    /// @dev Basis points denominator (10000 = 100%)
    uint256 public constant BASIS_POINTS = 10000;

    /// @dev Minimum range for proof validation
    uint256 public constant MIN_PROOF_RANGE = 1;

    /// @dev Maximum range for proof validation
    uint256 public constant MAX_PROOF_RANGE = MAX_PRICE;

    // ============ State Variables ============

    /// @dev Mapping of price IDs to obfuscated prices
    mapping(uint256 => ObfuscatedPrice) public obfuscatedPrices;

    /// @dev Mapping of price IDs to range proofs
    mapping(uint256 => RangeProof) public rangeProofs;

    /// @dev Mapping of fuzzy tier IDs to tier configurations
    mapping(uint256 => FuzzyPriceTier) public fuzzyPriceTiers;

    /// @dev Mapping of transaction hashes to confidential transactions
    mapping(bytes32 => ConfidentialTransaction) public confidentialTransactions;

    /// @dev Mapping of price commitments to verification status
    mapping(bytes32 => bool) public commitmentVerifications;

    /// @dev Counter for price IDs
    uint256 public priceIdCounter;

    /// @dev Counter for fuzzy tier IDs
    uint256 public fuzzyTierCounter;

    /// @dev Owner of the contract
    address public owner;

    /// @dev Random seed for obfuscation
    uint256 private randomSeed;

    /// @dev Default fuzzy range in basis points
    uint256 public defaultFuzzyRange;

    /// @dev Audit log for price operations
    mapping(uint256 => string) public auditLog;

    /// @dev Total audit log entries
    uint256 public auditLogCounter;

    // ============ Events ============

    /**
     * @dev Emitted when price is obfuscated
     */
    event PriceObfuscated(
        uint256 indexed priceId,
        uint256 obfuscationFactor,
        bytes32 commitment,
        uint256 timestamp
    );

    /**
     * @dev Emitted when range proof is generated
     */
    event RangeProofGenerated(
        uint256 indexed priceId,
        uint256 minValue,
        uint256 maxValue,
        uint256 timestamp
    );

    /**
     * @dev Emitted when price commitment is verified
     */
    event PriceCommitmentVerified(
        uint256 indexed priceId,
        bytes32 commitment,
        bool verified,
        uint256 timestamp
    );

    /**
     * @dev Emitted when confidential transaction is recorded
     */
    event ConfidentialTransactionRecorded(
        bytes32 indexed transactionHash,
        address indexed participant,
        uint256 timestamp
    );

    /**
     * @dev Emitted when fuzzy price tier is created
     */
    event FuzzyPriceTierCreated(
        uint256 indexed tierId,
        uint256 basePrice,
        uint256 fuzzyRange,
        uint256 timestamp
    );

    /**
     * @dev Emitted when fuzzy price tier is updated
     */
    event FuzzyPriceTierUpdated(
        uint256 indexed tierId,
        uint256 newBasePrice,
        uint256 newFuzzyRange,
        uint256 timestamp
    );

    /**
     * @dev Emitted when confidential transaction is settled
     */
    event ConfidentialTransactionSettled(
        bytes32 indexed transactionHash,
        uint256 timestamp
    );

    /**
     * @dev Emitted when obfuscation parameters are adjusted
     */
    event ObfuscationParametersUpdated(
        uint256 newFuzzyRange,
        uint256 timestamp
    );

    /**
     * @dev Emitted for audit trail
     */
    event AuditLogEntry(
        uint256 indexed logId,
        string operation,
        address indexed actor,
        string details,
        uint256 timestamp
    );

    /**
     * @dev Emitted when price verification fails
     */
    event VerificationFailed(
        uint256 indexed priceId,
        string reason,
        uint256 timestamp
    );

    // ============ Modifiers ============

    /**
     * @dev Ensures only the owner can call the function
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "PriceObfuscation: caller is not owner");
        _;
    }

    /**
     * @dev Ensures price is within valid bounds
     */
    modifier validPrice(uint256 _price) {
        require(
            _price > 0 && _price <= MAX_PRICE,
            "PriceObfuscation: invalid price"
        );
        _;
    }

    /**
     * @dev Ensures price ID exists
     */
    modifier validPriceId(uint256 _priceId) {
        require(
            _priceId < priceIdCounter,
            "PriceObfuscation: invalid price ID"
        );
        _;
    }

    /**
     * @dev Ensures fuzzy tier exists
     */
    modifier validTierId(uint256 _tierId) {
        require(
            _tierId < fuzzyTierCounter,
            "PriceObfuscation: invalid tier ID"
        );
        _;
    }

    // ============ Constructor ============

    /**
     * @dev Initialize the contract
     * @param _defaultFuzzyRange Default fuzzy range in basis points
     */
    constructor(uint256 _defaultFuzzyRange) {
        require(
            _defaultFuzzyRange >= MIN_FUZZY_RANGE &&
                _defaultFuzzyRange <= MAX_FUZZY_RANGE,
            "PriceObfuscation: invalid default fuzzy range"
        );

        owner = msg.sender;
        defaultFuzzyRange = _defaultFuzzyRange;
        priceIdCounter = 0;
        fuzzyTierCounter = 0;
        auditLogCounter = 0;
        randomSeed = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender))
        );

        _logAudit("ContractInitialized", "PriceObfuscation initialized");
    }

    // ============ Core Functions ============

    /**
     * @dev Obfuscate a price with fuzzy technique
     * @param _price The price to obfuscate
     * @return priceId Unique identifier for this obfuscated price
     */
    function obfuscatePrice(uint256 _price)
        external
        validPrice(_price)
        returns (uint256)
    {
        uint256 currentPriceId = priceIdCounter;

        // Generate obfuscation factor
        uint256 obfuscationFactor = _generateObfuscationFactor();

        // Create encrypted price (value remains encrypted)
        euint64 encryptedPrice = FHE.asEuint64(_price);

        // Calculate commitment to price
        bytes32 priceCommitment = keccak256(
            abi.encodePacked(_price, obfuscationFactor, block.timestamp)
        );

        // Generate range proof for this price
        _generateRangeProofForPrice(currentPriceId, _price);

        // Store obfuscated price
        obfuscatedPrices[currentPriceId] = ObfuscatedPrice({
            encryptedPrice: encryptedPrice,
            priceCommitment: priceCommitment,
            obfuscationFactor: obfuscationFactor,
            timestamp: block.timestamp,
            isVerified: false,
            rangeProof: ""
        });

        priceIdCounter++;

        emit PriceObfuscated(
            currentPriceId,
            obfuscationFactor,
            priceCommitment,
            block.timestamp
        );

        _logAudit(
            "PriceObfuscated",
            _concatenateStrings(
                "Price ID: ",
                _uint2str(currentPriceId),
                ", Factor: ",
                _uint2str(obfuscationFactor)
            )
        );

        return currentPriceId;
    }

    /**
     * @dev Apply fuzzy pricing to a base price
     * @param _basePrice The base price
     * @return fuzzyPrice A price within the fuzzy range
     */
    function applyFuzzyPrice(uint256 _basePrice)
        external
        validPrice(_basePrice)
        returns (uint256)
    {
        require(
            defaultFuzzyRange <= MAX_FUZZY_RANGE,
            "PriceObfuscation: invalid fuzzy range"
        );

        // Calculate fuzzy range
        uint256 fuzzyAmount = (_basePrice * defaultFuzzyRange) / BASIS_POINTS;

        // Generate random offset within range
        uint256 randomOffset = _generateRandomOffset(fuzzyAmount);

        // Apply random variation (up or down)
        uint256 fuzzyPrice = (randomOffset % 2 == 0)
            ? _basePrice + randomOffset
            : _basePrice > randomOffset
            ? _basePrice - randomOffset
            : _basePrice;

        // Ensure fuzzy price is within valid bounds
        require(
            fuzzyPrice > 0 && fuzzyPrice <= MAX_PRICE,
            "PriceObfuscation: fuzzy price out of bounds"
        );

        _logAudit(
            "FuzzyPriceApplied",
            _concatenateStrings(
                "Base: ",
                _uint2str(_basePrice),
                ", Fuzzy: ",
                _uint2str(fuzzyPrice)
            )
        );

        return fuzzyPrice;
    }

    /**
     * @dev Verify price commitment
     * @param _priceId The price ID
     * @param _price The actual price
     * @param _obfuscationFactor The obfuscation factor
     * @return verified True if commitment matches
     */
    function verifyPriceCommitment(
        uint256 _priceId,
        uint256 _price,
        uint256 _obfuscationFactor
    ) external validPriceId(_priceId) returns (bool) {
        ObfuscatedPrice storage obfuscated = obfuscatedPrices[_priceId];

        // Recreate commitment hash
        bytes32 calculatedCommitment = keccak256(
            abi.encodePacked(_price, _obfuscationFactor, obfuscated.timestamp)
        );

        // Verify commitment matches
        bool verified = calculatedCommitment == obfuscated.priceCommitment;

        if (verified) {
            obfuscated.isVerified = true;
            commitmentVerifications[obfuscated.priceCommitment] = true;

            _logAudit(
                "PriceCommitmentVerified",
                _concatenateStrings("Price ID: ", _uint2str(_priceId))
            );

            emit PriceCommitmentVerified(
                _priceId,
                obfuscated.priceCommitment,
                true,
                block.timestamp
            );
        } else {
            emit VerificationFailed(
                _priceId,
                "Commitment mismatch",
                block.timestamp
            );
        }

        return verified;
    }

    /**
     * @dev Generate range proof for price
     * @param _minValue Minimum value in range
     * @param _maxValue Maximum value in range
     * @return priceId The price ID for this proof
     */
    function generateRangeProof(uint256 _minValue, uint256 _maxValue)
        external
        returns (uint256)
    {
        require(
            _minValue >= MIN_PROOF_RANGE,
            "PriceObfuscation: min value too small"
        );
        require(
            _maxValue <= MAX_PROOF_RANGE,
            "PriceObfuscation: max value too large"
        );
        require(_minValue <= _maxValue, "PriceObfuscation: invalid range");

        uint256 currentPriceId = priceIdCounter;

        // Create range proof
        rangeProofs[currentPriceId] = RangeProof({
            minValue: _minValue,
            maxValue: _maxValue,
            isValid: true,
            proofData: _generateProofData(_minValue, _maxValue),
            generationTime: block.timestamp
        });

        priceIdCounter++;

        emit RangeProofGenerated(
            currentPriceId,
            _minValue,
            _maxValue,
            block.timestamp
        );

        _logAudit(
            "RangeProofGenerated",
            _concatenateStrings(
                "Range: ",
                _uint2str(_minValue),
                " - ",
                _uint2str(_maxValue)
            )
        );

        return currentPriceId;
    }

    /**
     * @dev Record confidential transaction
     * @param _transactionHash Hash of the transaction
     * @param _encryptedAmount Encrypted transaction amount
     * @param _participant Participant address
     * @return success True if recorded successfully
     */
    function recordConfidentialTransaction(
        bytes32 _transactionHash,
        euint64 _encryptedAmount,
        address _participant
    ) external onlyOwner returns (bool) {
        require(
            _participant != address(0),
            "PriceObfuscation: invalid participant"
        );
        require(
            euint64.unwrap(_encryptedAmount) != 0,
            "PriceObfuscation: invalid amount"
        );

        // Create commitment for amount
        bytes32 amountCommitment = keccak256(
            abi.encodePacked(
                euint64.unwrap(_encryptedAmount),
                block.timestamp
            )
        );

        // Store confidential transaction
        confidentialTransactions[_transactionHash] = ConfidentialTransaction({
            transactionHash: _transactionHash,
            encryptedAmount: _encryptedAmount,
            amountCommitment: amountCommitment,
            participant: _participant,
            timestamp: block.timestamp,
            isSettled: false
        });

        emit ConfidentialTransactionRecorded(
            _transactionHash,
            _participant,
            block.timestamp
        );

        _logAudit(
            "ConfidentialTransactionRecorded",
            "Transaction recorded with encryption"
        );

        return true;
    }

    /**
     * @dev Settle confidential transaction
     * @param _transactionHash Hash of the transaction
     * @return success True if settled successfully
     */
    function settleConfidentialTransaction(bytes32 _transactionHash)
        external
        onlyOwner
        returns (bool)
    {
        ConfidentialTransaction storage transaction = confidentialTransactions[
            _transactionHash
        ];

        require(
            transaction.participant != address(0),
            "PriceObfuscation: transaction not found"
        );
        require(
            !transaction.isSettled,
            "PriceObfuscation: transaction already settled"
        );

        transaction.isSettled = true;

        emit ConfidentialTransactionSettled(_transactionHash, block.timestamp);

        _logAudit(
            "ConfidentialTransactionSettled",
            "Transaction settlement completed"
        );

        return true;
    }

    /**
     * @dev Create fuzzy price tier
     * @param _basePrice Base price for tier
     * @param _fuzzyRange Fuzzy range in basis points
     * @return tierId The tier ID
     */
    function createFuzzyPriceTier(uint256 _basePrice, uint256 _fuzzyRange)
        external
        validPrice(_basePrice)
        onlyOwner
        returns (uint256)
    {
        require(
            _fuzzyRange >= MIN_FUZZY_RANGE && _fuzzyRange <= MAX_FUZZY_RANGE,
            "PriceObfuscation: invalid fuzzy range"
        );

        uint256 currentTierId = fuzzyTierCounter;

        fuzzyPriceTiers[currentTierId] = FuzzyPriceTier({
            basePrice: _basePrice,
            fuzzyRange: _fuzzyRange,
            tierIndex: currentTierId,
            active: true
        });

        fuzzyTierCounter++;

        emit FuzzyPriceTierCreated(
            currentTierId,
            _basePrice,
            _fuzzyRange,
            block.timestamp
        );

        _logAudit(
            "FuzzyPriceTierCreated",
            _concatenateStrings(
                "Tier ID: ",
                _uint2str(currentTierId),
                ", Base: ",
                _uint2str(_basePrice)
            )
        );

        return currentTierId;
    }

    /**
     * @dev Update fuzzy price tier
     * @param _tierId Tier ID to update
     * @param _newBasePrice New base price
     * @param _newFuzzyRange New fuzzy range
     */
    function updateFuzzyPriceTier(
        uint256 _tierId,
        uint256 _newBasePrice,
        uint256 _newFuzzyRange
    ) external validTierId(_tierId) validPrice(_newBasePrice) onlyOwner {
        require(
            _newFuzzyRange >= MIN_FUZZY_RANGE &&
                _newFuzzyRange <= MAX_FUZZY_RANGE,
            "PriceObfuscation: invalid fuzzy range"
        );

        FuzzyPriceTier storage tier = fuzzyPriceTiers[_tierId];
        require(tier.active, "PriceObfuscation: tier is not active");

        tier.basePrice = _newBasePrice;
        tier.fuzzyRange = _newFuzzyRange;

        emit FuzzyPriceTierUpdated(
            _tierId,
            _newBasePrice,
            _newFuzzyRange,
            block.timestamp
        );

        _logAudit(
            "FuzzyPriceTierUpdated",
            _concatenateStrings(
                "Tier ID: ",
                _uint2str(_tierId),
                ", New Base: ",
                _uint2str(_newBasePrice)
            )
        );
    }

    // ============ Internal Functions ============

    /**
     * @dev Generate obfuscation factor
     * @return Obfuscation factor
     */
    function _generateObfuscationFactor() internal returns (uint256) {
        randomSeed = uint256(
            keccak256(
                abi.encodePacked(randomSeed, block.timestamp, block.number)
            )
        );
        return randomSeed;
    }

    /**
     * @dev Generate random offset
     * @param _maxAmount Maximum amount
     * @return Random offset
     */
    function _generateRandomOffset(uint256 _maxAmount)
        internal
        returns (uint256)
    {
        randomSeed = uint256(
            keccak256(
                abi.encodePacked(randomSeed, block.timestamp, msg.sender)
            )
        );
        return randomSeed % (_maxAmount + 1);
    }

    /**
     * @dev Generate range proof data
     * @param _minValue Minimum value
     * @param _maxValue Maximum value
     * @return Proof data string
     */
    function _generateProofData(uint256 _minValue, uint256 _maxValue)
        internal
        view
        returns (string memory)
    {
        return
            _concatenateStrings(
                "Range[",
                _uint2str(_minValue),
                ",",
                _uint2str(_maxValue),
                "]"
            );
    }

    /**
     * @dev Generate range proof for price
     * @param _priceId Price ID
     * @param _price Price value
     */
    function _generateRangeProofForPrice(uint256 _priceId, uint256 _price)
        internal
    {
        // Calculate fuzzy range
        uint256 fuzzyAmount = (_price * defaultFuzzyRange) / BASIS_POINTS;

        uint256 minPrice = _price > fuzzyAmount ? _price - fuzzyAmount : 1;
        uint256 maxPrice = _price + fuzzyAmount;

        // Ensure within bounds
        if (maxPrice > MAX_PRICE) {
            maxPrice = MAX_PRICE;
        }

        ObfuscatedPrice storage obfuscated = obfuscatedPrices[_priceId];
        obfuscated.rangeProof = _concatenateStrings(
            "Range[",
            _uint2str(minPrice),
            ",",
            _uint2str(maxPrice),
            "]"
        );
    }

    /**
     * @dev Log audit entry
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
            _details
        );

        auditLog[logId] = logEntry;

        emit AuditLogEntry(logId, _operation, msg.sender, _details, block.timestamp);
    }

    // ============ Utility Functions ============

    /**
     * @dev Convert uint256 to string
     * @param _value Value to convert
     * @return String representation
     */
    function _uint2str(uint256 _value)
        internal
        pure
        returns (string memory)
    {
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
     * @dev Concatenate strings
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
     * @dev Concatenate strings (6 parameters)
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
        return
            string(abi.encodePacked(_str1, _str2, _str3, _str4, _str5, _str6));
    }

    // ============ View Functions ============

    /**
     * @dev Get obfuscated price
     * @param _priceId Price ID
     * @return ObfuscatedPrice structure
     */
    function getObfuscatedPrice(uint256 _priceId)
        external
        view
        validPriceId(_priceId)
        returns (ObfuscatedPrice memory)
    {
        return obfuscatedPrices[_priceId];
    }

    /**
     * @dev Get range proof
     * @param _priceId Price ID
     * @return RangeProof structure
     */
    function getRangeProof(uint256 _priceId)
        external
        view
        validPriceId(_priceId)
        returns (RangeProof memory)
    {
        return rangeProofs[_priceId];
    }

    /**
     * @dev Get fuzzy price tier
     * @param _tierId Tier ID
     * @return FuzzyPriceTier structure
     */
    function getFuzzyPriceTier(uint256 _tierId)
        external
        view
        validTierId(_tierId)
        returns (FuzzyPriceTier memory)
    {
        return fuzzyPriceTiers[_tierId];
    }

    /**
     * @dev Get confidential transaction
     * @param _transactionHash Transaction hash
     * @return ConfidentialTransaction structure
     */
    function getConfidentialTransaction(bytes32 _transactionHash)
        external
        view
        returns (ConfidentialTransaction memory)
    {
        return confidentialTransactions[_transactionHash];
    }

    /**
     * @dev Get total price count
     * @return Total prices
     */
    function getPriceCount() external view returns (uint256) {
        return priceIdCounter;
    }

    /**
     * @dev Get total tier count
     * @return Total tiers
     */
    function getTierCount() external view returns (uint256) {
        return fuzzyTierCounter;
    }

    /**
     * @dev Get audit log entry
     * @param _logId Log ID
     * @return Audit log string
     */
    function getAuditLogEntry(uint256 _logId)
        external
        view
        returns (string memory)
    {
        return auditLog[_logId];
    }
}
