import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../homepage.dart';

class ChooseDatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChooseDateState();
}

class ChooseDateState extends State<ChooseDatePage> {
  double height=0.0, width=0.0;
  bool lookPressed=false;
  bool rememberPressed=false;
  bool fieldsFilled=false;
  TextEditingController etLook1=new TextEditingController();
  TextEditingController etLook2=new TextEditingController();
  TextEditingController etRemember1=new TextEditingController();
  TextEditingController etRemember2=new TextEditingController();

  SharedPreferences prefs;

  Widget initState(){
    super.initState();
    initPref();

  }
  initPref() async {
    prefs=await SharedPreferences.getInstance();

  }

  Widget build(BuildContext context){
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(width:width,margin: EdgeInsets.only(right:width/2.5),child:Column(children: [
        Container(child:Text("Choose a Date...", style: TextStyle(fontSize:25, fontWeight:FontWeight.w700, color: Colors.grey[600]),),padding: EdgeInsets.only(bottom:height/12, top:height/8),),
        Container(child:LookForwardToButton(), padding: EdgeInsets.only(left:width/40)),
        LookForwardFields(),
        Container(child:RememberButton(),padding: EdgeInsets.only(right:width/10),),
        rememberFields(),
        Container(margin:EdgeInsets.only(left:width/5), child:ConfirmButton()),
        /*Align(child:Container(child:FlatButton(color: fieldsFilled? Colors.red : Colors.grey,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height/40)),
          child: Container(alignment: Alignment.center,width:width,child:Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 15),))),
           padding: EdgeInsets.only(left:width/3, top:height/5),)),*/
        
      ],),
    )
    );
  }

  Widget LookForwardToButton(){
    return FlatButton(child:  Text("to look forward to", style: TextStyle(fontSize:25, fontWeight:FontWeight.w700, color: lookPressed? Colors.grey[700]:Colors.grey[400],decoration: TextDecoration.underline )),
      onPressed: (){
        setState(() {
          lookPressed=true;
          rememberPressed=false;
        });
      },
    );
  }

  Widget RememberButton(){
    return FlatButton(child:  Text("to remember", style: TextStyle(fontSize:25, fontWeight:FontWeight.w700, color:rememberPressed? Colors.grey[700]:Colors.grey[400],decoration: TextDecoration.underline )),
      onPressed: (){
        setState(() {
          log(lookPressed.toString()+rememberPressed.toString());
          lookPressed=false;
          rememberPressed=true;
        });
      },
    );
  }

  Widget LookForwardFields(){
    if(!lookPressed){
      return Container();
    }
    return Container(child:Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children:[
      TextFormField(
      controller: etLook1,
      decoration: InputDecoration(hintText:"Event Name",
      hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w700),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,),
      onChanged: (context){
        setState(() {
          fieldsFilled=fieldFilled();
        });
      },
      ),
      TextFormField(
      controller: etLook2,
      decoration: InputDecoration(hintText:"mm/dd/yy",
      hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w700),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,),
      onChanged: (context){
        setState(() {
          fieldsFilled=fieldFilled();
        });
      },
    )
    ],),
    padding: EdgeInsets.only(left:width/2.5, bottom: height/20, top:height/20),
    );
  }

  Widget rememberFields(){
    if(!rememberPressed){
      return Container();
    }
    return Container(child:Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children:[
      TextFormField(
      controller: etRemember1,
      decoration: InputDecoration(hintText:"Event Name",
      hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w700,),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,),
      onChanged: (context){
        setState(() {
          fieldsFilled=fieldFilled();
        });
      },
      ),
      TextFormField(
      controller: etRemember2,
      decoration: InputDecoration(hintText:"mm/dd/yy",
      hintStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w700),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,),
      onChanged: (context){
        setState(() {
          fieldsFilled=fieldFilled();
        });
      },
    )
    ],),
    padding: EdgeInsets.only(left:width/2.5,top:height/20),
    );
  }

  Widget ConfirmButton(){
    return new Container(width: width/2,height: height/15,child: FlatButton(color: fieldsFilled? Colors.red : Colors.grey,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height/40)),
      onPressed: (){
      log("confirm");
      
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context){
              return MyHomePage();
            }));

      }, child: Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 15),))
    );
  }

  bool fieldFilled(){
    return etLook1.text.length>0 && etLook2.text.length>0 && etRemember1.text.length>0 && etRemember2.text.length>0;
  }

   

   
}