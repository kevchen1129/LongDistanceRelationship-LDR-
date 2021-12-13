import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:loginPage/pages/main.dart';

import 'firebase_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}


class ResetPasswordPageState extends State<ResetPasswordPage> {
  double height=0.0, width=0.0;
  TextEditingController etResetEmail=new TextEditingController();
  bool resetEmail_Filled=false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;




  Widget build(BuildContext context){
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ResetPasswordPage();
  }
  Widget ResetPasswordPage(){
    log(this.height.toString()+" , "+this.width.toString());
    return Scaffold(resizeToAvoidBottomInset: false,
      body:  Column(children: 
        [Container(alignment: Alignment.center,padding: EdgeInsets.only(top: 0.3*height),child: Text(" Enter Your Email\nto Reset Password", style: TextStyle(fontSize: 0.035*height, fontWeight: FontWeight.bold),),),
        Container(width: width*0.62,padding: EdgeInsets.only(top: 0.07*height),
            child: TextFormField(controller: etResetEmail,
            onChanged:(context){
              setState(() {
                //resetEmail_Filled=etResetEmail.text.length!=0;
              });
            }
            ,decoration: InputDecoration(hintText: 'Email',hintStyle: TextStyle(fontWeight: FontWeight.bold)),),),
        ResetPasswordButton(),
        ],),);
  }
  
  Widget ResetPasswordButton(){
    return new Container(padding: EdgeInsets.only(top: height/4),child:Container(width: width/2,height: height/15,child: RaisedButton(color: resetEmail_Filled? Colors.red : Colors.grey,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height/40)),
      onPressed: () async {
        final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://signuppages.page.link',
        link: Uri.parse('https://signuppages.page.link/QYkB'),
        androidParameters: AndroidParameters(
          packageName: "com.example.SignUpPages",
          minimumVersion: 0,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
        iosParameters: IosParameters(
          bundleId: 'com.example.SignUpPages',
          minimumVersion: '0',
        ),
        );
        Uri url=await parameters.buildUrl();
        //print("url = "+url.toString());
        
        _firebaseAuth.sendPasswordResetEmail(email: etResetEmail.text,
        actionCodeSettings: ActionCodeSettings(
            url: "https://signuppages.page.link/QYkB",
            android: {
              'packageName': "com.example.SignUpPages",
              'installApp': true,
              //'minimumVersion': '5'
            },
            iOS: {
              'bundleId': "com.example.SignUpPages",
            },
            handleCodeInApp: true,
            dynamicLinkDomain: "signuppages.page.link"
          )
        );

        log("new firebase email sent");
        setState(() {
  
        });
      }, child: Text("Reset Password", style: TextStyle(color: Colors.white, fontSize: 15),))
    )); 
  }
}

class NewPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewPasswordPageState();
}

class NewPasswordPageState extends State {
  TextEditingController etNewPassword=new TextEditingController();
  Auth auth=new Auth();
  double height, width=0.0;

  bool resetEmail_Filled=false;
  bool newPassword_Filled=false;

  Widget build(BuildContext context){
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    return ResetNewPasswordPage();
  }

  Widget ResetNewPasswordPage(){
    return Scaffold(resizeToAvoidBottomInset: false,
      body:  Column(mainAxisAlignment: MainAxisAlignment.center,children: 
        [Container(alignment: Alignment.center,padding: EdgeInsets.only(top: 0.2*height),child: Text("Reset New Password", style: TextStyle(fontSize: 0.04*height, fontWeight: FontWeight.bold),),),
        Container(width: width*0.62,padding: EdgeInsets.only(top: 0.05*height),
            child: TextFormField(controller: etNewPassword,
            onChanged:(context){
              setState(() {
                //newPassword_Filled=etNewPassword.text.length!=0;
              });
            }
            ,decoration: InputDecoration(hintText: 'Enter your new Password',hintStyle: TextStyle(fontWeight: FontWeight.bold)),),),
        SaveNewPasswordButton()
        ],),);
  }

  Widget SaveNewPasswordButton(){
    return new Container(padding: EdgeInsets.only(top: height/4),child:Container(width: width/2,height: height/15,child: RaisedButton(color: resetEmail_Filled? Colors.red : Colors.grey,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height/40)),
      onPressed: () async {
        setState(() {
          //to be filled in
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context){
                return AuthPage();
              }));
  
        });
      }, child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 15),))
    )); 
  }
}