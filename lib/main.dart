import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memeplug/pages/HomePage.dart';
import 'package:memeplug/widgets/constants.dart';
import 'package:memeplug/widgets/dart/splashScreenWidget.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
// po

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemePlug',
      debugShowCheckedModeBanner: false,
      theme: kDarkTheme,
      // theme: ThemeData(
      //   scaffoldBackgroundColor: Colors.black,
      //   //the above sets all scaffold to a defualt of black
      //   dialogBackgroundColor: Colors.black,
      //   primarySwatch: Colors.grey,
      //   accentColor: Colors.black,
      //   cardColor: Colors.white70,
      // ),
      home: HomePage(),
    );
  }
}
