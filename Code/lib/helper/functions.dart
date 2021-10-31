import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:aadhaar_address_update/models/RequestModel.dart';

Future<bool> determinePosition({pc, state, district}) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Fluttertoast.showToast(msg: 'Please enable Your Location Service');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: 'Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    Fluttertoast.showToast(
        msg:
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // print(placemarks);
    Placemark place = placemarks[0];

    // print(place);

    if(place.postalCode == pc && place.administrativeArea == state){
      return true;
    }else{
      return false;
    }

    // setState(() {
    //   currentAddress = "${placemarks[0]} ---------------------------------- $place";
    //   // print(place);
    // });
  } catch (e) {
    print(e);
    return false;
  }

  // return position;
}



//TextStyle
TextStyle textStyle(bool isBold){
  return TextStyle(
    fontSize: 20.0,
    fontWeight: (isBold)? FontWeight.bold: null
  );
}


//Box Decoration
BoxDecoration background(){
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFBBDEFB),
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Color(0xFFBBDEFB),
            // Colors.greenAccent,
            // Colors.yellowAccent,
            // Colors.cyanAccent,
            // Colors.yellowAccent
          ]
      )
  );
}



class ListOfRequest{
  List<Request> req = [];
}