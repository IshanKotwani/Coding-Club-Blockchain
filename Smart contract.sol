// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Loan {
    address public borrower = msg.sender;
    address public lender;
    ERC20 public token;
    uint256 public collateralAmount = 10; //Collateral amount is in USDT
    uint256 public loanAmount = 5; //Loan amount is specified in ether
    uint256 public interestRate = 8;
    uint256 public loanDuration = 7; //loan duration is specified in years
    uint public payoffAmount = loanAmount*((1+((interestRate)/100))^loanDuration);
    uint public dueDate = block.timestamp + loanDuration;

    Loan public loan;


    function Loan_request() public payable {
        require(msg.value == collateralAmount);
        
        require(collateralAmount >= loanAmount, "Collateral amount needs to be greater than the amount to be borrowed");
        require(token.transferFrom(borrower, lender, collateralAmount));
        require(msg.value == loanAmount);
        require(token.transferFrom(lender, borrower, loanAmount));
        event LoanRequestAccepted();
        emit LoanRequestAccepted();


    }

   


    function payLoan() public payable {
        require(block.timestamp <= dueDate, "Sorry, the deadline has passed and your collateral has been seized by the lender.");
        require(msg.value == payoffAmount);

        require(token.transferFrom(borrower, lender, payoffAmount));
        require(msg.value == collateralAmount);
        require(token.transferFrom(lender, borrower, collateralAmount));

        event LoanPaid();
        emit LoanPaid(); //used to log the transaction on the blockchain

    }
    
}
