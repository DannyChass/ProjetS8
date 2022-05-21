// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Mileage{

    uint hashDigits=32;
    uint hashModulus = 10**hashDigits;

    struct MileageEntry{
        uint mileageInMeters;
        uint timestamp;
    }

    mapping(bytes32 => MileageEntry[]) public mileageEntries;
    mapping(bytes32 => address) public mappedVinToKeyEntries;
    address owner;

    function MileageSender() public {
        owner = msg.sender;
    }

    function mapVinToPublicKey(bytes32 hashedVin, address publicKey) public {
        require(mappedVinToKeyEntries[hashedVin]==address(0x0));
        //if not mapping exist set mapping
        if (mappedVinToKeyEntries[hashedVin]==address(0x0)){
            mappedVinToKeyEntries[hashedVin]=publicKey;
        }
    }


    function storeMileage(uint inputMileage, uint inputTimestamp, bytes32 vin) public{
        address vehicleIdentity = msg.sender;
        mileageEntries[vin].push(MileageEntry({
            mileageInMeters:inputMileage, timestamp:inputTimestamp
            }));
    }

    function countEntriesOfAdress(bytes32 vin) public  view returns (uint counter){
        counter = mileageEntries[vin].length;
        return counter;
    }
    
    function getValueKM(bytes32 vin, uint index) public view returns (uint value) {
        value = mileageEntries[vin][index].mileageInMeters;
        return value;
    }

    function getValueTime(bytes32 vin, uint index) public view returns (uint time) {
        time = mileageEntries[vin][index].timestamp;
        return time;
    }

    function resetVinMapping(bytes32 hashedVin) public {
        require(owner==msg.sender);
        mappedVinToKeyEntries[hashedVin]= address(0x0);
    }


    function resetEntriesForPublicKey(bytes32 vin) public{
        require(mileageEntries[vin].length != 0);
        delete mileageEntries[vin];
    }

    //Convert a string to a uint
    function st2num(string memory numString) public pure returns(uint val) {

        bytes   memory stringBytes = bytes(numString);
        for (uint  i =  0; i<stringBytes.length; i++) {
            uint exp = stringBytes.length - i;
            bytes1 ival = stringBytes[i];
            uint8 uval = uint8(ival);
           uint jval = uval - uint(0x30);
   
           val +=  (uint(jval) * (10**(exp-1)));
        }
      return val;
    }

    //Hash a string to a bytes32
    function getSha256(string memory str) public pure returns (bytes32) {

        bytes32 hash = sha256(abi.encodePacked(str));
        return hash;
        //string y    = hash;
        }
     
}
