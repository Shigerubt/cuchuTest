// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserRegistry {
    struct User {
        address wallet;
        string nickname;
        bool isRegistered;
    }

    //testing

    mapping(address => User) public users;

    event UserRegistered(address indexed wallet, string nickname);

   function registerUser(string memory nickname) public {
        require(!users[msg.sender].isRegistered, "User already registered.");

        users[msg.sender] = User(msg.sender, nickname, true);

        emit UserRegistered(msg.sender, nickname);
    }

    function updateNickname(string memory newNickname) public {
        require(!users[msg.sender].isRegistered, "No estas registrado");

        users[msg.sender].nickname = newNickname;
    }

    function isUserRegistered(address _wallet) public view returns (bool) {
        return users[_wallet].isRegistered;
    }
}
