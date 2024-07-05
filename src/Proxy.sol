// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

contract Proxy {
    uint256 public number;
    address public target;

    constructor(address _target) {
        target = _target;
    }

    fallback() external {
        (bool success, bytes memory returndata) = target.delegatecall(msg.data);
        require(
            success,
            string(abi.encodePacked("Delegatecall failed: ", returndata))
        );
    }
}

contract Implementation {
    uint256 public number;

    function addNum(uint256 _num) external {
        number += _num;
    }
}
