import React from 'react';
import { ABI } from './ContractABI';
import { CONTRACT_ADDRESS} from "./ContractAddress";
import { ethers } from "ethers";

function WARandom3() {
    //connect to contract block
    let contract;
    let signer;
    const CONTRACT_ABI = ABI;
    const ADDRESS = CONTRACT_ADDRESS;
    const connectContract = async () => {
        const ABI = CONTRACT_ABI;
        const Address = ADDRESS;
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        signer = provider.getSigner();
        contract = new ethers.Contract(Address, ABI, signer);
    }
    const createNumber = async () => {
        await connectContract();
        await contract.createRandomNumber();
    }

    return (
        <div>
            <button className='button-56' style={{backgroundColor: "lightGreen"}}
            onClick={createNumber}>3- Create Random Number</button>
        </div>
    )
}

export default WARandom3;