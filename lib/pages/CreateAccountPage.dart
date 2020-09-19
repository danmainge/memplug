import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:memeplug/widgets/constants.dart';
import 'package:memeplug/widgets/dart/HeaderWidget.dart';
import 'package:memeplug/widgets/dart/ProgressWidget.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;
  bool loadingScreen = false;
  submitUsername() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        loadingScreen = true;
      });
      SnackBar snackBar = SnackBar(content: Text('welcome ' + username));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 4), () {
        setState(() {
          loadingScreen = false;
        });
        Navigator.pop(context, username);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadingScreen
        ? KSpinner()
        : Scaffold(
            key: _scaffoldKey,
            appBar: header(context,
                strTitle: 'Settings', disappearBackButton: true),
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 26.0),
                  child: Center(
                    child: Text(
                      'Set up username',
                      style: TextStyle(fontSize: 26.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        validator: (val) {
                          if (val.trim().length < 5 || val.isEmpty) {
                            return 'username is too short';
                          } else if (val.trim().length > 12) {
                            return 'username should be between 5 to 12 ';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => username = val,
                        decoration: InputDecoration(
                            hintText: 'username',
                            hintStyle: TextStyle(color: Colors.grey),
                            fillColor: Colors.black.withOpacity(0.4),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0))),

                        // kInputDecoration.copyWith(
                        //     hintText: 'your royal memelord',
                        //     labelText: 'username',
                        //     labelStyle:
                        //         TextStyle(fontSize: 16.0, color: kGreyColor),
                        //     fillColor: Colors.white.withOpacity(0.4),
                        //     errorBorder: UnderlineInputBorder(
                        //         borderRadius: BorderRadius.circular(30.0),
                        //         borderSide: BorderSide(color: kButtonColor),
                        //         ),
                        //         ),
                      ),
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: 200,
                  child: RaisedButton(
                    color: kButtonColor,
                    elevation: 5.0,
                    padding: EdgeInsets.only(top: 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Text(
                      'submit',
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      submitUsername();
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
