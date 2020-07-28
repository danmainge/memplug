import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_picker/media_picker.dart';
import 'package:memeplug/models/user.dart';
import 'package:memeplug/widgets/constants.dart';
import 'dart:io';

class UploadPage extends StatefulWidget {
  final User gCurrentUser;
  UploadPage({this.gCurrentUser});
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController captionTextEditingController = TextEditingController();
  // String _media = '';
  // List<dynamic> _mediaPaths;
  File file;
  captureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680, maxWidth: 970);
    setState(() {
      this.file = imageFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 680, maxWidth: 970);
    setState(() {
      this.file = imageFile;
    });
  }

  // pickVideoFromGallery() async {
  //   try {
  //     _mediaPaths = await MediaPicker.pickVideos(quantity: 7);
  //   } on PlatformException {}

  //   if (!mounted) return;

  //   setState(() {
  //     _media = _mediaPaths.toString();
  //   });
  // }

  takeImage(mcontext) {
    return showDialog(
        context: mcontext,
        builder: (context) {
          return SimpleDialog(
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
                  // onPressed: pickVideoFromGallery,
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
                  'upload Picture',
                  style: TextStyle(color: kWhiteColor, fontSize: 20.0),
                ),
                color: Colors.greenAccent,
                onPressed: () => takeImage(context),
              )),
        ],
      ),
    );
  }

  removeImage() {
    setState(() {
      file = null;
    });
  }

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: removeImage(),
        ),
        title: Text(
          'New Post',
          style: TextStyle(
              fontSize: 40.0, color: kWhiteColor, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => print('nyeneye bubu'),
            child: Text('upload to memeplug',
                style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.lightGreenAccent,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(children: <Widget>[
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
          padding: EdgeInsets.only(top: 12.0),
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
                hintText: 'add an interesting caption',
                hintStyle: TextStyle(color: kWhiteColor),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}
