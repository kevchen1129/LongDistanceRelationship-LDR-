import 'dart:async';
import 'dart:developer';
import 'dart:math' as Math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';



abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future <User> signUp(String email, String password);
  //Future<void> signOut();
}

class Auth implements BaseAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var rand=new Math.Random();

  FirebaseAuth getFirebaseAuth(){
    return _firebaseAuth;
  }


  

  @override
  Future <User> signUp(String email, String password) async {
    User user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)).user;
        log(_firebaseAuth.currentUser.toString());
        //await user.sendEmailVerification();
        //_firebaseAuth.sendPasswordResetEmail(email: email);
    try {
      //await user.sendEmailVerification();
      return user;
    } catch (e) {
      log("An error occured while trying to send email  verification");
      print(e.message);
    }
  }

  @override
  Future<String> signIn(String email, String password) async {
    User user;
    try{
      user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user;
    }catch(e){
      return e.toString();
    }
    
    return user.uid;
  }
  Future<String> updatePassword(String email, String password) async {
    return null;
  }

  

  @override
  Future<void> resetPassword(String email, String password) async {
    try{
      //Admin.FirebaseAdmin admin= Admin.FirebaseAdmin.instance;
      User user = (await _firebaseAuth.signInWithEmailAndPassword(
      email: email, password: password)).user;
      String url = "http://www.example.com/verify?uid=" + user.uid;
      //ActionCodeSettings actionCodeSettings=ActionCodeSettings.newBuilder;
      //Admin.Auth().generatePasswordResetLink(email, actionCodeSettings);

    if (user.emailVerified) return user.uid;
    }catch(e){
      return e.toString();
    }

    //_firebaseAuth.currentUser.updatePassword(password);
    //await _firebaseAuth.sendPasswordResetEmail(email: email);
    

  }
  

  Future<String> sendVerificationCode() async {
    String id=_firebaseAuth.currentUser.uid;
    int temp_index=rand.nextInt(id.length);
    
    //_firebaseAuth.applyActionCode(id.substring(temp_index, (temp_index+6)%id.length));
    //_firebaseAuth.checkActionCode("haaaaa");
    //_firebaseAuth.applyActionCode("haaaaa");
    _firebaseAuth.currentUser.sendEmailVerification();
  }

   
  
}
