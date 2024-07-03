document.getElementById('contributeButton').addEventListener('click', async () => {
    if (typeof window.ethereum !== 'undefined') {
        try {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            const contractAddress = 'YOUR_CONTRACT_ADDRESS_HERE';
            const contractABI = [
                // Insert your contract's ABI here
                "function contribute() external payable"
            ];
            const contract = new ethers.Contract(contractAddress, contractABI, signer);

            const amount = ethers.utils.parseEther(document.getElementById('amount').value);
            const tx = await contract.contribute({ value: amount });
            await tx.wait();

            alert('Contribution successful!');
        } catch (error) {
            console.error(error);
            alert('An error occurred. Please check the console for details.');
        }
    } else {
        alert('Please install MetaMask!');
    }
});