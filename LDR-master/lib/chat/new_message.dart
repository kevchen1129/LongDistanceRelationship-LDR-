import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  FocusNode focusNode;
  final pairChatId;
  final audioMode;
  NewMessage(
      {this.focusNode, this.plusTapped, this.pairChatId, this.audioMode});
  Function plusTapped;

  @override
  _NewMessageState createState() => _NewMessageState();
  TextEditingController _controller = TextEditingController();
  String _inputMessage;
}

class _NewMessageState extends State<NewMessage> {
  _addMessage() {
    FocusScope.of(context).unfocus();
    widget._controller.clear();
    if (widget._inputMessage.isEmpty) {
      return;
    }

    final userID = FirebaseAuth.instance.currentUser;
    final hour = DateTime.now().hour % 12;
    final day = DateTime.now().hour / 12;
    final minute = DateTime.now().minute;
    final hourString = hour.toString();
    final minuteString = minute.toString();
    final resultTime =
        hourString + ":" + minuteString + (day == 0 ? " am" : "pm");
    FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.pairChatId)
        .collection('chatroom')
        .add({
      "text": widget._inputMessage,
      "resultTime": resultTime,
      'isLiked': false,
      'unread': true,
      'createdTime': Timestamp.now(),
      'userID': userID.uid,
      'imageUrl': null
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return
        // (widget.audioMode == true)
        //     ? AudioBar(
        //         plusTapped: widget.plusTapped,
        //       )
        //     :
        Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            height: MediaQuery.of(context).size.height * 0.08,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.09,
                      height: MediaQuery.of(context).size.width * 0.09,
                      decoration: BoxDecoration(
                        color: Color(0xFFDCD8D8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                        child: IconButton(
                            icon: Icon(Icons.add),
                            iconSize: MediaQuery.of(context).size.width * 0.06,
                            color: Color(0xFF736464),
                            onPressed: widget.plusTapped),
                        top: -MediaQuery.of(context).size.height * 0.010,
                        left: -MediaQuery.of(context).size.height * 0.009),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.09,
                        height: MediaQuery.of(context).size.width * 0.09,
                        decoration: BoxDecoration(
                          color: Color(0xFFDCD8D8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Positioned(
                          child: IconButton(
                              icon: Icon(Icons.camera_alt_rounded),
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              color: Color(0xFF736464),
                              onPressed: () {}),
                          top: -MediaQuery.of(context).size.height * 0.010,
                          left: -MediaQuery.of(context).size.height * 0.009),
                    ],
                  ),
                ),
                Container(
                  width: widget.focusNode.hasFocus
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.width * 0.62,
                  margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.025),
                  decoration: BoxDecoration(
                      color: Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            MediaQuery.of(context).size.height * 0.01),
                        topRight: Radius.circular(
                            MediaQuery.of(context).size.height * 0.01),
                        bottomLeft: Radius.circular(
                            MediaQuery.of(context).size.height * 0.01),
                        bottomRight: Radius.circular(
                            MediaQuery.of(context).size.height * 0.01),
                      )),
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.01),
                  child: TextField(
                    controller: widget._controller,
                    focusNode: widget.focusNode,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      widget._inputMessage = value;
                      print(widget.focusNode.hasFocus);
                    },
                    onTap: () {
                      print(widget.focusNode.hasFocus);
                    },
                    decoration: InputDecoration(
                        hintText: "",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.emoji_emotions),
                        ),
                        border: InputBorder.none),
                  ),
                ),
                widget.focusNode.hasFocus
                    ? IconButton(
                        icon: Icon(Icons.send),
                        iconSize: MediaQuery.of(context).size.height * 0.025,
                        color: Colors.grey,
                        onPressed: () {
                          _addMessage();
                        })
                    : SizedBox()
              ],
            ));
  }
}
