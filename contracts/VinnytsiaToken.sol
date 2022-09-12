// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./IERC20.sol";
import "./IterableMapping.sol";

contract VinnytsiaToken is IERC20 {
    using IterableMapping for IterableMapping.Map;

    uint256 public totalSupply;

    IterableMapping.Map private balances;
    mapping(address => uint256) private dividends;

    mapping(address => mapping(address => uint)) public allowance;

    string public name = "VinnytsiaToken";
    string public symbol = "VT";
    uint8 public decimals = 18;

    address private owner;

    uint256 private deployTimeStamp = block.timestamp;
    uint256 private timeToBurn = deployTimeStamp + 5 minutes;

    event Received(address, uint);

    constructor() {
        owner = msg.sender;
        totalSupply = 1000 ether;
        balances.set(owner, totalSupply);
    }

    modifier canBeBurned() {
        require(block.timestamp >= timeToBurn, "Token cannot be burned yet!");
        _;
    }

    function balanceOf(address _address) external view returns (uint256) {
        return balances.get(_address);
    }

    function myBalance() external view returns (uint256) {
        return balances.get(msg.sender);
    }

    function getOneToken() external returns (bool) {
        totalSupply += 1 ether;
        balances.set(msg.sender, balances.get(msg.sender) + 1 ether);

        emit Transfer(address(0), msg.sender, 1 ether);

        return true;
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        balances.set(msg.sender, balances.get(msg.sender) - amount);
        balances.set(recipient, balances.get(recipient) + amount);

        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balances.set(sender, balances.get(sender) - amount);
        balances.set(recipient, balances.get(recipient) + amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function burn(uint256 amount) external canBeBurned {
        balances.set(msg.sender, balances.get(msg.sender) - amount);

        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);

        uint256 balancesLength = balances.size();

        for (uint256 i = 0; i < balancesLength; i++) {
            address currentAddress = balances.getKeyAtIndex(i);
            uint256 currentValue = balances.get(currentAddress);
            if (currentValue > 0) {
                dividends[currentAddress] +=
                    (msg.value * currentValue) /
                    totalSupply;
            }
        }
    }

    function getMyDividends() external {
        uint256 currentDividends = dividends[msg.sender];
        if (currentDividends > 0) {
            payable(msg.sender).transfer(currentDividends);
            dividends[msg.sender] = 0;
        }
    }
}
