pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
contract tasks {
    // Contract can have an instance variables.
    // In this example instance variable `timestamp` is used to store the time of `constructor` or `touch`
    // function call
    

    struct item {
        string name;
        uint32 createtime;
        bool iscomlete;
    }

    mapping (uint8 => item) public items;
    uint8 public itemsCount = 0;

 

    // Contract can have a `constructor` – function that will be called when contract will be deployed to the blockchain.
    // In this example constructor adds current time to the instance variable.
    // All contracts need call tvm.accept(); for succeeded deploy
    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction. This actions required to process external
        // messages, which bring no value (henceno gas) with themselves.
        tvm.accept();
        
    }




    function AddTask (string name) public returns (uint8) {
       itemsCount++; 
       items[itemsCount-1] = item(name, now, false);
       return itemsCount;
    }

    function GetOpenTasksCount () public returns (uint8) {
        uint8 i;
        uint8 j = 0;
        for (i=0; i<itemsCount; i++) {
            if (!items[i].iscomlete) j++;
        }
       return j;
    }

    function GetTaskName (uint8 i) public returns (string) {
       return items[i].name;
    }

    function SetTaskDone (uint8 i) public {
       items[i].iscomlete=true; 
    }

    function DeleteTask (uint8 j) public {
       for (uint8 i=j; i<itemsCount-1;i++) items[i]=items[i+1];
       itemsCount--;
    }

    function GetTasks () public returns (string) {
       string s;
       for (uint8 i=0; i<itemsCount;i++) {
           s=s+"Task: "+items[i].name;
           if (items[i].iscomlete) {
               s=s+", status: completed\n";
               } else {
                   s=s+", status: in progress\n";}
       }    
    }    
}
