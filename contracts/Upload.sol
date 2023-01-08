// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Upload {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct Access {
        address user;
        bool access;
    }
    mapping(address => string[]) public value;
    mapping(address => mapping(address => bool)) public ownership;
    mapping(address => Access[]) public accessList;
    mapping(address => mapping(address => bool)) public previousData;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "only owner has the authority to allow access"
        );
        _;
    }

    function add(address _user, string calldata url) external {
        value[_user].push(url);
    }

    function allow(address user) external onlyOwner {
        ownership[msg.sender][user] = true;
        if (previousData[msg.sender][user]) {
            for (uint i; i < accessList[msg.sender].length; i++) {
                if (
                    accessList[msg.sender][i].user == user &&
                    accessList[msg.sender][i].access == false
                ) {
                    accessList[msg.sender][i].access = true;
                }
            }
        } else {
            accessList[msg.sender].push(Access(user, true));
            previousData[msg.sender][user] = true;
        }
    }

    function disallow(address user) external onlyOwner {
        for (uint i; i < accessList[msg.sender].length; i++) {
            if (accessList[msg.sender][i].user == user) {
                accessList[msg.sender][i].access = false;
            }
        }
    }

    function display(address _user) external view returns (string[] memory) {
        require(
            msg.sender == _user || ownership[_user][msg.sender],
            "you don't have access"
        );
        return value[_user];
    }

    function shareAccess() public view returns (Access[] memory) {
        return accessList[msg.sender];
    }
}
