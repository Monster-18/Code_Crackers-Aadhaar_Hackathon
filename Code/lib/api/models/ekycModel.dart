import 'package:aadhaar_address_update/api/models/otpModel.dart';

class EKYCModel{
  OTPModel otp_data;
  String otp_number;

  EKYCModel({required this.otp_data, required this.otp_number});

  Map<String, String> toJson(){
    return {
      'uid': otp_data.uid,
      'txnId': otp_data.txnId,
      'otp': otp_number
    };
  }
}