// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
interface Vest {
    function initiateVest(address owner, uint256 amount, uint256 initial, uint256 cliff, uint256 linear) external returns (bytes32);
}

interface Manage {
    function withdraw(uint8 _index, uint256 amount) external;
}
contract AdvisorManager is Context, Ownable {
    


    IERC20 private t;
    Vest private v;
    Manage private m;

    constructor(Vest v_, Manage m_, IERC20 t_) {
        v = v_;
        m = m_;
        t = t_;
        t.approve(address(v),1e30);
    }
    


    function vest(address advisor, uint256 amount) public virtual onlyOwner {
        v.initiateVest(advisor, amount, 0, 30 days, 180 days);
    }

    function withdraw(uint8 index, uint256 amount) public virtual onlyOwner {
        m.withdraw(index, amount);
    }

    




}