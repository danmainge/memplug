import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_picker/media_picker.dart';
import 'dart:io';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String _media = '';
  List<dynamic> _mediaPaths;
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

  pickVideoFromGallery() async {
    try {
      _mediaPaths = await MediaPicker.pickVideos(quantity: 7);
    } on PlatformException {}

    if (!mounted) return;

    setState(() {
      _media = _mediaPaths.toString();
    });
  }

  takeImage(mcontext) {
    return showDialog(
        context: mcontext,
        builder: (context) {
          return SimpleDialog(
              title: Text(
                'New Post',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                SimpleDialogOption(
                  child: Text('capture Image with camera',
                      style: TextStyle(color: Colors.white)),
                  onPressed: captureImageWithCamera,
                ),
                SimpleDialogOption(
                  child: Text(
                    'select image from gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: pickImageFromGallery,
                ),
                SimpleDialogOption(
                  child: Text('select video from gallery',
                      style: TextStyle(color: Colors.white)),
                  onPressed: pickVideoFromGallery,
                ),
                SimpleDialogOption(
                    child:
                        Text('cancel', style: TextStyle(color: Colors.white)),
                    onPressed: null)
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
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.greenAccent,
                onPressed: () => takeImage(context),
              )),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return displayUploadScreen();
  }
}
