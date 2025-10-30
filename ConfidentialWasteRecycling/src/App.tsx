import { useState, useEffect } from 'react';
import { BrowserProvider } from 'ethers';
import { FhevmProvider } from 'fhevm-sdk/react';
import WasteRecyclingApp from './components/WasteRecyclingApp';
import './styles.css';

const CONTRACT_ADDRESS = '0x6a65Ea0Ce4F2fc31acFA2722d0153145dc48Cc83';
const SEPOLIA_CHAIN_ID = 11155111;

function App() {
  const [provider, setProvider] = useState<BrowserProvider | null>(null);
  const [account, setAccount] = useState<string>('');
  const [isConnecting, setIsConnecting] = useState(false);
  const [error, setError] = useState<string>('');

  const connectWallet = async () => {
    setIsConnecting(true);
    setError('');

    try {
      if (!window.ethereum) {
        throw new Error('MetaMask is not installed');
      }

      const provider = new BrowserProvider(window.ethereum);
      const network = await provider.getNetwork();

      if (Number(network.chainId) !== SEPOLIA_CHAIN_ID) {
        try {
          await window.ethereum.request({
            method: 'wallet_switchEthereumChain',
            params: [{ chainId: '0x' + SEPOLIA_CHAIN_ID.toString(16) }],
          });
        } catch (switchError: any) {
          if (switchError.code === 4902) {
            throw new Error('Please add Sepolia network to MetaMask');
          }
          throw switchError;
        }
      }

      const accounts = await provider.send('eth_requestAccounts', []);
      setProvider(provider);
      setAccount(accounts[0]);
    } catch (err: any) {
      setError(err.message || 'Failed to connect wallet');
      console.error('Wallet connection error:', err);
    } finally {
      setIsConnecting(false);
    }
  };

  useEffect(() => {
    if (window.ethereum) {
      window.ethereum.on('accountsChanged', (accounts: string[]) => {
        setAccount(accounts[0] || '');
      });

      window.ethereum.on('chainChanged', () => {
        window.location.reload();
      });
    }
  }, []);

  const fhevmConfig = {
    chainId: SEPOLIA_CHAIN_ID,
    rpcUrl: 'https://rpc.sepolia.org',
  };

  return (
    <div className="app">
      <div className="background-gradient"></div>
      <div className="container">
        <header className="header">
          <h1 className="title">
            <span className="icon">♻️</span>
            Confidential Waste Recycling
          </h1>
          <p className="subtitle">Secure waste tracking using Fully Homomorphic Encryption</p>
        </header>

        {!account ? (
          <div className="connect-section">
            <div className="card">
              <div className="card-body text-center">
                <h2 className="card-title">Welcome to Confidential Waste Recycling</h2>
                <p className="card-text mb-4">
                  Connect your MetaMask wallet to start reporting waste data securely on the blockchain.
                </p>
                <button
                  className="btn btn-primary btn-lg"
                  onClick={connectWallet}
                  disabled={isConnecting}
                >
                  {isConnecting ? 'Connecting...' : 'Connect MetaMask'}
                </button>
                {error && (
                  <div className="alert alert-danger mt-3" role="alert">
                    {error}
                  </div>
                )}
              </div>
            </div>
          </div>
        ) : (
          <FhevmProvider config={fhevmConfig}>
            <div className="account-info">
              <span className="badge badge-primary">
                Connected: {account.slice(0, 6)}...{account.slice(-4)}
              </span>
            </div>
            <WasteRecyclingApp
              provider={provider!}
              account={account}
              contractAddress={CONTRACT_ADDRESS}
            />
          </FhevmProvider>
        )}
      </div>
    </div>
  );
}

export default App;
