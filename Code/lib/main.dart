import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:aadhaar_address_update/screens/login.dart';
import 'package:aadhaar_address_update/screens/home.dart';
import 'package:aadhaar_address_update/screens/notification.dart';
import 'package:aadhaar_address_update/screens/update_address.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aadhar Address Update',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
      },
    )
  );
}
