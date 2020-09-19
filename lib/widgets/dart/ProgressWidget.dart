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
  Container(
    color: Colors.black,
    child: SpinKitChasingDots(
      color: kButtonColor,
      size: 50,
    ),
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

class KSpinner2 extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String username;
  showDefaultSnackBar() {
    SnackBar snackBar = SnackBar(content: Text('welcome' + username));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Center(
                child: SpinKitChasingDots(
                  color: kButtonColor,
                  size: 50.0,
                ),
              ),
              showDefaultSnackBar()
            ],
          ),
        ));
  }
}
