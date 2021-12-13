//import 'package:LDR_Calender/table_calender.dart';
import 'package:flutter/material.dart';
//import 'package:table_calendar/table_calendar.dart';
import 'calendar_main.dart';
//import 'package:LDR_Calender/table_calender.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFE1D5CB),
        accentColor: Color(0xFFDFB8B7),
      ),
      home: MyCalendar(),
    );
  }
}
