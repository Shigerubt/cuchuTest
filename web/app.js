import React from 'react';
import ReactDOM from 'react-dom';
import { ThirdwebProvider, ConnectButton } from "thirdweb/react";
import { ethers } from 'ethers';
import {
  createWallet,
  walletConnect,
  createThirdwebClient,
} from "thirdweb/wallets";

// Anvil's default RPC URL
const anvilRpcUrl = "http://localhost:8545";

// Create an ethers provider using Anvil's RPC URL
const provider = new ethers.providers.JsonRpcProvider(anvilRpcUrl);

const client = createThirdwebClient({
  clientId: "YOUR_CLIENT_ID",
  provider: provider, // Use the ethers provider to connect to the Anvil local node
  chainId: 1, // Anvil mimics Ethereum's mainnet by default (1). Adjust based on your Anvil configuration.
});

const wallets = [
  createWallet("io.metamask"),
  createWallet("com.coinbase.wallet"),
  walletConnect(),
];

export default function App() {
  return (
    <ThirdwebProvider client={client}>
      <div>
        <h1>My DApp</h1>
        <ConnectButton wallets={wallets} theme={"dark"} connectModal={{ size: "compact" }} />
        {/* Your DApp components */}
      </div>
    </ThirdwebProvider>
  );
}

// Assuming you have an element with id 'root' in your HTML
ReactDOM.render(<App />, document.getElementById('root'));