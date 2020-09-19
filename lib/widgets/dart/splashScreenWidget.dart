import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memeplug/pages/HomePage.dart';
import 'package:memeplug/widgets/constants.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SplashScreen(
        backgroundColor: Colors.black,
        seconds: 6,
        navigateAfterSeconds: new HomePage(),
        title: new Text(
          'Memeplug',
          textScaleFactor: 2,
          style: TextStyle(
              fontFamily: 'Signatra', color: kButtonColor, fontSize: 45),
        ),
        image: new Image.asset('assets/images/like a sir.jpeg'),
        loadingText: Text("Loading"),
        photoSize: 200.0,
        loaderColor: kButtonColor,
      ),
    );
  }
}
