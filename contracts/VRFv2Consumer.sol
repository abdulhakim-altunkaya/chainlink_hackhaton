// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.4;

import '@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol';
import '@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

//CONTRACT FOR RANDOMNESS 
//CONTRACT PROVIDED BY CHAINLINK
//ADAPTED FOR FANTOM_TESTNET

contract VRFv2Consumer is VRFConsumerBaseV2, ConfirmedOwner {
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    struct RequestStatus {
        bool fulfilled; 
        bool exists; 
        uint256[] randomWords;
    }
    mapping(uint256 => RequestStatus) public s_requests; 
    VRFCoordinatorV2Interface COORDINATOR;

    uint64 s_subscriptionId;

    uint256[] public requestIds;
    uint256 public lastRequestId;
    //keyhash for fantom_testnet hardcoded
    bytes32 keyHash = 0x121a143066e0f2f08b620784af77cccb35c6242460b4a8ee251b4b416abaebd4;
    uint32 callbackGasLimit = 100000;

    uint16 requestConfirmations = 3;

    uint32 numWords = 2;

    /*
    HARDCODED FOR FANTOM_TESTNET
    COORDINATOR: 0xbd13f08b8352A3635218ab9418E340c60d6Eb418
    */
    constructor(uint64 subscriptionId)
        VRFConsumerBaseV2(0xbd13f08b8352A3635218ab9418E340c60d6Eb418)
        ConfirmedOwner(msg.sender)
    {
        COORDINATOR = VRFCoordinatorV2Interface(0xbd13f08b8352A3635218ab9418E340c60d6Eb418);
        s_subscriptionId = subscriptionId;
    }


    function requestRandomWords() external /*onlyOwner*/ returns (uint256 requestId) {

        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_requests[requestId] = RequestStatus({randomWords: new uint256[](0), exists: true, fulfilled: false});
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) internal override {
        require(s_requests[_requestId].exists, 'request not found');
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);
    }

    function getRequestStatus(uint256 _requestId) external view returns (bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[_requestId].exists, 'request not found');
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }
}