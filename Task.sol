// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "ERC20.sol";

contract SlabContract {
    struct Slab {
        uint256 capacity;
        uint256 count;
    }

    mapping (uint256 => Slab) public slabs;

    constructor() {
        slabs[0] = Slab(100, 0);
        slabs[1] = Slab(200, 0);
        slabs[2] = Slab(300, 0);
        slabs[3] = Slab(400, 0);
        slabs[4] = Slab(500, 0);
    }

    function addCountToSlab(uint256 slabIndex, uint256 countToAdd) internal {
        require(slabIndex >= 0 && slabIndex <= 4, "Invalid slab index");
        require(slabs[slabIndex].count + countToAdd <= slabs[slabIndex].capacity, "Slab capacity exceeded");
        slabs[slabIndex].count += countToAdd;
    }

    function deposit(address _erc20token, uint256 value) public {
    IERC20 tokenContract = IERC20(_erc20token);

    // Call the approve function on the token contract instance
    bool success = tokenContract.approve(address(this), value);
    require(success, "TokenSlabs/deposit/[ERC20]allowance: Approve failed");

    // Check that the allowance is sufficient
    uint256 allowance = tokenContract.allowance(msg.sender, address(this));
    require(allowance >= value, "TokenSlabs/deposit/[ERC20]allowance: Not enough allowance, approve before spending");

    // Transfer the tokens to this contract
    bool transferSuccess = tokenContract.transferFrom(msg.sender, address(this), value);
    require(transferSuccess, "TokenSlabs/deposit/[ERC20]transfer: Transfer failed");
    uint256 slabIndex = 4;
        while (slabIndex > 0 && slabs[slabIndex].count + value > slabs[slabIndex].capacity) {
            slabIndex--;
        }
     addCountToSlab(slabIndex, value);
    }

    function getDepositSlab(address senderAddress, uint256 amount) public view returns (uint256) {
    uint256 totalCapacity = slabs[0].capacity + slabs[1].capacity + slabs[2].capacity + slabs[3].capacity + slabs[4].capacity;
    require(amount <= totalCapacity, "Amount exceeds total capacity of all slabs");

    uint256 slabIndex = 4;
    while (slabIndex > 0 && slabs[slabIndex].count + amount > slabs[slabIndex].capacity) {
        slabIndex--;  
    }
    return slabIndex;
}

}