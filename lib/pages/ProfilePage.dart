import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memeplug/models/user.dart';
import 'package:memeplug/pages/EditProfilePage.dart';
import 'package:memeplug/pages/HomePage.dart';
import 'package:memeplug/widgets/dart/HeaderWidget.dart';
import 'package:memeplug/widgets/dart/ProgressWidget.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;
  ProfilePage({this.userProfileId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser?.id;

  createProfileTopView() {
    return FutureBuilder(
        future: usersReference.document(widget.userProfileId).get(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return kSpinKitChasingDots();
          }
          User user = User.fromDocument(dataSnapshot.data);
          return Padding(
            padding: EdgeInsets.all(17.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 35.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(user.url),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              createColumns('posts', 0),
                              createColumns('followers', 0),
                              createColumns('following', 0),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[createButton()],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 9),
                  child: Text(
                    user.username != null ? user.username : 'memelord',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    user.profileName,
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    user.bio,
                    style: TextStyle(fontSize: 18.0, color: Colors.white54),
                  ),
                )
              ],
            ),
          );
        });
  }

  createButton() {
    bool ownProfile = currentOnlineUserId == widget.userProfileId;
    if (ownProfile) {
      return createButtonTitleAndFunction(
          title: 'Edit profile', performFunction: editUserProfile);
    }
  }

  Container createButtonTitleAndFunction(
      {String title, Function performFunction}) {
    return Container(
      padding: EdgeInsets.only(top: 3.0),
      child: FlatButton(
          onPressed: performFunction,
          child: Container(
            width: 150.0,
            height: 26.0,
            child: Text(
              title,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6.0)),
          )),
    );
  }

  editUserProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditProfilePage(currentOnlineUserId: currentOnlineUserId)));
  }

  Column createColumns(String title, int count) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            count.toString(),
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
            ),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true, strTitle: 'Profile'),
        body: ListView(children: <Widget>[
          createProfileTopView(),
        ]));
  }
}
