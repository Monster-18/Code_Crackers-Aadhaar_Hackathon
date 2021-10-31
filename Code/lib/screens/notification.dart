import 'package:aadhaar_address_update/helper/widgets/notifyWidget.dart';
import 'package:flutter/material.dart';

import 'package:aadhaar_address_update/services/firebase/crud.dart';

import 'package:aadhaar_address_update/models/RequestModel.dart';
import 'package:aadhaar_address_update/models/AddressModel.dart';

import 'package:aadhaar_address_update/helper/functions.dart';

class NotificationPage extends StatefulWidget {
  String phone;
  Address address;

  NotificationPage({required this.phone, required this.address});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Request> list = [];
  ListOfRequest listOfRequest = new ListOfRequest();

  void reload(){
    setState(() { });
  }

  Future<String> receiveRequests() async{
    list = await CRUD.receiveRequests(widget.phone);
    return "1";
  }

  Widget displayNotifications(){
    List<Notify> notify = [];

    for(Request req in list){
      notify.add(
        new Notify(
            request: req,
            address: widget.address,
            phone: widget.phone,
            callback: reload,
        )
      );
    }

    if(notify.isEmpty){
      return Center(child: Text('No requests'),);
    }

    return SingleChildScrollView(
      child: Column(
        children: notify,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    double height1 = MediaQuery.of(context).size.height - padding.top - padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: height1
        ),
        decoration: background(),
        child: FutureBuilder(
          future: receiveRequests(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return displayNotifications();
            }

            return Center(child: CircularProgressIndicator(),);
          },
        ),
      )
      // (isLoading)?
      //   Center(child: CircularProgressIndicator(),):
      //   Container(
      //     child: (list.isEmpty)?
      //       Center(child: Text('No Requests'),):
      //         displayNotifications(),
      //   ),
    );
  }
}
