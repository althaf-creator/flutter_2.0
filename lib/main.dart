import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_app_v2_0/Authentication/authentication.dart';
import 'package:plant_app_v2_0/Storehome/Storehome.dart';
import 'package:plant_app_v2_0/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Mcommerce.auth = FirebaseAuth.instance;
  //Mcommerce.sharedPreferences = await SharedPreferences.getInstance();
  //Mcommerce.firestore = Firestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.blue,
      ),
      home: Authentication(),
    );
  }
}
