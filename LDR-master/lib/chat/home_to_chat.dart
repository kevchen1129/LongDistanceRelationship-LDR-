import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';
import 'model/user_model.dart';

class HomeToChat extends StatelessWidget {
  SharedPreferences prefs;
  final uid;
  HomeToChat({this.uid});

  void initState(){
    initPref();
  }
  initPref() async {
    prefs=await SharedPreferences.getInstance();
  }

  Future<void> _getPrefs() async{
  prefs = await SharedPreferences.getInstance();
  }
 
  @override
  Widget build(BuildContext context) {
    print("I am poopoo " + uid + "9999999");
    final users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder(
        future: _getPrefs(),
        builder: (BuildContext context,
             docSnapshot) {
            if(docSnapshot.connectionState==ConnectionState.done){
              final pairID = prefs.getString("couple_uid");
            //print(data.toString());
            print("niggas " + pairID);
            if (pairID == "") {
              return Text("no firend, pair up with someone");
            } else {
              final firstName = prefs.getString("couple_nickname");
              final pairRoomID = (uid.compareTo(pairID) > 0)
                ? uid + "+" + pairID
                : pairID + "+" + uid;
              final Users user_1 =
                        Users(id: pairID, name: firstName, pair: uid);
              return ChatScreen(user: user_1, pairChatID: pairRoomID);
            }
          }
            return Container();
            
          /*if (docSnapshot.connectionState == ConnectionState.done) {
            
            print("it comes here man");

            //Map<String, dynamic> data = docSnapshot.data.data();
            
              /*return StreamBuilder(
                  stream: users.doc(pairID).snapshots(),
                  builder: (context, pairSnapshot) {
                    if (docSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container();
                    }
                    final docData2 = pairSnapshot.data;
                    final firstName = prefs.getString("couple_nickname");
                    final pairRoomID = (uid.compareTo(pairID) > 0)
                        ? uid + "+" + pairID
                        : pairID + "+" + uid;
                    final Users user_1 =
                        Users(id: pairID, name: firstName, pair: uid);
                    return ChatScreen(user: user_1, pairChatID: pairRoomID);
                  });*/
            }
          }*/
        });
  }
}
