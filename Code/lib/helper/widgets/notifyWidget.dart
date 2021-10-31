import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:aadhaar_address_update/models/RequestModel.dart';
import 'package:aadhaar_address_update/models/AddressModel.dart';

import 'package:aadhaar_address_update/helper/functions.dart';

import 'package:aadhaar_address_update/services/firebase/crud.dart';

class Notify extends StatefulWidget {
  String phone;
  Address address;
  Request request;
  VoidCallback callback;

  Notify({required this.request, required this.address, required this.phone, required this.callback});

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(3.0, 3.0),
              color: Colors.blueGrey,
            ),
            BoxShadow(
                offset: Offset(0.0, 0.0),
                color: Colors.white,
            )
          ]
        ),
        child: Column(
          children: [
            Text(
              '${widget.request.name} is requesting You for accessing your address',
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () async{
                      await CRUD.acceptRequest(widget.phone, widget.request.phone, widget.address);
                      Fluttertoast.showToast(msg: 'You accepted ${widget.request.name}\'s request');
                      widget.callback();
                    },
                    child: Container(
                        width: 100,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: const Center(
                            child: Text(
                                'Accept',
                                style: TextStyle(
                                    color: Colors.white
                                )
                            )
                        )
                    )
                ),
                TextButton(
                    onPressed: () async{
                      await CRUD.cancelRequest(widget.request.phone, widget.phone, true);
                      Fluttertoast.showToast(msg: 'You declined ${widget.request.name}\'s request');
                      widget.callback();
                    },
                    child: Container(
                        width: 100,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: const Center(
                            child: Text(
                                'Decline',
                                style: TextStyle(
                                    color: Colors.white
                                )
                            )
                        )
                    )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
