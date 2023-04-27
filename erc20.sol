// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0; 

interface ERC20Swapper {
    function balanceOf(address tokenOwner) external view returns(uint balance);
    event Transfer(address indexed from, address indexed to, uint tokens);

}

contract Block is ERC20Swapper{ string public name = "Block";
// name of the token string public symbol = "KVB";

uint public totalSupply;
address public contractOwner;
// made balances private so not easily accessible and only the address's balance can be seen of whom you know the address
mapping(address=>uint) private balances;
mapping(address=>mapping(address=>uint)) allowed;

constructor(){
    totalSupply = 100000;
    contractOwner = msg.sender;
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
    return true;
}

}

contract DEX {

    ERC20Swapper public token;

    event Bought(uint256 amount);
    event Sold(uint256 amount);

    constructor() {
        token = new Block();
    }

    function buy() payable public {
    uint256 amountTobuy = msg.value;
    uint256 dexBalance = token.balanceOf(address(this));
    require(amountTobuy > 0, "You need to send some ether");
    require(amountTobuy <= dexBalance, "Not enough tokens in the reserve");
    address(this).transfer(msg.sender, amountTobuy);
    emit Bought(amountTobuy);
}


    function sell(uint256 amount) public {
        // TODO
    }

}
