pragma solidity ^0.6.6;

interface GasToken2 {
    function mint(uint256 value) external;
    function transfer(address to, uint256 value) external returns (bool success);
    function balanceOf(address owner) external view returns (uint256 balance);
}

contract EatGas {
    address public owner;
    
    GasToken2 gasToken;
    
    bool public mintGasEnabled = false;
    uint public mintGasTokens = 0;
    
    modifier onlyOwner() {
        require(owner == msg.sender, "Nuh-uh-uh! Tricky tricky!");
        _;
    }
    
    constructor(GasToken2 _gasToken) public {
        // Set the gas token contract
        gasToken = _gasToken;
        
        // Set the owner
        owner = msg.sender;
    }
    
    // When it receives some funds, it mints some tokens
    fallback() external payable {
        if (mintGasEnabled) {
            gasToken.mint(mintGasTokens);
        }
    } 
    
    // Transfer the minted gas tokens
    function transferGas(address _recipient, uint _value) public onlyOwner {
        gasToken.transfer(_recipient, _value);
    } 
    
    // Configure how many tokens to mint
    function configureMint(bool _mintGasEnabled, uint _mintGasTokens) public onlyOwner {
        mintGasEnabled = _mintGasEnabled;
        mintGasTokens = _mintGasTokens;
    }
    
    // Transfer ether out of the contract
    function transferEther(address payable _recipient, uint _value) public onlyOwner {
        _recipient.transfer(_value);
    }
    
    // Return how much ether is in the contract
    function etherBalance() public view returns (uint) {
        address payable self = address(this);
        return self.balance;
    }
    
    // Return how many tokens the contract has
    function gasBalance() public view returns (uint) {
        return gasToken.balanceOf(address(this));
    }
}