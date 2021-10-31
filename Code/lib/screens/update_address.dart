import 'package:flutter/material.dart';

//Location
import 'package:aadhaar_address_update/helper/functions.dart';
import 'package:aadhaar_address_update/helper/widgets/requestedWidget.dart';

import 'package:aadhaar_address_update/models/ProfileModel.dart';
import 'package:aadhaar_address_update/models/DonorData.dart';
import 'package:aadhaar_address_update/helper/widgets/UpdateExistingAddress.dart';

import 'package:aadhaar_address_update/services/firebase/crud.dart';

class UpdateAddress extends StatefulWidget {
  Profile profile;

  UpdateAddress({required this.profile});

  @override
  _UpdateAddressState createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  late Donor res;

  //Donor gave permission
  bool isRequestGranted = false;
  bool canUpdateAddress = false;
  bool useAddress = false;

  bool isRequested = false;
  String donor_number = '';

  void reload(){
    setState(() {
      // useAddress = false;
      // isRequested = false;
    });
  }

  //Text Editing Controllers
  TextEditingController requestController = new TextEditingController();

  Future<String> checkRequest() async{
    res = await CRUD.checkRequest(widget.profile.phone);

    if(res.phone == ''){
      setState(() {
        isRequested = false;
        canUpdateAddress = false;
      });
    }else{
      donor_number = res.phone;

      if(res.accepted){
        setState(() {
          isRequested = false;
          canUpdateAddress = true;
        });
      }else{
        setState(() {
          isRequested = true;
          canUpdateAddress = false;
        });
      }
    }

    return "";
  }

  @override
  void initState() {
    checkRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height1 = MediaQuery.of(context).size.height - padding.top - padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Address'),
        centerTitle: true,
      ),
      body: Container(
        decoration: background(),
        constraints: BoxConstraints(
          minHeight: height1
        ),
        child: FutureBuilder(
          future: checkRequest(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return (isRequested)?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Requested(phone: widget.profile.phone, donor_number: donor_number, callback: checkRequest,),
                      ),
                    ]
                  ):
                  (canUpdateAddress)?
                  Update(phone: widget.profile.phone,donor: res, callback: reload,):

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: requestController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Contact',
                            helperText: 'Donor\'s Phone Number',
                            helperStyle: TextStyle(color: Colors.green),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextButton(
                            onPressed: () async{
                              print(requestController.text);

                              if(requestController.text.trim().length == 10){
                                print('Phone Number');

                                bool res = await CRUD.sendRequest(widget.profile, requestController.text.trim());
                                checkRequest();
                                setState(() {
                                  isRequestGranted = true;
                                });
                              }else{
                                print('Invalid Data');
                              }

                            },
                            child: Container(
                                width: 160,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: const Center(
                                    child: Text(
                                        'Request',
                                        style: TextStyle(
                                            color: Colors.white
                                        )
                                    )
                                )
                            )
                        ),
                      ],
                    ),
                  );
            }

            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}
