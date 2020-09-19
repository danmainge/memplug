import 'package:flutter/material.dart';
import 'package:memeplug/widgets/constants.dart';
import 'package:memeplug/widgets/dart/HeaderWidget.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: 'Notifications'),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Memeplug',
              style: TextStyle(
                  fontFamily: 'Signatra', fontSize: 92.0, color: kButtonColor),
            ),
          ],
        ),
      ),
      // appBar: header(context, strTitle: 'Notification'),
    );
  }
}

class NotificationsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Memeplug',
          style: TextStyle(
              fontFamily: 'Signatra', fontSize: 92.0, color: kButtonColor),
        ),
      ),
    );
  }
}
