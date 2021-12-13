import 'package:flutter/material.dart';

class Audio extends StatefulWidget {
  Function audioPressed;
  Audio({this.audioPressed});
  @override
  _AudioState createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.symmetric(
        //     horizontal: MediaQuery.of(context).size.width * 0.03),
        child: GestureDetector(
      // onTap: widget.audioPressed,
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
                  icon: Icon(Icons.keyboard_voice_outlined),
                  iconSize: 50.0,
                  color: Color(0xFF736464),
                  onPressed: widget.audioPressed),
              top: 3.0,
              left: 3.0),
        ],
      ),
    ));
  }
}
