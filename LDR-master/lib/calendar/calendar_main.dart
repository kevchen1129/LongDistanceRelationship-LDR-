import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'special_days.dart';
import 'special_days_v2.dart';

class MyCalendar extends StatefulWidget {
  MyCalendar({Key key}) : super(key: key);

  @override
  _MyCalendarState createState() => new _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  CalendarController _controller;
  final ldrBrown = Color(0xFFE1D5CB);

  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Calendar'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.star),
            onPressed: _specialDays,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addEvents,
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 3,
            child: TableCalendar(
              calendarController: _controller,
              // styles the individual days of the month
              calendarStyle: CalendarStyle(
                selectedColor: Color(0xff736464),
                weekdayStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                weekendStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                todayColor: Colors.red[200],
              ),
              // styles the mon-sun at the top
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Color(0xff736464),
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  color: Color(0xff736464),
                  fontWeight: FontWeight.bold,
                ),
              ),
              // styles the monthly header at the top
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          /*
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(_controller.selectedDay.toString()),
              ),
              Expanded(
                child: Text('images/pic2.jpg'),
              )
            ],
          )
          Row finished*/
          Flexible(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(40), //EdgeInsets.only(left: 30),
              width: MediaQuery.of(context).size.width - 30,
              //height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                color: Color(0xFFE1D5CB),
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            //Text("helllo"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // navigating to saved important dates

  void _specialDays() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => SpecialDays(),
    ));
  }

  void _fillerFunction() {}

  void _editEvents() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _fillerFunction,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _fillerFunction,
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: 50, bottom: 30, left: 40, right: 40),
              child: Container(
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  "LDR Design Team Meeting",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 20, left: 20),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 60,
                    width: 120,
                    child: TextFormField(
                      readOnly: true,
                      initialValue: "2:00pm",
                      decoration: InputDecoration(
                        icon: Icon(Icons.query_builder),
                        //hintText: "2:00pm",
                        labelText: "Begin",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  SizedBox(
                    height: 60,
                    width: 83,
                    child: TextFormField(
                      readOnly: true,
                      initialValue: "3:00pm",
                      decoration: InputDecoration(
                        //hintText: "3:00pm",
                        labelText: "End",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 6),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 40),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  readOnly: true,
                  initialValue: "Home",
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    //hintText: "Home",
                    labelText: "Location",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 40),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  readOnly: true,
                  initialValue: "30 minutes before",
                  decoration: InputDecoration(
                    icon: Icon(Icons.notifications),
                    //hintText: "30 minutes before",
                    labelText: "Notification",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: ldrBrown),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }

  void _addEvents() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Creating new event"),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _editEvents,
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: 60, bottom: 30, left: 50, right: 40),
              child: SizedBox(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Event Name",
                    labelText: "Event Name",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: ldrBrown),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    width: 115,
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.query_builder),
                        hintText: "Beign",
                        labelText: "Begin",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: ldrBrown),
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  SizedBox(
                    height: 50,
                    width: 87,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "End",
                        labelText: "End",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: ldrBrown),
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 6),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 40),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    hintText: "Add Location",
                    labelText: "Location",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: ldrBrown),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 40),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.notifications),
                    hintText: "When do you want to be notified?",
                    labelText: "Notification",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF1C4C4C4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: ldrBrown),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }
}
