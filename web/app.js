import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route, Switch, Link } from 'react-router-dom';
import { ThirdwebProvider, ConnectButton } from "thirdweb/react";
import { ethers } from 'ethers';

// Import your smart contract interaction component
import MyContractInteraction from './MyContractInteraction';

const client = {/* Your Thirdweb client setup */};
const wallets = [/* Your wallets setup */];

function App() {
  return (
    <ThirdwebProvider client={client}>
      <Router>
        <div>
          <nav>
            <ul>
              <li>
                <Link to="/">Home</Link>
              </li>
              <li>
                <Link to="/interact">Interact with Contract</Link>
              </li>
            </ul>
          </nav>
          <Switch>
            <Route path="/interact">
              <MyContractInteraction />
            </Route>
            <Route path="/">
              <div>
                <h1>My DApp</h1>
                <ConnectButton wallets={wallets} theme={"dark"} connectModal={{ size: "compact" }} />
                {/* Additional home page components */}
              </div>
            </Route>
          </Switch>
        </div>
      </Router>
    </ThirdwebProvider>
  );
}

ReactDOM.render(<App />, document.getElementById('root'));