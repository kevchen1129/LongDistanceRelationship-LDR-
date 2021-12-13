import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginPage/pages/ChooseDatePage.dart';
import 'package:mailer2/mailer.dart';
import 'dart:developer';

import 'LoadingPage.dart';
import 'firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';


class ConnectPage extends StatefulWidget {
  User user;
  ConnectPage(User user) {
    this.user = user;
  }
  @override
  State<StatefulWidget> createState() => ConnectPageState(user);
}

class ConnectPageState extends State<ConnectPage> {
  User currUser;
  ConnectPageState(User user) {
    currUser = user;
  }

  double height = 0.0;
  double width = 0.0;
  bool codeEntered = false;

  Auth auth = new Auth();

  TextEditingController etCode = new TextEditingController();

  //final DatabaseReference entryRef = FirebaseDatabase.instance.reference();
  String pairCode = null;
  String selfCode = null;
  String pairEmail = null;

  Timer timer;
  DateTime submitCodeTime;
  int countdown = 120;
  bool waitingSubmission = false;
  bool codeSent = false;
  bool singlePairing = false;

  SharedPreferences prefs;

  @override
  Future<void> initState() {
    super.initState();
    initPref();
    
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      log("t value = " + t.tick.toString());
      updateTime();
      getData();
      if (countdown == 0 && waitingSubmission) {
        log("failed to connect within 60 seconds");
        resetCode();
        waitingSubmission = false;
        codeSent = false;
        singlePairing = false;
        if (singlePairing) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
            return ConnectPage();
          }));
        }

        //entryRef.child(selfCode).remove();
        countdown = 120;
      }
      if (t.tick == 30) {
        log("t = 30");
        //resetCode();
        //createRecord();

      }
    });
    submitCodeTime = DateTime.now();

    //log("updated every second");
    //final FirebaseDatabase database=FirebaseDatabase(app:app);
  }

  void dispose() {
    super.dispose();
    timer.cancel();

  }
  initPref() async {
    prefs=await SharedPreferences.getInstance();
  }

  final databaseReference = FirebaseFirestore.instance;
  String uid;
  void createRecord() async {
    currUser = FirebaseAuth.instance.currentUser;
    uid = currUser.uid.toString();
    log("uuid = " + uid);
    await databaseReference.collection("Users").doc(uid).update({
      'code': selfCode,
      'codeReceiver': 'null',
      'codeSender': uid,
    });
  }

  void resetCode() {
    try {
      databaseReference
          .collection('Users')
          .doc(uid)
          .update({'code': FieldValue.delete()});
      log("database changed");
    } catch (e) {
      print(e.toString());
    }
  }

  QuerySnapshot temp;
  DocumentSnapshot selfSnap;

  void getData() {
    Future<QuerySnapshot> snapshot =
        databaseReference.collection("Users").get().then((value) {
      this.temp = value;
      temp.docs.forEach((result) {
        //print(result.data());
      });
      //log(this.snap.docs.toSet().toString());
    });
    databaseReference
        .collection("Users")
        .doc(this.uid)
        .get()
        .then((value) => this.selfSnap = value);
  }

  int updateTime() {
    setState(() {
      if (countdown > 0 && codeSent & waitingSubmission) {
        countdown = 60 - DateTime.now().difference(submitCodeTime).inSeconds;
        //countdown=3;
        //submitCodeTime=DateTime.now();
      }

      return countdown;
    });
  }

  Widget build(BuildContext context) {
    //log(currUser.email);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ConnectPage();
  }

  Widget ConnectPage() {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            alignment: Alignment.center,
            height: height,
            child: Column(
              children: [
                Container(
                    width: width,
                    padding:
                        EdgeInsets.only(top: height / 7.5, left: width / 8),
                    child: Text("Connect with your partner!",
                        style: TextStyle(
                            fontSize: height / 30,
                            fontWeight: FontWeight.bold))),
                Container(
                    width: width / 3,
                    height: height / 5,
                    padding: EdgeInsets.only(top: height / 15),
                    child: FittedBox(
                        child: Image(
                            image: AssetImage(
                                'assets/images/Connect_image.png')))),
                SendCodeButton(),
                Container(
                    child: Text(countdown < 30 && countdown != 0
                        ? "Resend in : " + countdown.toString() + " secs"
                        : "")),
                Container(
                  width: width / 2,
                  padding: EdgeInsets.only(top: height / 13.5),
                  child: TextFormField(
                      controller: etCode,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Partner\'s code',
                        hintStyle: TextStyle(
                            fontSize: height / 45.5,
                            fontWeight: FontWeight.bold),
                      ),
                      onChanged: (context) {
                        setState(() {
                          //to be revised
                          codeEntered = etCode.text.length != 0;
                        });
                      }),
                ),
                ConnectButton(),
              ],
            )));
  }

  Widget SendCodeButton() {
    return new Container(
        padding: EdgeInsets.only(top: height / 20),
        child: Container(
            width: width / 2,
            height: height / 17,
            child: RaisedButton(
                color: !codeSent ? Colors.red : Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () async {
                      log("connectPage pref keys = "+prefs.getKeys().toString());

                  waitingSubmission = true;
                  submitCodeTime = DateTime.now();
                  //auth.signUp("Brian96086@gmail.com", "testtest");

                  selfCode = randomAlphaNumeric(8);
                  //gmail username and password removed
                  //to be added and encrypted when LDR email is set
                  var options = new GmailSmtpOptions()
                    ..username = 'ldrapp2020@gmail.com'
                    ..password = 'corona948720LD';

                  var transport = new SmtpTransport(options);

                  var envelope = new Envelope()
                    ..from = 'ldrapp2020@gmail.com'
                    ..fromName = 'LDR'
                    ..recipients = [currUser.email]
                    ..subject = 'Code for pairing'
                    ..text = 'Here goes your body message : ' + selfCode;
                  transport.send(envelope);

                  createRecord();
                  log("record created");
                  codeSent = true;

                  //final smtpServer = gmail("brian96086@gmail.com", "Wang4750");

                  setState(() {
                    //var entry = new Entry(selfCode, currUser.email, "null");
                    //entry.setId(saveEntry(entry));
                  });
                },
                child: Text(
                  "Send My Code",
                  style:
                      TextStyle(color: Colors.white, fontSize: height / 45.5),
                ))));
  }

  //places your uid into the codeSender's receiver field
  Future<bool> updateCodeReceiverStatus() async {
    Query q = databaseReference
        .collection("Users")
        .where("code", isEqualTo: etCode.text);
    QuerySnapshot qShot=await q.get(GetOptions(source: Source.cache));
    log("temp = "+temp.docs.length.toString());
    bool empty=qShot.docs.length==0;
    if (empty) {
      log("pairing unsuccessful");
      return false;
    }
    q.get().then((value) {
      String otherUid = value.docs[0].data()["codeSender"];
      databaseReference
          .collection("Users")
          .doc(otherUid)
          .update({"codeReceiver": this.uid});
      //value.docs[0].data()["codeReceiver"]=this.uid;
      //log(value.docs[0].data().toString());
      log("one-way pairing successful=true");
    });

    return true;
  }

  Widget ConnectButton() {
    return new Container(
        padding: EdgeInsets.only(top: height / 6),
        child: Container(
            width: width / 2,
            height: height / 17,
            child: RaisedButton(
                color:
                    codeEntered && waitingSubmission ? Colors.red : Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(height / 40)),
                onPressed: () {
                  updateConnectStatus();
                },
                child: Text(
                  "Connect",
                  style:
                      TextStyle(color: Colors.white, fontSize: height / 45.5),
                ))));
  }

  Future<void> updateConnectStatus() async {
    if (codeEntered && selfSnap.data()["codeReceiver"] != "null") {
      log("self codeReceiver = " + selfSnap.data()["codeReceiver"]);
      log("selfCode not inputed by others");
      Query other = databaseReference
          .collection("Users")
          .where("code", isEqualTo: etCode.text);

      other.get().then((value) async {
        log(value.docs[0].data().toString());
        if (value.docs[0].data()["codeSender"] ==
            selfSnap.data()["codeReceiver"]) {
          //value.docs[0].data()["codeReceiver"]=this.uid;
          await databaseReference
              .collection("Users")
              .doc(value.docs[0].data()["codeSender"])
              .update({'codeReceiver': currUser.uid});
          prefs.setString("couple_uid", selfSnap.data()["codeReceiver"]);
          prefs.setString("couple_nickname", value.docs[0].data()["nickname"]);
          prefs.setString("couple_birth", value.docs[0].data()["birthday"]);
          prefs.setString("couple_location", value.docs[0].data()["location"]);
          log(prefs.toString());
          log("connection successful");
          setState(() {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
              return ChooseDatePage();
            }));
          });
          waitingSubmission = false;
        }
      });
    }
    bool result = false;
    if (codeEntered && selfSnap.data()["codeReceiver"] == "null") {
      result = await updateCodeReceiverStatus();
      log("update result = " + result.toString());
    }

    setState(() {
      log("trying to connect");
      if (result) {
        
        singlePairing = true;
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return LoadingPage(currUser, countdown);
        }));
      }
    });
  }
  /*
  Widget LoadingPage() {
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
  }*/
}
