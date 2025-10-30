export const CONTRACT_ABI = [
  {
    "inputs": [
      { "internalType": "bytes", "name": "plasticWeight", "type": "bytes" },
      { "internalType": "bytes", "name": "paperWeight", "type": "bytes" },
      { "internalType": "bytes", "name": "glassWeight", "type": "bytes" },
      { "internalType": "bytes", "name": "metalWeight", "type": "bytes" },
      { "internalType": "bytes", "name": "organicWeight", "type": "bytes" }
    ],
    "name": "submitReport",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "uint32", "name": "reportId", "type": "uint32" },
      { "indexed": true, "internalType": "address", "name": "reporter", "type": "address" },
      { "indexed": false, "internalType": "uint256", "name": "timestamp", "type": "uint256" }
    ],
    "name": "ReportSubmitted",
    "type": "event"
  }
];
