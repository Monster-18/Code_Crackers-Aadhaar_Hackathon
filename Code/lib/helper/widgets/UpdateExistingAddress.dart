// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aadhaar_address_update/helper/functions.dart';

import 'package:aadhaar_address_update/models/DonorData.dart';
import 'package:aadhaar_address_update/models/AddressModel.dart';

import 'package:aadhaar_address_update/services/firebase/crud.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Update extends StatefulWidget {
  String phone;
  Donor donor;
  VoidCallback callback;

  Update({required this.phone, required this.donor, required this.callback});

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  bool useAddress = false;

  bool updateSuccess = false;

  //Text Editing Controllers
  TextEditingController coController = new TextEditingController();
  TextEditingController houseController = new TextEditingController();
  TextEditingController streetController = new TextEditingController();
  TextEditingController lmController = new TextEditingController();
  TextEditingController locController = new TextEditingController();
  TextEditingController vtcController = new TextEditingController();
  TextEditingController distController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController pcController = new TextEditingController();

  Future<void> showAlert(BuildContext context, bool flag){

    Text success = new Text('Your address updated successfully');
    Text failure = new Text('Your address doesn\'t match your location');

    TextButton okButton = new TextButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child: Text('Ok')
    );

    AlertDialog alert = AlertDialog(
      title: (flag)? Text('Info'): Text('Warning'),
      content: (flag)? success: failure,
      actions: [
        okButton
      ],
    );

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return alert;
        }
    );
  }

  Widget textFields(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
          TextField(
            controller: coController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
              labelText: 'CO',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0,),
          TextField(
            controller: houseController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
              labelText: 'House',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0,),
          TextField(
            controller: streetController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
              labelText: 'Street',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0,),
          TextField(
            controller: lmController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
              labelText: 'LM',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0,),
          TextField(
            enabled: false,
            controller: locController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
              labelText: 'LOC',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0,),
          TextField(
            enabled: false,
            controller: vtcController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
              labelText: 'VTC',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0,),
          TextField(
            enabled: false,
            controller: distController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
              labelText: 'DIST',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0,),
          TextField(
            enabled: false,
            controller: stateController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
              labelText: 'State',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0,),
          TextField(
            enabled: false,
            controller: pcController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
              labelText: 'PC',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0,),

          TextButton(
              onPressed: () async{
                bool res = await determinePosition(
                              pc: pcController.text,
                              state: stateController.text,
                              district: distController.text
                            );

                updateSuccess = res;
                if(updateSuccess){
                  Address updated_address = new Address(
                      co: coController.text,
                      house: houseController.text,
                      street: streetController.text,
                      lm: lmController.text,
                      loc: locController.text,
                      country: widget.donor.address.country,
                      vtc: vtcController.text,
                      dist: distController.text,
                      state: stateController.text,
                      pc: pcController.text
                  );

                  await CRUD.removeAndUpdateAudit(widget.phone, widget.donor, updated_address);

                  Fluttertoast.showToast(msg: 'Address Updated Successfully');
                  Navigator.pop(context);
                }else{
                  await showAlert(context, res);
                }

              },
              child: Container(
                  width: 200,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: const Center(
                      child: Text(
                          'Update',
                          style: TextStyle(
                              color: Colors.white,
                            fontSize: 16
                          )
                      )
                  )
              )
          )
        ],
      ),
    );
  }

  //Adds donor value in text fields
  void addDonorValues(){
    Address address = widget.donor.address;
    coController.text = address.co;
    houseController.text = address.house;
    streetController.text = address.street;
    lmController.text = address.lm;
    locController.text = address.loc;
    vtcController.text = address.vtc;
    distController.text = address.dist;
    stateController.text = address.state;
    pcController.text = address.pc;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: (useAddress)?
          textFields():

          //Use address Button
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.donor.phone} gave access to you',
                  style: textStyle(false),
                ),
                SizedBox(height: 35,),
                TextButton(
                    onPressed: (){
                      addDonorValues();
                      setState(() {
                        useAddress = true;
                      });
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
                                'Use Address',
                                style: TextStyle(
                                    color: Colors.white
                                )
                            )
                        )
                    )
                ),
                SizedBox(height: 20,),
                TextButton(
                    onPressed: () async{
                      await CRUD.cancelRequest(widget.phone, widget.donor.phone, false);
                      widget.callback();
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
                                'Request Someother Donor',
                                style: TextStyle(
                                    color: Colors.white
                                )
                            )
                        )
                    )
                ),
              ],
            ),
          ),
    );
  }
}
