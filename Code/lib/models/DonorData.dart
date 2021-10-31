import 'package:aadhaar_address_update/models/AddressModel.dart';

class Donor{
  String phone;
  bool accepted;
  Address address;

  Donor({required this.phone, required this.accepted, required this.address});
}