import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:memeplug/widgets/constants.dart';

circularProgress() {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12),
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xFFFFC107))));
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Color(0xFFFFC107)),
    ),
  );
}

kSpinKitChasingDots() {
  return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12),
      child: SpinKitChasingDots(
        color: kButtonColor,
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
          color: kButtonColor,
          size: 50.0,
        ),
      ),
    );
  }
}
