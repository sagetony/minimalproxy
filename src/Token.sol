//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

contract Token {
    address public owner;
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public totalSupply;
    bool public initialized;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) allowed;

    // Events
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    // modifiers
    modifier Onlyadmin() {
        require(msg.sender == owner, "Only Admin has permission");
        _;
    }
    modifier validAddress(address _address) {
        require(_address != address(0));
        _;
    }
    modifier notInitialized() {
        require(!initialized, "Already initialized");
        _;
    }

    function initialize() external notInitialized {
        owner = msg.sender;
        name = "SAGE";
        symbol = "NSAG";
        decimals = 10;
        totalSupply = 10000000 * 10 ** 18;
        balances[owner] = totalSupply;
    }

    // functions
    function balanceOf(address tokenAddress) public view returns (uint256) {
        return balances[tokenAddress];
    }

    function transfer(
        address to,
        uint256 tokens
    ) public validAddress(to) returns (bool) {
        require(balances[msg.sender] >= tokens, "Insufficient Token Amount");
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function allowance(
        address _owner,
        address spender
    ) public view validAddress(spender) returns (uint256) {
        return allowed[_owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public validAddress(spender) returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient Token");
        allowed[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public validAddress(to) returns (bool) {
        require(allowed[from][msg.sender] >= amount, "Insufficient Amount");
        require(balances[from] >= amount, "Insufficient Token Amount");

        balances[from] -= amount;
        allowed[from][msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }
}

contract Proxy {
    function clone(
        address implementation,
        bytes memory initData
    ) external returns (address instance) {
        bytes20 targetBytes = bytes20(implementation);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf3)
            // instance := create(0, clone, 0x37)
        }
        // require(instance != address(0), "ERC1167: create failed");

        // // Call the initializer function on the new instance
        // (bool success, ) = instance.call(initData);
        // require(success, "Initialization failed");
    }
}
