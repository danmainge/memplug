import 'package:flutter/material.dart';
import 'package:memeplug/pages/EditProfilePage.dart';
import 'package:memeplug/pages/NotificationsPage.dart';
import 'package:memeplug/widgets/dart/HeaderWidget.dart';
import 'package:memeplug/widgets/dart/ProgressWidget.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true),
        body: Column(children: [
          Container(
            child: circularProgress(),
          ),
          FlatButton.icon(
              color: Colors.amber,
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationsPage())),
              icon: Icon(Icons.backup),
              label: Text('yes'))
        ]));
  }
}
