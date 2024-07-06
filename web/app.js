import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import { ethers } from 'ethers';

function App() {
  const [amount, setAmount] = useState('');

  const handleContribute = async (e) => {
    e.preventDefault();
    if (!window.ethereum) {
      alert('Please install MetaMask to proceed.');
      return;
    }
    try {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      await provider.send("eth_requestAccounts", []);
      const signer = provider.getSigner();
      const tx = await signer.sendTransaction({
        to: 'YOUR_CONTRACT_ADDRESS_HERE', // Replace with your contract's address
        value: ethers.utils.parseEther(amount)
      });
      console.log('Transaction:', tx);
    } catch (err) {
      console.error(err);
      alert('An error occurred. Please try again.');
    }
  };

  return (
    <div>
      <h1>Contribute to Our Project</h1>
      <form onSubmit={handleContribute}>
        <input
          type="text"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          placeholder="Amount in ETH"
        />
        <button type="submit">Contribute</button>
      </form>
    </div>
  );
}

ReactDOM.render(<App />, document.getElementById('root'));