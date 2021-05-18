// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Vesting is Context {
    using SafeMath for uint256;

    IERC20 private _token;

    struct Vest {
        address owner;
        uint256 amount;
        uint256 start;
        uint256 initial;
        uint256 cliff;
        uint256 linear;
        uint256 claimed;
    }

    mapping(bytes32 => Vest) private _vests;
    mapping(address => uint256) private _nonce;

    constructor(IERC20 token) {
        _token = token;
    }

    function getClaimable(address owner, uint256 nonce)
        public
        view
        virtual
        returns (uint256)
    {
        bytes32 index = getVestId(owner, nonce);
        uint256 tokenClaimable;
        if (
            block.timestamp >= _vests[index].start.add(_vests[index].cliff) &&
            block.timestamp <=
            _vests[index].start.add(_vests[index].cliff).add(
                _vests[index].linear
            )
        ) {
            uint256 timePassed =
                block.timestamp.sub(
                    (_vests[index].start).add(_vests[index].cliff)
                );
            tokenClaimable = (
                (_vests[index].amount - _vests[index].initial)
                    .mul(timePassed)
                    .div(_vests[index].linear)
            )
                .add(_vests[index].initial)
                .sub(_vests[index].claimed);
        } else if (
            block.timestamp >
            _vests[index].start.add(_vests[index].cliff).add(
                _vests[index].linear
            )
        ) {
            tokenClaimable = _vests[index].amount.sub(_vests[index].claimed);
        }
        return tokenClaimable;
    }

    function claim(address owner, uint256 nonce) public virtual {
        uint256 tokenClaimable = getClaimable(owner, nonce);
        bytes32 index = getVestId(owner, nonce);
        _vests[index].claimed = _vests[index].claimed.add(tokenClaimable);
        _token.transfer(owner, tokenClaimable);
    }

    function initiateVest(
        uint256 amount,
        uint256 initial,
        uint256 cliff,
        uint256 linear
    ) public virtual returns (bytes32) {
        return initiateVest(_msgSender(), amount, initial, cliff, linear);
    }

    function initiateVest(
        address owner,
        uint256 amount,
        uint256 initial,
        uint256 cliff,
        uint256 linear
    ) public virtual returns (bytes32) {
        require(
            initial < amount,
            "Vesting: initial amount should be less than total amount."
        );
        _token.transferFrom(_msgSender(), address(this), amount);
        bytes32 index = getVestId(owner, _nonce[owner]);
        _vests[index] = Vest(
            owner,
            amount,
            block.timestamp,
            initial,
            cliff,
            linear,
            0
        );
        _vests[index].claimed = _vests[index].claimed.add(
            _vests[index].initial
        );
        _token.transfer(_vests[index].owner, _vests[index].initial);
        _nonce[owner]++;
        return index;
    }

    function getVestId(address user, uint256 nonce)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(user, nonce));
    }

    function getNonce(address user) public view returns (uint256) {
        return _nonce[user];
    }

    function getVest(bytes32 index) public view virtual returns (Vest memory) {
        return _vests[index];
    }
}
