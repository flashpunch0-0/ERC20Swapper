// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0; // ---------------------------------------------------------------------------- // EIP-20: ERC-20 Token Standard // https://eips.ethereum.org/EIPS/eip-20 // -----------------------------------------

interface ERC20Swapper { 
// function declaring
    function totalSupply() external view returns (uint); 
    function balanceOf(address tokenOwner) external view returns (uint balance); 
    function transfer(address to, uint tokens) external returns (bool success);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
// declaring events
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Block is ERC20Swapper { 
    string name="Block"; // no need to make it public
    string public constant symbol = "KVB";
    uint8 constant decimals = 2;  //no need to make decimals public
    uint public override totalSupply;
    address private contractOwner;
    mapping(address=>uint) private balances;//made balances private for security
    mapping(address=>mapping(address=>uint)) allowed; //used to mapped the addresses which have been approved with a limit of tokens to buy
    uint256 public unitsOneEthCanBuy  = 10; // how much can 1 ether buy

    constructor(uint256 total) {
        // here i have already declared 100000 is total supply
        totalSupply=total;
        contractOwner=msg.sender;
        // msg.sender = address which deploys and owns contract
        balances[contractOwner]=totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns(uint balance){
        return balances[tokenOwner];
    }

    function transfer(address to,uint tokens) public override returns(bool success){
        require(balances[msg.sender]>=tokens);
        balances[to]+=tokens; //balances[to]=balances[to]+tokens;
        balances[msg.sender]-=tokens;
        emit Transfer(msg.sender,to,tokens);
        totalSupply = balances[contractOwner];
        return true;
    }

    function approve(address spender,uint tokens) public override returns(bool success){
        require(balances[msg.sender]>=tokens);
        require(tokens>0);
        allowed[msg.sender][spender]=tokens;
        emit Approval(msg.sender,spender,tokens);
        return true;
    }

    function allowance(address tokenOwner,address spender) public view override returns(uint noOfTokens){
        return allowed[tokenOwner][spender];
        // used to check how much tokens are allowed to buy
    }

    function transferFrom(address from,address to,uint tokens) public override returns(bool success){
        require(allowed[from][to]>=tokens);
        require(balances[from]>=tokens);
        balances[from]-=tokens;
        balances[to]+=tokens;
        return true;
    }

    function sendmoneytocontract() public payable{
        uint256 amount = msg.value*unitsOneEthCanBuy;
        require(balanceOf(contractOwner)>=amount,"Not enough tokens");
        transferFrom(contractOwner,msg.sender,amount);
        emit Transfer(contractOwner,msg.sender,amount);
        payable(contractOwner).transfer(msg.value);
    }
}
