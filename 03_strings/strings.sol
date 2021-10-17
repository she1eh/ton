pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract strings {

	// State variable storing the multiplicator
	uint public first = 0;
    string[] names = ["Vladimir", "Anatoliy", "Inokhentiy", "Vasiliy"];



	constructor() public {
		// check that contract's public key is set
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	// Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}


    function int2str(uint256 _i) internal pure returns (string str) {
        if (_i == 0) {return "0";}
        uint256 j = _i;  
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        byte[] bstr; //= new bytes1(length);
        
        uint256 k = length;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        str = string(bstr);
    }

	// Function that adds its argument to the state variable.
	function AddOne(string str) public checkOwnerAndAccept returns(string) {
        names.push(str);
        return "Customer " + str + " was append." + int2str(names.length-first+1) + " clients left";
	}

	function CallNext() public checkOwnerAndAccept returns(string) {
        string mess = "Customer " + names[first] + " with N"+int2str(first)+" was served. ";
        mess = mess + int2str(names.length-first+1) + " clients left";
        names[first]='';
        first++; 
        return mess;       
	}



}
