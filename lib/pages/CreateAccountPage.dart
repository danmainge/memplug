import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memeplug/widgets/constants.dart';
import 'package:memeplug/widgets/dart/HeaderWidget.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;
  submitusername() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      SnackBar snackBar = SnackBar(content: Text('welcome ' + username));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context, username);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, strTitle: 'Settings', disappearBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 26.0),
                  child: Center(
                    child: Text(
                      'set up username',
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
                        style: TextStyle(color: Colors.black),
                        validator: (val) {
                          if (val.trim().length < 5 || val.isEmpty) {
                            return 'username is too short';
                          } else if (val.trim().length > 12) {
                            return 'username should is too long';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => username = val,
                        decoration: kInputDecoration.copyWith(
                            labelText: 'username',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            fillColor: Colors.white.withOpacity(0.4),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                      ),
                    ),
                  ),
                ),
                ButtonTheme(
                  minWidth: 200,
                  child: RaisedButton(
                    color: Colors.white,
                    elevation: 5.0,
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'submit',
                      style: TextStyle(fontSize: 20, color: Color(0xFF5270AA)),
                    ),
                    onPressed: () {
                      submitusername();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
