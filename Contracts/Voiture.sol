contract Voiture{
    address owner;
    bool start;
    uint mileageInKm;
    uint datStart;
    uint datStop;
    uint timeDifference;

    address addressMileage;

    constructor(uint _mileageInKm, uint _datStart, uint _datStop) public{
        owner = msg.sender;
        start=false;
        mileageInKm = _mileageInKm;
        datStart = _datStart;
        datStop = _datStop;
    }

    function setAdressMileage(address _addressMileage) external{
        addressMileage = _addressMileage;
    }

    function appelStoreMileage(uint _inputMileage, uint _inputTimeStamp) public{
        Mileage mileage = Mileage(addressMileage);
        mileage.storeMileage(_inputMileage,_inputTimeStamp);
    }

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

    function getDatStart() public view returns (uint){
        return datStart;
    }

    function setDatStart(uint _datStart) public{
        datStart=_datStart;
    }

    function getDatStop() public view returns (uint){
        return datStop;
    }

    function setDatStop(uint _datStop) public{
        datStop=_datStop;
    }

    //Simulate the drive of the car during time in seconde and speed is in km/s
    function drive(uint time, uint speed) public {
        uint mileageDone;

        setDatStart(now);
        setDatStop(now + time);

        for(uint i=0;i<time;i++){
            mileageDone+=speed;
        }

        setMileageInKm(getMileageInKm()+mileageDone);
        //appelStoreMileage(getMileageInKm(),getDatStop());

    }

    function stop() public{
        require(start==true);
        setStart(false);   
    }
}
