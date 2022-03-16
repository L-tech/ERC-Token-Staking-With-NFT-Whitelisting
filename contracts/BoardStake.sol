//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "hardhat/console.sol";

contract BoardStake {
	IERC721 public _BoredApeNFT;

	struct stakes {
		uint amount;
		uint stakeTime;
		uint interestPerDay;
	}

	mapping(address => stakers) claims;
	uint public minAmount = 100;

	constructor(){
		_BoredApeNFT = IERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
	}

	function stake(uint _amount, IERC20 token) public returns (bool) {
		require(_amount > minAmount, "Minimum 100 tokens");
		uint256 tokenBalance = token.balanceOf(msg.sender);
		require(tokenBalance>= _amount, "Insufficient token");
		require(_BoredApeNFT.balanceOf(msg.sender) > 0, "Only board apes holders" );
		bool transferred = token.transferFrom(msg.sender, address(this), _amount);
		require(transferred, "Token Transfer Failed");
		claims memory claim;
		claim.amount = _amount;
		claim.stakeTime = block.timestamp;
		user.interestPerDay = (_amount * 10 / 100) / 30;
		claims[msg.sender] = user;
		return true;
	}

	function withdraw() public returns (bool) {
		require(claims[msg.sender].amount > 0, " You need to stake to withdraw");
		stakers memory user = claims[msg.sender];
		uint validity = (user.stakeTime - block.timestamp) / 60 / 60 / 24;
		if (validity >= 3) {
			uint interests = validity * user.interestPerDay;
			uint total = interests + user.amount;
			token.transfer(msg.sender, user.total);
		}
		else {
			token.transfer(msg.sender, user.amount);
		}
		return true;
	}
}
