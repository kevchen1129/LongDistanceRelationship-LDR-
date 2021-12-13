import 'package:flutter/material.dart';

class ThumbKiss extends StatefulWidget {
  @override
  _ThumbKissState createState() => _ThumbKissState();
}

class _ThumbKissState extends State<ThumbKiss> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
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
                  icon: Icon(Icons.thumbs_up_down_outlined),
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
