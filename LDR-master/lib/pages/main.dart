//import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:loginPage/chat/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'ConnectPage.dart';
import 'InfoStepPage.dart';
import 'ResetPasswordPage.dart';
import 'firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Color(0xFFE1D5CB),
          accentColor: Color(0xFFDFB8B7),
        ),
        //home: SignUpPage(),
        home: AuthPage(),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          //default: should be _mainScreen()
          '/resetPassword': (BuildContext context) => NewPasswordPage(),
        });
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  double height = 0.0;
  double width = 0.0;

  double signUp_font = 23.0;
  double login_font = 23.0;
  Color signUp_color = Colors.white;
  Color login_color = Colors.grey;

  //warningText=> warning text for signup, warningText2=> warning text for login
  String warningText;
  String warningText2;
  //Color login_button_color=Colors.grey;

  bool inSignUpPage = true;
  bool hasAgreed = false;

  bool signUp_filled = false;
  bool login_filled = false;
  bool info_filled = false;

  TextEditingController etEmail = new TextEditingController();
  TextEditingController etPassword = new TextEditingController();
  TextEditingController etEmail2 = new TextEditingController();
  TextEditingController etPassword2 = new TextEditingController();

  final SignUpFormKey = GlobalKey<FormState>();

  TextEditingController etNickname = new TextEditingController();
  TextEditingController etBirth = new TextEditingController();
  TextEditingController etLocation = new TextEditingController();

  TextEditingController etNewPassword = new TextEditingController();

  Auth auth = new Auth();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final databaseReference = FirebaseFirestore.instance;

  bool newPassword_Filled = false;

  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    //return SignUpPage();
    /*return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * (2.0 / 7)), child: _appBar()),
      body: Material(child: inSignUpPage ? SignUpPage() : LoginPage()),
      resizeToAvoidBottomInset: false,
    ); */
    return ChatScreen();
  }

  void initState() {
    super.initState();
    initDynamicLinks();
    initPref();
  }

  initPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  String oobCode;
  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      final Uri deepLink = data?.link;
      log(deepLink.queryParametersAll.keys.toString());
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      log("dynamic link clicked");
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        log(deepLink.toString() + " , " + deepLink.path);
        //oobCode=deepLink.queryParameters["code"];
        //log("code = "+oobCode);
        if (deepLink.path == "/QYkB") {
          Navigator.pushNamed(context, "/resetPassword");
          log(deepLink.queryParameters.keys.toString());
          String oobCode = deepLink.queryParameters["oobCode"];
          log(oobCode);
          //_firebaseAuth.checkActionCode(oobCode);
          _firebaseAuth.confirmPasswordReset(
              code: oobCode, newPassword: "Brian87");

          log("navigate to another page");
        } else {
          log("navigate to home page");
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Widget SignUpPage() {
    log("screen height = " + height.toString());
    log("screen width = " + width.toString());
    //appBar: 200, Container: 500
    return Container(
      alignment: Alignment.center,
      height: height * (4.5 / 7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width * 0.62,
            padding: EdgeInsets.only(top: 0),
            child: TextFormField(
              controller: etEmail,
              onChanged: (context) {
                setState(() {
                  signUp_filled = checkSignUpfilled();
                });
                //log("signUp email filled = "+signUp_filled.toString());
              },
              decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: height / 20),
              width: width * 0.62,
              child: TextFormField(
                obscureText: true,
                controller: etPassword,
                onChanged: (context) {
                  setState(() {
                    signUp_filled = checkSignUpfilled();
                    if (signUp_filled) {
                      log("Everything is filled");
                    }
                  });
                },
                decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold)),
              )),
          checkboxTile(),
          Text(
            warningText == null ? "" : warningText,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          CreateAccountButton()
        ],
      ),
    );
  }

  bool checkSignUpfilled() {
    return etEmail.text.length != 0 && etPassword.text.length != 0 && hasAgreed;
  }

  Widget LoginPage() {
    return Container(
        alignment: Alignment.topCenter,
        height: height * 4.5 / 7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width * 0.62,
              padding: EdgeInsets.only(top: 0),
              child: TextFormField(
                controller: etEmail2,
                onChanged: (context) {
                  setState(() {
                    //to be revised
                    login_filled = checkLoginFilled();
                  });
                },
                decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              width: width * 0.62,
              padding: EdgeInsets.only(top: height / 30),
              child: TextFormField(
                obscureText: true,
                controller: etPassword2,
                onChanged: (context) {
                  setState(() {
                    //to be revised
                    login_filled = checkLoginFilled();
                  });
                },
                decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            ForgotPasswordButton(),
            Container(
              child: Text(
                warningText2 == null ? "" : warningText2,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              padding: EdgeInsets.only(top: height / 20),
            ),
            LoginAccountButton(),
          ],
        ));
  }

  Widget _appBar() {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown[900],
        title: Container(
            alignment: Alignment.center, child: Text("Icon/Name/Illustration")),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(height * (1.25 / 7)),
            child: Container(
                margin: EdgeInsets.only(bottom: height * 0.007),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [SignUpButton(), LoginButton()],
                ))));
  }

  Widget ForgotPasswordButton() {
    return new Container(
        padding: EdgeInsets.only(top: 10, left: 150),
        child: FlatButton(
            child: Text(
              "Forgot Password?",
              style: TextStyle(fontSize: 15, color: Colors.grey[500]),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return ResetPasswordPage();
              }));
            }));
  }

  Widget CreateAccountButton() {
    return new Container(
        padding: EdgeInsets.only(top: height / 15),
        child: Container(
            width: width / 2,
            height: height / 15,
            child: RaisedButton(
                color: signUp_filled ? Colors.red : Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(height / 40)),
                onPressed: () async {
                  log("create account pressed");
                  User currUser;
                  UserCredential res;
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: etEmail.text, password: etPassword.text)
                      .catchError((onError) {
                    log("ahah");
                    log(onError.toString());
                    setState(() {
                      warningText = onError.code;
                    });
                  }).then((value) {
                    log("value = " + value.toString());
                    res = value;
                    if (res != null) {
                      currUser = res.user;
                    }
                    setState(() {
                      if (currUser != null && hasAgreed) {
                        log("all blocks filled");
                        log("current user = " + currUser.toString());
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return InfoStepPage(currUser);
                        }));
                      }
                    });
                    log("in res = " + res.toString());
                  });
                },
                child: Text(
                  "Create an account",
                  style: TextStyle(color: Colors.white, fontSize: height / 40),
                ))));
  }

  Widget LoginAccountButton() {
    // Color of button to be revised

    return new Container(
        padding: EdgeInsets.only(top: height / 10),
        child: Container(
            width: width / 2,
            height: height / 15,
            child: RaisedButton(
                color: login_filled ? Colors.red : Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(height / 40)),
                onPressed: () {
                  User currUser;
                  UserCredential res;
                  log("login button pressed");
                  _firebaseAuth
                      .signInWithEmailAndPassword(
                          email: etEmail2.text, password: etPassword2.text)
                      .catchError((onError) {
                    setState(() {
                      warningText2 = onError.code;
                      log("warning text = " + warningText2.toString());
                    });
                  }).then((value) async {
                    log("value = " + value.toString());
                    res = value;
                    if (res != null) {
                      currUser = res.user;
                      String uid = currUser.uid;
                      log("user uid = " + uid.toString());
                      Map<String, dynamic> self_map = (await databaseReference
                              .collection("Users")
                              .doc(uid)
                              .get())
                          .data();
                      prefs.setString("self_uid", uid);
                      prefs.setString("nickname", self_map["nickname"]);
                      prefs.setString("birthday", self_map["birthday"]);
                      prefs.setString("location", self_map["location"]);
                      Map<String, dynamic> couple_map = (await databaseReference
                              .collection("Users")
                              .doc(self_map["codeReceiver"])
                              .get())
                          .data();
                      prefs.setString("couple_uid", self_map["codeReceiver"]);
                      prefs.setString(
                          "couple_nickname", couple_map["nickname"]);
                      prefs.setString(
                          "couple_birthday", couple_map["birthday"]);
                      prefs.setString(
                          "couple_location", couple_map["location"]);
                      log(prefs.getString("self_uid"));
                      log(prefs.getString("nickname"));
                      log(prefs.getString("birthday"));
                      log(prefs.getString("location"));
                      log(prefs.getString("couple_uid"));
                      log(prefs.getString("couple_nickname"));
                      log(prefs.getString("couple_birthday"));
                      log(prefs.getString("couple_location"));
                    }
                    setState(() {
                      if (currUser != null) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MyHomePage();
                        }));
                      }
                    });
                  });
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: height / 40),
                ))));
  }

  bool checkLoginFilled() {
    return etEmail2.text.length != 0 && etPassword2.text.length != 0;
  }

  bool checkInfoFilled() {
    return etNickname.text.length != 0 &&
        etBirth.text.length != 0 &&
        etLocation.text.length != 0;
  }

  Widget SignUpButton() {
    return new FlatButton(
      onPressed: () {
        log("signUp mounted = " + this.mounted.toString());
        if (this.mounted) {
          setState(() {
            log("signUp");
            if (!inSignUpPage) {
              signUp_font = 0.045 * height;
              login_font = 0.035 * height;
              signUp_color = Colors.white;
              login_color = Colors.grey;
              inSignUpPage = true;
              //return SignUpPage();
              /*Navigator.of(context).pop(
                MaterialPageRoute(builder: (BuildContext context){
                  return SignUpPage();
                }));*/
            }
          });
        }
      },
      child: Text(
        "Sign Up",
        style: TextStyle(fontSize: signUp_font, color: signUp_color),
      ),
    );
  }

  Widget LoginButton() {
    return new FlatButton(
      onPressed: () {
        setState(() {
          log("login");
          if (inSignUpPage) {
            signUp_font = 0.035 * height;
            login_font = 0.045 * height;
            signUp_color = Colors.grey;
            login_color = Colors.white;
            inSignUpPage = false;
            //return LoginPage();
            /*Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context){
                return LoginPage();
              }));*/
          }
        });
      },
      child: Text(
        "Login",
        style: TextStyle(fontSize: login_font, color: login_color),
      ),
    );
  }

  Widget checkboxTile() {
    return Container(
        padding: EdgeInsets.only(left: width * (0.17), top: height / 40),
        child: Row(children: [
          Container(
              width: width / 13,
              child: Checkbox(
                  value: hasAgreed,
                  onChanged: (newValue) {
                    setState(() {
                      hasAgreed = !hasAgreed;
                      signUp_filled = checkSignUpfilled();
                      log("agreed = " + hasAgreed.toString());
                    });
                  })),
          Text(
            "I agree to the Terms and Conditions",
            style: TextStyle(fontSize: width / 30, color: Colors.grey[500]),
          ),
        ]));
  }

  ////////////////////////////

}
