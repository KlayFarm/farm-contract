pragma solidity 0.5.6;

interface IKIP7 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract BeeTeamWallet {
    uint public release = 1621310400; // 2021 05 18 / 13:00 / KST
    address[] public addrs;
	address public beeToken;
    constructor(address _beeToken, address[] memory _addrs) public {
		beeToken = _beeToken;
        addrs = _addrs;
    }

    function info() public view returns (uint, uint, uint, address[] memory) {
        return (now, release, addrs.length, addrs);
    }

    function distribute(address token) public {
        require(now > release);

        uint i;
        uint balance = 0;
        uint len = addrs.length;
        if(token != address(0)){
            balance = IKIP7(token).balanceOf(address(this));

            for(i = 0; i < len; i++){
                IKIP7(token).transfer(addrs[i], balance / len);
            }
        }
        else{
            balance = (address(this)).balance;

            for(i = 0; i < len; i++){
                addrs[i].call.value(balance / len)("");
            }
        }
    }

    function () external payable {
		distribute(beeToken);
		distribute(address(0));
	}
}

