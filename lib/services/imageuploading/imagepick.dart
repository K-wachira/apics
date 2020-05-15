import 'package:apics/services/display/Homepage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/src/widgets/basic.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _ImageFile;

//  Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _ImageFile = selected;
    });
  }

//  Remove image
  void _clear() {
    setState(() {
      _ImageFile = null;
    });
  }

//  call two functions


  Future<void> _cropImage() async {
    File croped = await ImageCropper.cropImage(
      sourcePath: _ImageFile.path,
      );
    setState(() {
      _ImageFile = croped ?? _ImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            )
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_ImageFile != null) ...[
            Image.file(_ImageFile),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: () => _cropImage(),
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: () => _clear(),
                ),
                Uploader(file: _ImageFile)
              ],
            )
          ]
        ],
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  String ImgUrl;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://apics-a3725.appspot.com");


  var _firebaseRef = FirebaseDatabase().reference().child('posts');

  sendMessage() {
    _startUpload();
    setState(() async {
      String ImgUrl = await( await _uploadTask.onComplete).ref.getDownloadURL();
      _firebaseRef.push().set({
        "URL": ImgUrl,
        "comments": 0,
        "likes": 0,
        "dislikes":0,

    });
    });
  }

  StorageUploadTask _uploadTask;

  void _startUpload() async{

    String filePath = 'images/${DateTime.now()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });




  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshots) {
            var event = snapshots?.data?.snapshot;

            double ProgressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;
            print('${(ProgressPercent * 100).toStringAsFixed(2)}%');
            return Column(
              children: <Widget>[
                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),
                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.pause,
                  ),
                LinearProgressIndicator(value: ProgressPercent),
                Text('${(ProgressPercent * 100).toStringAsFixed(2)}%'),
              ],
            );
          });
    } else {
      return Row(
        children: <Widget>[
           FlatButton.icon(
              color: Colors.red,
              onPressed: () => sendMessage(), icon: Icon(Icons.file_upload), label: Text("Upload")),

        ],
      );
    }
  }
}
