import { useState } from 'react';
import { BrowserProvider, Contract } from 'ethers';
import { useEncrypt } from 'fhevm-sdk/react';
import { CONTRACT_ABI } from '../lib/contractABI';

interface WasteRecyclingAppProps {
  provider: BrowserProvider;
  account: string;
  contractAddress: string;
}

export default function WasteRecyclingApp({ provider, account, contractAddress }: WasteRecyclingAppProps) {
  const [plastic, setPlastic] = useState('');
  const [paper, setPaper] = useState('');
  const [glass, setGlass] = useState('');
  const [metal, setMetal] = useState('');
  const [organic, setOrganic] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [status, setStatus] = useState('');

  const { encryptMultiple, isEncrypting } = useEncrypt();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setStatus('Encrypting waste data...');

    try {
      const values = [
        parseInt(plastic) || 0,
        parseInt(paper) || 0,
        parseInt(glass) || 0,
        parseInt(metal) || 0,
        parseInt(organic) || 0,
      ];

      const encrypted = await encryptMultiple(values);

      if (!encrypted || encrypted.length !== 5) {
        throw new Error('Encryption failed');
      }

      setStatus('Submitting to blockchain...');

      const signer = await provider.getSigner();
      const contract = new Contract(contractAddress, CONTRACT_ABI, signer);

      const tx = await contract.submitReport(...encrypted.map(e => e || '0x'));
      setStatus('Waiting for confirmation...');

      await tx.wait();
      setStatus('Report submitted successfully!');

      setPlastic('');
      setPaper('');
      setGlass('');
      setMetal('');
      setOrganic('');
    } catch (error: any) {
      setStatus('Error: ' + (error.message || 'Failed to submit report'));
      console.error('Submission error:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="waste-app">
      <div className="card">
        <div className="card-header">
          <h3>Submit Waste Recycling Report</h3>
        </div>
        <div className="card-body">
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Plastic Waste (kg)</label>
              <input
                type="number"
                className="form-control"
                value={plastic}
                onChange={(e) => setPlastic(e.target.value)}
                min="0"
                placeholder="Enter plastic waste in kg"
              />
            </div>

            <div className="form-group">
              <label>Paper Waste (kg)</label>
              <input
                type="number"
                className="form-control"
                value={paper}
                onChange={(e) => setPaper(e.target.value)}
                min="0"
                placeholder="Enter paper waste in kg"
              />
            </div>

            <div className="form-group">
              <label>Glass Waste (kg)</label>
              <input
                type="number"
                className="form-control"
                value={glass}
                onChange={(e) => setGlass(e.target.value)}
                min="0"
                placeholder="Enter glass waste in kg"
              />
            </div>

            <div className="form-group">
              <label>Metal Waste (kg)</label>
              <input
                type="number"
                className="form-control"
                value={metal}
                onChange={(e) => setMetal(e.target.value)}
                min="0"
                placeholder="Enter metal waste in kg"
              />
            </div>

            <div className="form-group">
              <label>Organic Waste (kg)</label>
              <input
                type="number"
                className="form-control"
                value={organic}
                onChange={(e) => setOrganic(e.target.value)}
                min="0"
                placeholder="Enter organic waste in kg"
              />
            </div>

            <button
              type="submit"
              className="btn btn-primary btn-block"
              disabled={isSubmitting || isEncrypting}
            >
              {isSubmitting || isEncrypting ? 'Processing...' : 'Submit Report'}
            </button>
          </form>

          {status && (
            <div className={`alert mt-3 ${status.includes('Error') ? 'alert-danger' : 'alert-success'}`}>
              {status}
            </div>
          )}
        </div>
      </div>

      <div className="card mt-3">
        <div className="card-header">
          <h4>Contract Information</h4>
        </div>
        <div className="card-body">
          <p><strong>Contract Address:</strong></p>
          <code className="contract-address">{contractAddress}</code>
          <p className="mt-3"><strong>Network:</strong> Ethereum Sepolia Testnet</p>
          <p><strong>Privacy:</strong> All waste data is encrypted using FHE before submission</p>
        </div>
      </div>
    </div>
  );
}
