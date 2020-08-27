import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memeplug/models/user.dart';
import 'package:memeplug/pages/HomePage.dart';
import 'package:memeplug/widgets/constants.dart';
import 'package:memeplug/widgets/dart/ProgressWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image/image.dart' as ImD;

import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  final User gCurrentUser;
  UploadPage({this.gCurrentUser});
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  TextEditingController captionTextEditingController = TextEditingController();
  File file;
  bool uploading = false;
  String postId = Uuid().v4();

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 60));
    setState(() {
      file = compressedImageFile;
    });
  }

  controlUploadAndSavePost() async {
    setState(() {
      uploading = true;
    });
    await compressingPhoto();
    String downloadUrl = await uploadPhoto(file);
    savePostInfoToFireStore(
        url: downloadUrl, caption: captionTextEditingController.text);
    captionTextEditingController.clear();
    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  savePostInfoToFireStore({String url, String caption}) {
    postsReference
        .document(widget.gCurrentUser.id)
        .collection('usersPosts')
        .document(postId)
        .setData({
      'postId': postId,
      'ownerId': widget.gCurrentUser.id,
      'timestamp': timestamp,
      'likes': {},
      'username': widget.gCurrentUser.username,
      'caption': caption,
      'url': url,
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    StorageUploadTask mStorageUploadTask =
        storageReference.child('post_$postId.jpg').putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1000, maxWidth: 970);
    setState(() {
      this.file = imageFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1000, maxWidth: 970);
    setState(() {
      this.file = imageFile;
    });
  }

  takeImage(mcontext) {
    return showDialog(
      
        context: mcontext,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: kDarkSecondaryColor,
              title: Text(
                'New Post',
                style:
                    TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                SimpleDialogOption(
                  child: Text('capture Image with camera',
                      style: TextStyle(color: kWhiteColor)),
                  onPressed: captureImageWithCamera,
                ),
                SimpleDialogOption(
                  child: Text(
                    'select image from gallery',
                    style: TextStyle(color: kWhiteColor),
                  ),
                  onPressed: pickImageFromGallery,
                ),
                SimpleDialogOption(
                  child: Text('select video from gallery',
                      style: TextStyle(color: kWhiteColor)),
                  onPressed: null,
                ),
                SimpleDialogOption(
                    child: Text('cancel', style: TextStyle(color: kWhiteColor)),
                    onPressed: () => Navigator.pop(context))
              ]);
        });
  }

  displayUploadScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add_photo_alternate,
            color: Colors.greenAccent,
            size: 200,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0)),
              child: Text(
                'upload ',
                textAlign: TextAlign.center,
                style: TextStyle(color: kWhiteColor, fontSize: 20.0),
              ),
              color: Colors.black,
              onPressed: () => takeImage(context),
            ),
          ),
        ],
      ),
    );
  }

  clearPostInfo() {
    captionTextEditingController.clear();
    setState(() {
      file = null;
    });
  }

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: clearPostInfo,
        ),
        title: Text(
          'New Post',
          style: TextStyle(
              fontSize: 24.0, color: kWhiteColor, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: uploading ? null : () => controlUploadAndSavePost(),
            child: Text('Share',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.lightGreenAccent,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(children: <Widget>[
        uploading ? linearProgress() : Text(''),
        Container(
          height: 230,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(file), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(widget.gCurrentUser.url),
          ),
          title: Container(
            width: 250,
            child: TextField(
              style: TextStyle(color: Colors.white.withOpacity(0.4)),
              controller: captionTextEditingController,
              decoration: InputDecoration(
                fillColor: Colors.white.withOpacity(0.4),
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                hintText: 'add an interesting caption',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  bool get wantKeepAlive => true;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}
