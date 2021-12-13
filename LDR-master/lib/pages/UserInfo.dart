//import 'package:firebase_auth/firebase_auth.dart';


class UserInfo{
  String email;
  String password;
  String nickname;
  String birthday;
  String location;


  UserInfo(String email, String password){
    this.email=email;
    this.password=password;
  }

  updateNickname(String nickname){
    this.nickname=nickname;
  }

  updateBirthday(String birthday){
    this.birthday=birthday;
  }

  updateLocation(String location){
    this.location=location;
  }

  
  /*createAccount(){
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: this.email, password: this.password);
  }*/

  


}