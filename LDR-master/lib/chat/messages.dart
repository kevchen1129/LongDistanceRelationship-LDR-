import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final pairChatId;
  Messages({this.pairChatId});
  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .doc(pairChatId)
            .collection('chatroom')
            .orderBy('createdTime', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final chatDocs = chatSnapshot.data.documents;
          return ListView.builder(
              // physics: BouncingScrollPhysics(),
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) {
                final text = chatDocs[index]['text'];
                final time = chatDocs[index]['resultTime'];
                final isMe =
                    (user.uid == chatDocs[index]['userID']) ? true : false;
                final imageUrl = chatDocs[index]['imageUrl'];
                return MessageBubble(
                    messageText: text,
                    messageTime: time,
                    isMe: isMe,
                    imageUrl: imageUrl);
              });
        });
  }
}
