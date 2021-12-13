import 'package:flutter/material.dart';

class Document extends StatefulWidget {
  @override
  _DocumentState createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(
      //     horizontal: MediaQuery.of(context).size.width * 0.03),
      child: Stack(
        children: <Widget>[
          Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: Color(0xFFDCD8D8),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
              child: IconButton(
                  icon: Icon(Icons.attach_file),
                  iconSize: 50.0,
                  color: Color(0xFF736464),
                  onPressed: () {}),
              top: 3.0,
              left: 3.0),
        ],
      ),
    );
  }
}
