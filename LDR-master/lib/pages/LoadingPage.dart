import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginPage/pages/ChooseDatePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'ConnectPage.dart';




class LoadingPage extends StatefulWidget {
  
  User user;
  int countdown;
  LoadingPage(User user, int countdown){
    this.user=user;
    this.countdown=countdown;
  }
  @override
  State<StatefulWidget> createState() => LoadingPageState(user, countdown);
}

class LoadingPageState extends State<LoadingPage>{
  User currUser;
  Query userQuery;
  SharedPreferences prefs;
  int countdown;
  Timer timer;
         
  LoadingPageState(User user, int countdown){
    log("user = "+user.toString());
    currUser=user;
    this.countdown=countdown;
  }
  
  Widget initState(){
    super.initState();
    initPref();
    userQuery = FirebaseFirestore.instance
          .collection('Users').where("codeSender", isEqualTo: currUser.uid);
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      listenToChanges();
      countdown--;
      log("countdown = "+countdown.toString());
      if(countdown==0){
        Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
            return ConnectPage(currUser);
          }));
      }
    });

    

  }

  initPref() async {
    prefs=await SharedPreferences.getInstance();
  }

  

  void dispose(){
    super.dispose();
    timer.cancel();

  }


  Widget build(BuildContext context){
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              alignment: Alignment.center,
              child: Text(
                "Waiting for your partner ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              )),
          Container(
              alignment: Alignment.center,
              child: Text(
                "to connect... ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              )),
        ]));
  }
  void listenToChanges(){
    log(userQuery.toString());
    
    userQuery.snapshots().listen((data) async {
      if(data.docs[0].get("codeReceiver")!="null"){
        String couple_uid=data.docs[0].get("codeReceiver");
        prefs.setString("couple_uid", couple_uid);
        Map<String, dynamic> couple_map=(await FirebaseFirestore.instance
          .collection('Users').doc(couple_uid).get()).data();
        prefs.setString("couple_uid", couple_uid);
        prefs.setString("couple_nickname", couple_map["nickname"]);
        prefs.setString("couple_birthday", couple_map["birthday"]);
        prefs.setString("couple_location", couple_map["location"]);
        

        
        //log("otherQuery list = "+ otherQuery.snapshots().toList().get(0).toString());
        /*prefs.setString("couple_nickname", data.docs[0].data()["nickname"]);
          prefs.setString("couple_birth", value.docs[0].data()["birthday"]);
          prefs.setString("couple_location", value.docs[0].data()["location"]);*/
        setState(() {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
            return ChooseDatePage();
          }));
        });
      }
          });
  }


}