import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:aadhaar_address_update/models/ProfileModel.dart';
import 'package:aadhaar_address_update/models/AddressModel.dart';

import 'package:aadhaar_address_update/screens/update_address.dart';
import 'package:aadhaar_address_update/screens/notification.dart';

import 'package:aadhaar_address_update/helper/functions.dart';

class HomePage extends StatefulWidget {
  Profile profile;

  HomePage({required this.profile});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Profile profile;
  late Address address;

  @override
  void initState() {
    profile = widget.profile;
    address = profile.address;
    super.initState();
  }

  Expanded expand(String str, int flex, bool isBold){
    return Expanded(
      flex: flex,
      child: Text(
        str,
        style: textStyle(isBold),
      ),
    );
  }

  Padding combineLabelWithValue(String label, String value){
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          expand(label, 1, true),
          Text(
            ':    ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          expand(value, 2, false)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    var padding = MediaQuery.of(context).padding;
    double height1 = MediaQuery.of(context).size.height - padding.top - padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text('HOME'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                //Navigator.pushNamed(context, '/notification');
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage(phone: profile.phone, address: address,))
                );
              },
              icon: Icon(
                  Icons.notifications_none
              )
          ),
        ]
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: BoxConstraints(
            minHeight: height1
          ),
          decoration: background(),
          child: Column(
            children: [
              combineLabelWithValue('Name', profile.name),
              combineLabelWithValue('DOB', profile.dob),
              combineLabelWithValue('Gender', (profile.gender == 'M')? 'Male': 'Female'),
              combineLabelWithValue('Phone', profile.phone),

              //Address
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Address',
                        style: textStyle(true),
                      ),
                    ),
                    Text(
                      ':    ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            '${address.co}, ${address.house}, ${address.street}, ${address.lm}, ${address.loc}, ${address.vtc}, ${address.dist}, ${address.state}-${address.pc}',
                            style: TextStyle(
                              fontSize: 19.0
                            ),
                          ),
                        ]
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //Navigator.pushNamed(context, '/update');
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UpdateAddress(profile: profile))
          );
        },
        tooltip: 'Update Address',
        child: Center(
          child: Icon(Icons.edit),
        ),
      ),
    );
  }
}
