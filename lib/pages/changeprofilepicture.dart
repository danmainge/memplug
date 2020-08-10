import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memeplug/models/user.dart';
import 'package:memeplug/pages/EditProfilePage.dart';
import 'package:memeplug/widgets/dart/ProgressWidget.dart';

class ProfilePicture extends StatefulWidget {
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File file;
  bool OriginalProfilePicture = true;
  bool uploading = false;

  captureWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this.file = imageFile;
    });
  }

  retriveImageFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this.file = imageFile;
    });
  }

  displayOriginalProfilePicture() {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('profile picture'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showProfileBottomSheet()),
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () => showBottomSheet(
                    context: context,
                    builder: (context) => Container(
                          color: Colors.red,
                          // uploadAndSaveProfilePic()
                        )))
          ],
        ),
        body: ListView(
          children: <Widget>[
            uploading ? linearProgress() : Text(''),
            Container(
                height: 230,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                          // decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider())),
                          )),
                )),
          ],
        ));
  }

  displayChangingProfilePicture() {}
  @override
  Widget build(BuildContext context) {
    return OriginalProfilePicture == true
        ? displayOriginalProfilePicture()
        : displayChangingProfilePicture();
  }

  void _showProfileBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 100,
          color: Color(0xFF737373),
          child: Container(
              child: _buildBottomSheet(),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20)))),
        );
      },
    );
  }

  Row _buildBottomSheet() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Icon(Ionicons.ios_images),
            //  Icon(Ionicons.ios_images),
            subtitle: Text(
              'gallery',
              textAlign: TextAlign.center,
            ),
            onTap: retriveImageFromGallery(),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Icon(Ionicons.ios_camera),
            subtitle: Text('take photo', textAlign: TextAlign.center),
            onTap: captureWithCamera(),
          ),
        ),
        Expanded(
          child: ListTile(
              title: Icon(Icons.close),
              subtitle: Text('cancel', textAlign: TextAlign.center),
              onTap: closeBottomSheet),
        )
      ],
    );
  }

  void closeBottomSheet() {
    Navigator.pop(context);
  }

  void openGallery() {
    Navigator.pop(context);
    setState(() {});
  }
}
