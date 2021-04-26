// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Context.sol";
import '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';


contract MultisigWallet is Context{
    using ECDSA for bytes32;


    mapping(address => uint8) private _voters;

    uint8 private _required;

    uint256 private nonce;


    function getNonce() public view returns(uint256) {
        return nonce;
    }

    fallback() external payable  {}
    
    constructor (address voter1, address voter2, address voter3, uint8 required) {
        _voters[voter1] =1;
        _voters[voter2] =1;
        _voters[voter3] =1;
        _required = required;

    }
    
    function getHash(uint256 nonce_, address to, uint256 value, bytes memory data) public pure returns (bytes32 hash){
        hash = keccak256(abi.encodePacked(nonce_, to, value ,data));
    }

    function execute(address to, uint256 value, bytes memory data, bytes memory sig1, bytes memory sig2, bytes memory sig3) public payable returns (bool success) {
        bytes32 hash = keccak256(abi.encodePacked(nonce, to, value ,data));
        uint8 approvals;
        approvals += _voters[hash.recover(sig1)];
        approvals += _voters[hash.recover(sig2)];
        approvals += _voters[hash.recover(sig3)];
        if (approvals >= _required){
            (success,) = to.call{value: value}(data);
        }
        nonce++;
    }
    



}