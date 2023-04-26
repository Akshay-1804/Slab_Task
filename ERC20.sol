// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "IERC20.sol";


contract ERC20 is  IERC20 {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply = 2100000;

    constructor() {
    
        _balances[msg.sender] = _totalSupply;
    }


    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }


    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

}