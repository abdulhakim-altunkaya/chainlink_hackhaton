import React from 'react';
import GetBalance from './GetBalance';
import { useState } from 'react';
import GetContractDetails from './GetContractDetails';
import { useNavigate } from 'react-router-dom';
import CheckMembership from "./CheckMembership";
 

function ReadAreaDetails() {
  const {ethereum} = window;
  const navigate = useNavigate();

  let[account, setAccount] = useState("");

  const connectMetamask =  async () => {
    if(window.ethereum !== "undefined") {
      const accounts = await ethereum.request({ method: "eth_requestAccounts"});
      setAccount(accounts[0]);
    } else {
      setAccount("install metamask to your browser my good lord");
    }
  }

  return (
    <div>
      <button className='button-56' onClick={connectMetamask}> Connect to Metamask </button>
      <p>Your Account is: {account}</p>
      <GetBalance />
      <GetContractDetails />
      <CheckMembership account={account} />
      <button className='button-56' onClick={() => navigate("/proposals")}>SEE WAITING PROPOSALS</button>
      <br />
      <button className='button-56' onClick={() => navigate('/passed')}>SEE PASSED PROPOSALS</button>
      <br />
      <button className='button-56' onClick={() => navigate('/rejected')}>SEE REJECTED PROPOSALS</button>
      <br />
      <button className='button-56' onClick={() => navigate("/details")}>PREVIOUS PROPOSALS DETAILS</button>
    </div>
  )
}

export default ReadAreaDetails;