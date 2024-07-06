import React from 'react';
import ReactDOM from 'react-dom';
import {
  ThirdwebProvider,
  ConnectButton,
} from "thirdweb/react";
import {
  createWallet,
  walletConnect,
  createThirdwebClient,
} from "thirdweb/wallets";

const client = createThirdwebClient({
  clientId: "YOUR_CLIENT_ID",
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
        <ConnectButton
          wallets={wallets}
          theme={"dark"}
          connectModal={{ size: "compact" }}
        />
        <div>
          <input id="amount" type="text" placeholder="Amount to Contribute" />
          <button id="contributeButton">Contribute</button>
        </div>
      </div>
    </ThirdwebProvider>
  );
}

// Render the App component to the DOM
ReactDOM.render(<App />, document.getElementById('root'));