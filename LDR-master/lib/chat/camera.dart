import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File _image;
  final picker = ImagePicker();
  void getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    var ref;
    var url;
    if (pickedFile != null) {
      print(pickedFile.path);
      _image = File(pickedFile.path);

      ref = FirebaseStorage.instance
          .ref()
          .child('chat_image')
          .child(pickedFile.path);
      await ref.putFile(_image).whenComplete(() => null);
      url = await ref.getDownloadURL();
    }
    setState(() {
      if (pickedFile != null) {
        final userID = FirebaseAuth.instance.currentUser;
        final hour = DateTime.now().hour % 12;
        final day = DateTime.now().hour / 12;
        final minute = DateTime.now().minute;
        final hourString = hour.toString();
        final minuteString = minute.toString();
        final resultTime =
            hourString + ":" + minuteString + (day == 0 ? " am" : "pm");
        FirebaseFirestore.instance.collection('chat').add({
          "text": null,
          "resultTime": resultTime,
          'isLiked': false,
          'unread': true,
          'createdTime': Timestamp.now(),
          'userID': userID.uid,
          'imageUrl': url
        });
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08),
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
                  icon: Icon(Icons.add_photo_alternate_outlined),
                  iconSize: 50.0,
                  color: Color(0xFF736464),
                  onPressed: getImage),
              top: 3.0,
              left: 3.0),
        ],
      ),
    );
  }
}
