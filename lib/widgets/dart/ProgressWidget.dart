import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

circularProgress() {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12),
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent)));
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.yellowAccent),
    ),
  );
}

kSpinKitChasingDots() {
  return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12),
      child: SpinKitChasingDots(
        color: Colors.yellowAccent,
      )

      //  LinearProgressIndicator(
      //   valueColor: AlwaysStoppedAnimation(Colors.yellowAccent),
      // ),
      );
}

class KSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.yellowAccent,
        ),
      ),
    );
  }
}
