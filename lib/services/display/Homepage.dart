import 'package:apics/services/imageuploading/Uploader.dart';
import 'package:apics/services/imageuploading/imagepick.dart';
import 'package:flutter/material.dart';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        ImageCapture(),
      ],
    );


  }
}
