// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Mileage{

    uint hashDigits=32;
    uint hashModulus = 10**hashDigits;

    struct MileageEntry{
        uint mileageInMeters;
        uint timestamp;
    }

    mapping(address => MileageEntry[]) public mileageEntries;
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


    function storeMileage(uint inputMileage, uint inputTimestamp) public{
        address vehicleIdentity = msg.sender;
        mileageEntries[vehicleIdentity].push(MileageEntry({
            mileageInMeters:inputMileage, timestamp:inputTimestamp
            }));
    }

    function countEntriesOfAdress(address vehiculeIdentity) public view returns (uint counter){
        counter = mileageEntries[vehiculeIdentity].length;
        return counter;
    }

    function resetVinMapping(bytes32 hashedVin) public {
        require(owner==msg.sender);
        mappedVinToKeyEntries[hashedVin]= address(0x0);
    }

    function resetEntriesForPublicKey(address publicKey) public{
        require(mileageEntries[publicKey].length != 0);
        delete mileageEntries[publicKey];
    }

    function getSha256(string memory str) public pure returns (bytes32) {

        bytes32 hash = sha256(abi.encodePacked(str));
        return hash;
        //string y    = hash;
        }
}