import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ConnectPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:latlng/latlng.dart';

import 'package:geocoding/geocoding.dart' as Geocoding;

import 'package:shared_preferences/shared_preferences.dart';






class InfoStepPage extends StatefulWidget {
  User user;
  InfoStepPage(User user){
    this.user=user;
  }
  @override
  State<StatefulWidget> createState() => InfoStepPageState(user);
}

class InfoStepPageState extends State<InfoStepPage>{
  User currUser;
  File _image;
  SharedPreferences prefs;
  
  InfoStepPageState(User user){
    log("user = "+user.toString());
    currUser=user;
  }

  double height,width=0.0;
  bool info_filled=false;

  TextEditingController etNickname=new TextEditingController();
  TextEditingController etBirth=new TextEditingController();
  TextEditingController etLocation=new TextEditingController();

  final databaseReference = FirebaseFirestore.instance;
  String uid;

  LatLng _userLocation = LatLng(23.5, -122);
  Geocoding.Placemark _userPlace=Geocoding.Placemark();

  Future<void> initState() {
    initPref();
    getUserLocation();
  }
  initPref() async {
    prefs=await SharedPreferences.getInstance();
    log("pref first keys = "+prefs.getKeys().toString());
  }

  Widget build(BuildContext context) {
    log("currUser is null ="+currUser.toString());
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    return InfoStepPage();
  }
  Widget InfoStepPage(){
    //height: 1300
    log(height.toString()+" , "+width.toString());
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        height: height,
        child: Column(children: [
          Container(alignment: Alignment.centerLeft, width: width, padding: EdgeInsets.only(top:height/10, left:width/5, bottom: height/40),child: Row(children: [Text("Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],)),
          Container(
            width: height/7,height:height/7,
            margin: EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: _image!=null? FileImage(File(_image.path)):AssetImage('assets/images/profile_pic_1.png'),
              fit: BoxFit.fill,),
            ),
          ),
          AddPhotoButton(),
          Container(width: width*0.6,height: height/10,padding: EdgeInsets.only(top: height/15),
            child: TextFormField(controller: etNickname,
            onChanged:(context){
              setState(() {
                //to be revised
                info_filled=checkInfoFilled();
                log("info is filled = "+info_filled.toString());
              });
            }
            ,decoration: InputDecoration(hintText: 'Nickname', hintStyle: TextStyle(fontSize: height/40,fontWeight: FontWeight.bold)),),),
          Container(width: width*0.6,height: height/10,padding: EdgeInsets.only(top: height/30),
            child: TextFormField(controller: etBirth,
            onChanged:(context){
              setState(() {
                //to be revised
                info_filled=checkInfoFilled();
                log("info is filled = "+info_filled.toString());
              });
            }
            ,decoration: InputDecoration(hintText: 'Birthday', hintStyle: TextStyle(fontSize: height/40,fontWeight: FontWeight.bold)),),),
          Container(width: width*0.6,height: height/10,padding: EdgeInsets.only(top: height/30),
            child: TextFormField(controller: etLocation,
            onChanged:(context){
              setState(() {
                //to be revised
                info_filled=checkInfoFilled();
                log("info is filled = "+info_filled.toString());
              });
            }
            ,decoration: InputDecoration(hintText: 'Location', hintStyle: TextStyle(fontSize: height/40,fontWeight: FontWeight.bold)),),),
          InfoPageNextButton(),
        ],),
        )
    );
  }

  _imgFromCamera() async {
   PickedFile pImage = await ImagePicker().getImage(
    source: ImageSource.camera, imageQuality: 50
  );

  setState(() {
    _image = File(pImage.path);
  });
}

_imgFromGallery() async {
  PickedFile pImage = await  ImagePicker().getImage(
      source: ImageSource.gallery, imageQuality: 50
  );

  setState(() {
    _image = File(pImage.path);
  });
}

void _showPicker(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
}

  void createInfoRecord() async {
    uid = FirebaseAuth.instance.currentUser.uid.toString();
    log("uuid = "+ uid);
  await databaseReference.collection("Users")
      .doc(uid)
      .update({
        'nickname': this.etNickname.text,
        'birthday': this.etBirth.text,
        'location': this.etLocation.text, 
        'self_uid':this.currUser.uid,
      });
  }

  Widget AddPhotoButton(){
    return new Container(alignment: Alignment.center,
      child: FlatButton(child: Text("Add Photo",style: TextStyle(fontSize: width/30, color: Colors.grey[500])),
        onPressed: (){
          _showPicker(context);
        setState(() {
          //add photo to profile picture
        });
      },)
    );
  }

  Widget InfoPageNextButton(){
    return new Container(padding: EdgeInsets.only(top: height/10),child:Container(width: width/2,height: height/15,child: RaisedButton(color: info_filled? Colors.red : Colors.grey,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height/40)),
      onPressed: () async {
        log("info filled = "+info_filled.toString());
        uid = FirebaseAuth.instance.currentUser.uid.toString();
        await databaseReference.collection("Users").doc(uid)
          .set({
            'nickname': this.etNickname.text,
            'birthday': this.etBirth.text,
            'location': this.etLocation.text, 
          });
        setState(() {
          if(etNickname.text.length==0 || etBirth.text.length==0 
          || etLocation.text.length==0){
            log("textforms not filled");
          }else{
            //signup_dict[curr_user_email]+=[etNickname.text, etBirth.text, etLocation.text];
            //log(signup_dict.toString());
            //createInfoRecord();
            prefs.setString("self_uid", currUser.uid);
            prefs.setString("nickname", etNickname.text);
            prefs.setString("birthday", etBirth.text);
            prefs.setString("location", etLocation.text);

            
            log("pref initialized keys = "+prefs.getKeys().toString());
             Navigator.of(context).pushReplacement(
               MaterialPageRoute(builder: (BuildContext context){
                return ConnectPage(currUser);
             }));
          }
        });
      }, child: Text("Next Step", style: TextStyle(color: Colors.white, fontSize: 15),))
    ));
  }
  bool checkInfoFilled(){
    return etNickname.text.length!=0 && etBirth.text.length!=0 && etLocation.text.length!=0;
  }

  Future<LatLng> getUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }
    log("service enabled = " + _serviceEnabled.toString());

    _permissionGranted = await location.hasPermission();
    log("permission status = " + _permissionGranted.toString());
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    

    

    location.getLocation().then((value) async {
      //Position pos= await Geolocator.getCurrentPosition();
      double longitude=value.longitude;
      double latitude=value.latitude;
      Geocoding.Placemark mark = (await Geocoding.placemarkFromCoordinates(latitude,longitude))[0];
      setState(() {
          _userPlace=mark;
          if(_userPlace!=null){
            etLocation.text=mark.administrativeArea+" , "+mark.country;
          }
          //_userLocation = LatLng(value.latitude, value.longitude);
      });
    });

  }
}