import 'package:uuid/uuid.dart';

class OTPModel{
  String uid;
  String txnId = "1acbaa8b-b3ae-433d-a5d2-51250ea8e970";

  OTPModel({required this.uid});

  Map<String, String> toJson(){
    return {
      'uid': uid,
      'txnId': txnId
    };
  }

  void generateUUID(){
    var uuid = Uuid();

    txnId = uuid.v4();
  }
}