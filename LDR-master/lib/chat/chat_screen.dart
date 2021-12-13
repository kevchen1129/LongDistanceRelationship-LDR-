import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import 'audio.dart';
import 'call.dart';
import 'document.dart';
import 'messages.dart';
import 'model/user_model.dart';
import 'new_message.dart';
import 'photo.dart';
import 'thumb_kiss.dart';

import 'dart:async';

import './call.dart';

class ChatScreen extends StatefulWidget {
  final Users user;
  final pairChatID;
  ChatScreen({this.user, this.pairChatID});
  String _inputMessage;
  bool _plusTapped = false;
  bool textTapped = false;
  bool audioOn = false;
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestore = FirebaseFirestore.instance;
  DocumentSnapshot snapshot;
  /*void setData() {
    firestore.collection("Users").doc("User1").update({"hasCalled": true});
  }

  void getData() {
    firestore.collection("Users").doc("User1").get().then((value) => {
      snapshot=value
    });
    snapshot.data()["hasCalled"]
  }*/

  void initState() {}
  void _plusPressed() {
    setState(() {
      if (widget._plusTapped == false) {
        widget._plusTapped = true;
      } else {
        widget._plusTapped = false;
        widget.audioOn = false;
      }
    });
  }

  void _audioPress() {
    if (widget.audioOn == false) {
      widget.audioOn = true;
    } else {
      widget.audioOn = false;
    }
    print("mother fucker " + widget.audioOn.toString());
    setState(() {});
  }

  _buildPlusComposer() {
    return widget._plusTapped == false
        ? SizedBox()
        : Container(
            height: MediaQuery.of(context).size.height * 0.11,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Photo(
                  pairChatId: widget.pairChatID,
                ),
                Audio(audioPressed: _audioPress),
                Document(),
                ThumbKiss()
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text(
            //widget.user.name,
            'test',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.025,
                fontWeight: FontWeight.bold),
          ),
          elevation: 10.5,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.call),
              iconSize: MediaQuery.of(context).size.height * 0.03,
              //color: Color(0xFFE0A3A0),
              onPressed: onJoin,
            )
          ],
        ),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(children: <Widget>[
              Expanded(child: Messages(pairChatId: widget.pairChatID)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              NewMessage(
                focusNode: widget._focusNode,
                plusTapped: _plusPressed,
                pairChatId: widget.pairChatID,
                audioMode: widget.audioOn,
              ),
              // _buildMessageComposer(),
              _buildPlusComposer()
            ])));
  }

  Future<void> onJoin() async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: 'Test',
          role: ClientRole.Broadcaster,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
