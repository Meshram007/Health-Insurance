//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Health_Insurance {
    // address of the owner who can enter the data of peoples
    address owner;
    // define the name, uid generated or not and amount Insurance
    
    struct people {
        uint amount_insuranced;
        bool is_uid_generated;
        string name;
      }
    
    //mapping is use o set the people data and to set the doctor
    mapping (address => bool) public doctor_mapping;
    mapping (address => people) public people_mapping;
    
    //owner address should be define
    constructor() {
       owner = msg.sender;
     }
    
    //Set the modifier to the function, so function only called by modifier
    modifier only_owner {
        require(owner == msg.sender);
        _;
     }

    
    //define the function to set doctor and check it is true or not
    function set_doctor(address _address) public only_owner {
        require(!doctor_mapping[_address]);
        doctor_mapping[_address] = true;
      }
    
    
    //now set the data of the people
    function set_people_data(string memory _name, uint _amountInsuranced) only_owner public returns(address) {
        address unique_id = address(msg.sender);
        require(!people_mapping[unique_id].is_uid_generated);
        // check the people unique it of
        people_mapping[unique_id].is_uid_generated = true;
        people_mapping[unique_id].name = _name;
        people_mapping[unique_id].amount_insuranced = _amountInsuranced;
        return unique_id;
      }
    
    
    //set the functon for used insurance with the amount used
    function use_insurance(address _uniqueid, uint _amountUsed) public returns (string memory) {
        require(doctor_mapping[msg.sender]);
        // amount should be lesser than amount issued
        if(people_mapping[_uniqueid].amount_insuranced < _amountUsed){
            revert();
          }
        //then reduce the amount used from amount issued
        people_mapping[_uniqueid].amount_insuranced -= _amountUsed ;
        return "Insurance has been Successfully Used";
     }
 }