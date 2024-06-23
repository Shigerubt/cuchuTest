// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserRegistry {
    struct User {
        address wallet;
        string nickname;
        bool isRegistered;
        
    }

    mapping(address => User) public users;

    event UserRegistered(address indexed wallet);

    function registerUser() public {
        require(!users[msg.sender].isRegistered, "Ya estas registrado");

        users[msg.sender] = User({
            wallet: msg.sender,
            nickname: "", // Cual es tu nickname?
            isRegistered: true
        });

        emit UserRegistered(msg.sender);
    }

     function updateNickname(string memory newNickname) public {
        require(!users[msg.sender].isRegistered, "No estas registrado");

        users[msg.sender].nickname = newNickname;
    }

    function isUserRegistered(address _wallet) public view returns (bool) {
        return users[_wallet].isRegistered;
    }

}
