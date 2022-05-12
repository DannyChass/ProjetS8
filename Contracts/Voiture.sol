// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Voiture{
    bool start;
    uint mileageInKm;
    uint datstart;
    uint datstop;

    function getStart() public view returns (bool){
        return start;
    }

    function setStart(bool _start) public{
        start=_start;
    }

    function getMileageInKm() public view returns(uint){
        return mileageInKm;
    }

    function setMileageInKm(uint _mileageInKm) public{
        mileageInKm = _mileageInKm;
    }

    function getDatstart() public view returns (uint){
        return datstart;
    }

    function setDatstart(uint _datstart) public{
        datstart=_datstart;
    }

    function getDatstop() public view returns (uint){
        return datstop;
    }

    function setDatstop(uint _datstop) public{
        datstop=_datstop;
    }
}
