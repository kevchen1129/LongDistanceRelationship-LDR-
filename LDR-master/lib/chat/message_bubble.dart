import 'package:flutter/material.dart';

import 'image_display.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.messageText, this.messageTime, this.isMe, this.imageUrl});
  final messageTime;
  final messageText;
  final isMe;
  final imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.023),
            isMe == false
                ? Text("")
                : Text(messageTime,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.height * 0.011,
                        fontWeight: FontWeight.w600))
          ],
        ),
        (imageUrl != null)
            ? GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ImageDisplay(imageUrl: imageUrl))),
                child: Image(
                    image: NetworkImage(imageUrl), width: 300, height: 300))
            : Container(
                margin: isMe
                    ? EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10.0)
                    : EdgeInsets.only(top: 8.0, bottom: 8.0, left: 10.0),
                child: Text(messageText,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 13.0,
                      // fontWeight: FontWeight.w600
                    )),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: isMe ? Color(0xFFF7F4F2) : Color(0xFFF1F3F3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                ),
              ),
        Column(children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.023),
          isMe
              ? Text("")
              : Text(messageTime,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.height * 0.011,
                      fontWeight: FontWeight.w600))
        ])
      ],
    ));
  }
}
