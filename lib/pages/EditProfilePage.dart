import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memeplug/models/user.dart';
import 'package:memeplug/pages/HomePage.dart';
import 'package:memeplug/pages/changeprofilepicture.dart';
import 'package:memeplug/widgets/constants.dart';
import 'package:memeplug/widgets/dart/CImageWidget.dart';
import 'package:memeplug/widgets/dart/ProgressWidget.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:memeplug/pages/profileimage.dart';

class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;
  EditProfilePage({this.currentOnlineUserId});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profileNameEditingController = TextEditingController();
  TextEditingController bioTextEditController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  bool _profileNameValid = true;
  bool _bioValid = true;

  void initState() {
    super.initState();
    getAndDisplayUserInfo();
  }

  getAndDisplayUserInfo() async {
    setState(() {
      loading = true;
    });
    DocumentSnapshot documentSnapshot =
        await usersReference.document(widget.currentOnlineUserId).get();
    user = User.fromDocument(documentSnapshot);
    profileNameEditingController.text = user.profileName;
    bioTextEditController.text = user.bio;
    setState(() {
      loading = false;
    });
  }

  // takeImage(mcontext) {
  //   return showDialog(
  //       context: mcontext,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: Text('change profile picture',
  //               style:
  //                   TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold)),
  //           children: <Widget>[
  //             SimpleDialogOption(
  //               child: Text('capture image with camera'),
  //               onPressed: captureWithCamera,
  //             ),
  //             SimpleDialogOption(
  //               child: Text('capture image with cameea'),
  //               onPressed: retriveImageFromGallery,
  //             ),
  //             SimpleDialogOption(
  //               child: Text('cancel', style: TextStyle(color: kWhiteColor)),
  //               onPressed: () => Navigator.pop(context),
  //             ),
  //           ],
  //         );
  //       });
  // }

  // updateProfileImage() {
  //   // takeImage(context);
  // }

  // profilePictureScaffold() {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     appBar: AppBar(
  //       title: Text(
  //         'profile picture',
  //         style: TextStyle(color: Colors.white, fontSize: 15.0),
  //       ),
  //       actions: <Widget>[
  //         IconButton(
  //           icon: Icon(Icons.edit),
  //           onPressed: showProfileSnackBar(context),
  //         )
  //       ],
  //     ),
  //   );
  // }

  updateUserData() {
    setState(() {
      profileNameEditingController.text.trim().length < 3 ||
              profileNameEditingController.text.isEmpty
          ? _profileNameValid = false
          : _profileNameValid = true;
      bioTextEditController.text.trim().length > 130
          ? _bioValid = false
          : _bioValid = true;
    });
    if (_bioValid && _profileNameValid) {
      usersReference.document(widget.currentOnlineUserId).updateData({
        'profileName': profileNameEditingController.text,
        'bio': bioTextEditController.text,
      });
      SnackBar profileUpdateSucessfulSnackBar =
          SnackBar(content: Text('profile has been upadated suceesfully.'));
      _scaffoldGlobalKey.currentState
          .showSnackBar(profileUpdateSucessfulSnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () => Navigator.pop(context))
        ],
      ),
      body: loading
          ? linearProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 7.0),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePicture())),
                          child: CircleAvatar(
                            radius: 52.0,
                            backgroundImage:
                                CachedNetworkImageProvider(user.url),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            createProfileNameTextFormFeild(),
                            bioProfileTextFormFeild()
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 29.0, left: 50.0, right: 50.0),
                        child: RaisedButton(
                          onPressed: updateUserData,
                          child: Text(
                            'update',
                            style: TextStyle(
                                color: Colors.black12, fontSize: 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, left: 50.0, right: 50.0),
                        child: RaisedButton(
                          color: Colors.red,
                          onPressed: logOutUser,
                          child: Text(
                            'Logout',
                            style:
                                TextStyle(color: Colors.black12, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  logOutUser() async {
    await gSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  Column createProfileNameTextFormFeild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            'Profile Name',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.white),
          controller: profileNameEditingController,
          decoration: kInputDecoration.copyWith(
              fillColor: bWhiteColor,
              hintText: 'set profile name',
              hintStyle: TextStyle(color: Colors.grey),
              errorText:
                  _profileNameValid ? null : " profile name is too short"),
        ),
      ],
    );
  }

  Column bioProfileTextFormFeild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            'Bio',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.white),
          controller: bioTextEditController,
          decoration: kInputDecoration.copyWith(
              fillColor: bWhiteColor,
              hintText: 'what motivates you',
              errorText: _bioValid ? null : " bio is too long"),
        ),
      ],
    );
  }
}
