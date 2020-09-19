import 'package:flutter/material.dart';
import 'package:memeplug/pages/HomePage.dart';
import 'package:memeplug/widgets/constants.dart';
import 'package:memeplug/widgets/dart/splashScreenWidget.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
