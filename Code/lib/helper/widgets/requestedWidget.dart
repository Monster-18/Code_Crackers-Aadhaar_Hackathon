import 'package:flutter/material.dart';

import 'package:aadhaar_address_update/helper/functions.dart';

import 'package:aadhaar_address_update/services/firebase/crud.dart';

class Requested extends StatefulWidget {
  String phone;
  String donor_number;
  VoidCallback callback;

  Requested({required this.phone, required this.donor_number, required this.callback});

  @override
  _RequestedState createState() => _RequestedState();
}

class _RequestedState extends State<Requested> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            Text(
                'You requested ${widget.donor_number}',
              style: textStyle(false),
            ),
            SizedBox(
              height: 35.0,
            ),
            TextButton(
                onPressed: () async{
                  await CRUD.cancelRequest(widget.phone, widget.donor_number, false);
                  widget.callback();
                },
                child: Container(
                    width: 100,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: const Center(
                        child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Colors.white
                            )
                        )
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}
