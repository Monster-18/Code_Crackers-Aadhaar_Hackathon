import 'package:aadhaar_address_update/helper/functions.dart';
import 'package:aadhaar_address_update/screens/home.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:aadhaar_address_update/api/handler.dart';
import 'package:aadhaar_address_update/api/models/otpModel.dart';
import 'package:aadhaar_address_update/api/models/ekycModel.dart';

import 'package:aadhaar_address_update/models/ProfileModel.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Model
  late OTPModel otp;
  late EKYCModel ekyc;

  //loading
  bool isLoading = false;

  //Text Controller
  TextEditingController aadharNumberController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();

  //otp generated
  bool isOtpGenerated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
        centerTitle: true,
      ),
      body: Container(
        decoration: background(),
        child: (isLoading)?
        Center(child: CircularProgressIndicator()):
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(),
              ),
              TextField(
                controller: aadharNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Aadhar Number',
                  helperText: 'Don\'t leave any space between digits',
                  helperStyle: TextStyle(
                      color: Colors.green
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextButton(
                  onPressed: () async{
                    print(aadharNumberController.text);
                    if(aadharNumberController.text.trim().length == 12){
                      setState(() {
                        isLoading = true;
                      });

                      otp = new OTPModel(uid: aadharNumberController.text);
                      otp.generateUUID();
                      // print(otp.txnId);
                      // bool res = true;
                      bool res = await APIHandler.getOTP(otp);

                      setState(() {
                        isLoading = false;
                      });

                      if(res){
                        setState(() {
                          isOtpGenerated = true;
                        });
                      }else{
                        print('Invalid data');
                        Fluttertoast.showToast(msg: 'Invalid Aadhar Number');
                      }
                    }else{
                      print('Invalid Aadhar Number');
                      Fluttertoast.showToast(msg: 'Invalid Aadhar Number');
                    }

                  },
                  child: Container(
                      width: 200,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            //Background Shadow
                            BoxShadow(
                              offset: Offset(0.0, 0.0),
                              color: Colors.white,
                            ),
                            BoxShadow(
                                offset: Offset(3.0, 3.0),
                                color: Colors.black26
                            )
                          ]
                      ),
                      child: const Center(
                          child: Text(
                              'Genterate OTP',
                              style: TextStyle(
                                  color: Colors.white
                              )
                          )
                      )
                  )
              ),

              //OTP Details
              SizedBox(
                height: 20.0,
              ),
              (isOtpGenerated)? TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'OTP Number',
                    border: OutlineInputBorder()
                ),
              ): Expanded(
                child: Container(),
              ),
              SizedBox(
                height: 20.0,
              ),
              (isOtpGenerated)? TextButton(
                  onPressed: () async{
                    if(otpController.text.trim().length == 6){
                      print(otpController.text);

                      setState(() {
                        isLoading = true;
                      });

                      ekyc = new EKYCModel(otp_data: otp, otp_number: otpController.text);
                      Profile profile = await APIHandler.getUserInfo(ekyc);

                      setState(() {
                        isLoading = false;
                      });

                      if(profile.gotData){

                        // Navigator.pushReplacementNamed(context, '/home');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage(profile: profile))
                        );
                      }else{
                        print('Invalid Otp value');
                        Fluttertoast.showToast(msg: 'Invalid Otp value');
                      }

                    }else{
                      print('Invalid OTP');
                      Fluttertoast.showToast(msg: 'Invalid Otp value');
                    }
                  },
                  child: Container(
                      width: 150,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            //Background Shadow
                            BoxShadow(
                              offset: Offset(0.0, 0.0),
                              color: Colors.white,
                            ),
                            BoxShadow(
                                offset: Offset(3.0, 3.0),
                                color: Colors.black26
                            )
                          ]
                      ),
                      child: const Center(
                          child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white
                              )
                          )
                      )
                  )
              ): Expanded(
                child: Container(),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
