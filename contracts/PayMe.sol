pragma solidity ^0.4.11;

  /***
  * Created by Andrew Coutts
  * 2017
  *
  * A simple contract to receive deposits for me which allows me
  * to withdraw them to an address of my choosing.
  */

contract PayMe {
  event depositReceived(address indexed _from, uint256 indexed _amount, string _type);
  event withdrawal(address indexed _to, uint256 indexed _amount);
  public address currentPayoutAddress;
  address owner;

  //~ Constructor method, initialize owner as contract creator
  //~ and set initial payout address to the owner.
  function PayMe(address) {
    owner = msg.sender;
    currentPayoutAddress = owner;
  }

  //~ Withdraw funds from the contract
  function withdrawFunds(uint256 _amount, bool _useMax) {
    require(msg.sender == owner);

    if (_useMax == true) {
      currentPayoutAddress.transfer(this.balance);
    }

    currentPayoutAddress.transfer(_amount);
    withdrawal(msg.sender, _amount);
  }

  //~ Change the payout address
  function changePayoutAddress(address _newPayoutAddress) {
    require(msg.sender == owner);

    currentPayoutAddress = _newPayoutAddress;
  }

  //~ Deposit from web front end
  function webDeposit(string _senderName) payable {
    depositReceived(msg.sender, msg.value, "web");
  }

  //~ Default deposit function
  function() payable {
    depositReceived(msg.sender, msg.value, "internal");
  }

}
