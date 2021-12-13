import 'addEventPage.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'editEventPage.dart';

class LDRCalendar extends StatefulWidget {
  LDRCalendar({Key key}) : super(key: key);

  @override
  _LDRCalendarState createState() => new _LDRCalendarState();
}

class _LDRCalendarState extends State<LDRCalendar> {
  CalendarController _controller = CalendarController();
  SharedPreferences prefs;
  String normalEvents =
      "Users/User1/Normal_Events";
  String partnerEvents = "Users/User2/Normal_Events";
  DateTime _selectedDay = DateTime.now();
  int numClicks = 1;
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        this.prefs = prefs;
        normalEvents="Users/"+prefs.getString("self_uid")+"/Normal_Events";
        partnerEvents="Users/"+prefs.getString("couple_uid")+"/Normal_Events";
      });
    });
  }

  void _onDaySelected(DateTime date, List events, List events2) {
    setState(() {
      //_selectedDay = _controller.selectedDay;
      _selectedDay = date;
      this.numClicks += 1;
      print("different day selected: " + _dateToString(_selectedDay));
    });
  }

  Future<String> getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("self_uid");
  }

  String _dateToString(DateTime dt) {
    print(dt.toString());
    String temp = dt.year.toString() +
        '-' +
        dt.month.toString() +
        '-' +
        dt.day.toString();
    return temp;
  }

  Widget _fireStoreGetter(String path) {
    print("retrieving events for date: " + _dateToString(_selectedDay));

    return new StreamBuilder(
        // .orderBy messes up the stream collection,

        // https://stackoverflow.com/questions/60794791/firestore-snapshot-used-in-flutter-streambuilder-never-gets-updated-when-data-ch
        stream: Firestore.instance
            .collection(path)
            .where('date', isEqualTo: _dateToString(_selectedDay))
            //.orderBy('time_start')
            .snapshots(),
        builder: (context, snapshot) {
          //print(snapshot.data.documents.length);
          //print(_selectedDay);

          // if stream is empty, display no events text

          if (!snapshot.hasData) {
            return new Container(
              height: 300,
              color: Colors.blue,
              child: Text(
                //'no events, the widget has been refreshed $numClicks times'
                " ",
              ),
            );
          } else if (snapshot.hasError) {
            print("error");
          }
          print("from " +
              path +
              " of length " +
              snapshot.data.documents.length.toString());
          // buids list of events if stream has data
          return new ListView.separated(
              scrollDirection: Axis
                  .vertical, // https://stackoverflow.com/questions/50252569/vertical-viewport-was-given-unbounded-height
              shrinkWrap: true, // same as above
              itemCount: snapshot.data.documents.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                //print(ds.documentID);

                return Container(
                  decoration: BoxDecoration(
                    color: Color(0xffede5df),
                  ),
                  child: ListTile(
                    title: Text(
                      ds['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _displayTime(ds['time_start']) +
                            ' - ' +
                            _displayTime(ds['time_end']),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    onTap: () {
                      // _navigateToEdit(ds.documentID, ds.data);
                    },
                  ),
                );
              });
        });
  }
  /*
  void _navigateToEdit(String docID, Map<String, dynamic> initial) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditEventPage(
                  documentID: docID,
                  initialMap: initial,
                ))).then((value) {
      setState(() {});
    });
  }
  */

  String _displayTime(String dt) {
    String am = 'am';
    List<String> splitted = dt.split(':');
    int hour = int.parse(splitted[0]);
    if (splitted[1].length == 1) {
      splitted[1] = '0' + splitted[1];
    }
    if (hour > 12) {
      hour = hour - 12;
      am = 'pm';
    }
    String comb = hour.toString() + ':' + splitted[1] + am;
    return comb;
  }

  void _navigateToAdd() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddEventPage())).then((value) {
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    print('building calendar');

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Calendar'),
        actions: <Widget>[
          // button for navigation to special days
          IconButton(
            icon: Icon(Icons.star),
            onPressed: _fillerFunction,
          ),
          // button for navigating to add events
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAdd,
          ),
        ],
      ),
      // builds the body of the app: calendar
      body: Column(
        children: [
          Flexible(
            flex: 3,
            child: TableCalendar(
              calendarController: _controller,
              onDaySelected: _onDaySelected,

              // styles the individual days of the month
              initialSelectedDay: DateTime.now(),
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
          // end of calendar

          // displays events
          Flexible(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(
                top: 40,
                bottom: 20,
                left: 20,
                right: 20,
              ), //EdgeInsets.only(left: 30),
              width: MediaQuery.of(context).size.width - 30,
              height: MediaQuery.of(context).size.height / 2,
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

              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: _fireStoreGetter(normalEvents),
                    ),
                    Expanded(child: VerticalDivider(color: Colors.black)),
                    Expanded(
                      flex: 5,
                      child: _fireStoreGetter(partnerEvents),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget testbottom() {}

  void _fillerFunction() {
    return;
  }
}
