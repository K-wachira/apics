import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class uploadurl extends StatefulWidget {
  @override
  _uploadurlState createState() => _uploadurlState();
}

class _uploadurlState extends State<uploadurl> {
  var _firebaseRef = FirebaseDatabase().reference().child('posts');
  TextEditingController _txtCtrl = TextEditingController();


  sendMessage() {
    _firebaseRef.push().set({
      "message": _txtCtrl.text,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    });
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Center(

        child: FlatButton.icon(
          color: Colors.red,
            onPressed: () => sendMessage(), icon: Icon(Icons.file_upload), label: Text("Upload")),
      ),
    );
  }
}
