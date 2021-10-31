import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'package:aadhaar_address_update/api/models/otpModel.dart';
import 'package:aadhaar_address_update/api/models/ekycModel.dart';

import 'package:aadhaar_address_update/models/ProfileModel.dart';
import 'package:aadhaar_address_update/models/AddressModel.dart';

class APIHandler{
    //For Getting OTP
    static Future<bool> getOTP(OTPModel otp) async{
      String url = "https://stage1.uidai.gov.in/onlineekyc/getOtp/";

      var jsonBody = jsonEncode(otp.toJson());

      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonBody
      );

      var resJson = json.decode(response.body);
      if(resJson['status'] == 'y' || resJson['status'] == 'Y'){
        return true;
      }else{
        return false;
      }
    }

    //For validating User and Getting their info
    static Future<Profile> getUserInfo(EKYCModel ekyc) async{
      String url = "https://stage1.uidai.gov.in/onlineekyc/getEkyc/";

      var jsonBody = jsonEncode(ekyc.toJson());

      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody
      );

      var resJson = jsonDecode(response.body);
      if(resJson['status'] == 'y' || resJson['status'] == 'Y'){
        XmlDocument xml = XmlDocument.parse(resJson['eKycString']);

        //Address
        Address address = new Address(
            co: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poa")!.getAttributeNode("co")!.value,
            house: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poa")!.getAttributeNode("house")!.value,
            street: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poa")!.getAttributeNode("street")!.value,
            lm: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poa")!.getAttributeNode("lm")!.value,
            loc: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poa")!.getAttributeNode("loc")!.value,
            country: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poa")!.getAttributeNode("country")!.value,
            vtc: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poa")!.getAttributeNode("vtc")!.value,
            dist: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poa")!.getAttributeNode("dist")!.value,
            state: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poa")!.getAttributeNode("state")!.value,
            pc: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poa")!.getAttributeNode("pc")!.value
        );

        Profile profile = new Profile(
            gotData: true,
            name: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poi")!.getAttributeNode("name")!.value,
            dob: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poi")!.getAttributeNode("dob")!.value,
            gender: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poi")!.getAttributeNode("gender")!.value,
            phone: xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poi")!.getAttributeNode("phone")!.value,
            address: address
        );

        // String name = xml.getElement("KycRes")!.getElement("UidData")!.getElement("Poi")!.getAttributeNode("name")!.value;
        // print("Name: $name");
        return profile;
      }else{
        Address address = new Address(co: '', house: '', street: '', lm: '', loc: '', country: '', vtc: '', dist: '', state: '', pc: '');

        Profile profile = new Profile(gotData: false, name: '', dob: '', gender: '', phone: '', address: address);

        return profile;
      }

    }
}