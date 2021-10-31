import 'package:aadhaar_address_update/models/AddressModel.dart';

class Profile{
  bool gotData;

  //User Info
  String name;
  String dob;
  String gender;
  String phone;

  Address address;

  Profile({required this.gotData, required this.name, required this.dob, required this.gender, required this.phone, required this.address});
}
