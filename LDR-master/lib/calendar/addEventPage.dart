import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddEventPage extends StatefulWidget {
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  // stores mutable data that can change for this widget
  String repeat = 'Does not repeat';
  // address for user's normal events
  String normalEvents = "Users/User1/Normal_Events";
  String partnerEvents = "Users/User2/Normal_Events";

  SharedPreferences prefs;

  Map<String, dynamic> userFields = {
    'creatorID': 'NA',
    'date_created': DateTime.now().toString(),
    'date_end': DateTime.now().toString(),
    'date_start': DateTime.now().toString(),
    'time_start': "14:00",
    'time_end': '17:00',
    'location': 'NA',
    'title': 'NA',
    'notification_timer': '30 minutes',
    'repeat': 'Does not repeat',
    'date': DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        DateTime.now().day.toString()
  };

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

  int numMin = 30;
  String time = "minutes";

  Widget _fireStoreGetter() {
    return new StreamBuilder(
        stream: Firestore.instance.collection(normalEvents).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Connecting");
          }

          return ListView.builder(
              scrollDirection: Axis
                  .vertical, // https://stackoverflow.com/questions/50252569/vertical-viewport-was-given-unbounded-height
              shrinkWrap: true, // same as above
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                return new Text(ds['title']);
              });
        });
  }

  void _resetUserFields() {
    userFields = {
      'creatorID': 'NA',
      'date_created': DateTime.now().toString(),
      'date_end': DateTime.now().toString(),
      'date_start': DateTime.now().toString(),
      'time_start': "14:00",
      'time_end': '17:00',
      'location': 'NA',
      'title': 'NA',
      'notification_timer': '30 minutes',
      'repeat': 'Does not repeat',
      'date': DateTime.now().year.toString() +
          '-' +
          DateTime.now().month.toString() +
          '-' +
          DateTime.now().day.toString()
    };
  }

  void _changeRepeat() async {
    repeat = await Navigator.push(
        context,
        MaterialPageRoute<String>(
            builder: (BuildContext context) =>
                RepeatPage(current: userFields['repeat'])));

    setState(() {
      userFields['repeat'] = repeat;
      //print('changed to $repeat');
    });
  }

  void _selectDate(BuildContext context, String dt, int k) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(dt),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                // change the border color
                primary: Color(0xff736464),

                // change the text color
                onSurface: Color(0xff9e7e62),
              ),
              primaryColor: Color(0xff736464),
            ),
            child: child,
          );
        });
    if (picked != null) {
      setState(() {
        if (k == 0) {
          userFields['date_start'] = picked.toString();
          //userFields['timestamp'] = DateFormat.yMMD().format(picked);

          String temp = picked.year.toString() +
              '-' +
              picked.month.toString() +
              '-' +
              picked.day.toString();
          userFields['date'] = temp;
        } else {
          userFields['date_end'] = picked.toString();
        }
      });
    }
  }

  void _selectTime(BuildContext context, String dt, k) async {
    List<String> splitted = dt.split(':');
    String hr = splitted[0];
    String min = splitted[1];

    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: int.parse(hr), minute: int.parse(min)),
        initialEntryMode: TimePickerEntryMode.input,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                // change the border color
                primary: Color(0xff9e7e62),

                // change the text color
                onSurface: Color(0xff736464),
              ),
            ),
            child: child,
          );
        });
    if (picked != null) {
      String comb = picked.hour.toString() + ':' + picked.minute.toString();
      setState(() {
        if (k == 0) {
          userFields['time_start'] = comb;
        } else {
          userFields['time_end'] = comb;
        }
      });
    }
  }

  Widget _displayTime(String dt) {
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
    //print(comb);
    return Text(
      comb,
      textAlign: TextAlign.right,
      softWrap: false,
      style: TextStyle(
        fontSize: 17,
      ),
    );
  }

  Widget _displayDate(String dt) {
    DateTime given = DateTime.parse(dt);
    int month = given.month;
    int day = given.day;
    String str_month = '';

    if (month == 1) {
      str_month = "Jan";
    } else if (month == 2) {
      str_month = "Feb";
    } else if (month == 3) {
      str_month = "Mar";
    } else if (month == 4) {
      str_month = "Apr";
    } else if (month == 5) {
      str_month = "May";
    } else if (month == 6) {
      str_month = "Jun";
    } else if (month == 7) {
      str_month = "Jul";
    } else if (month == 8) {
      str_month = "Aug";
    } else if (month == 9) {
      str_month = "Sep";
    } else if (month == 10) {
      str_month = "Oct";
    } else if (month == 11) {
      str_month = "Nov";
    } else {
      str_month = "Dec";
    }
    String comb = str_month + ' ' + day.toString();
    return Text(
      comb,
      textAlign: TextAlign.left,
      softWrap: false,
      style: TextStyle(
        fontSize: 17,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
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
            onPressed: () {
              Navigator.of(context).pop();
              Firestore.instance
                  .collection(normalEvents)
                  .document()
                  .setData(userFields);
              _resetUserFields();
            },
          ),
        ],
      ),

      // body of widget
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // form field for event name
          Expanded(
            flex: 3,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 40, left: 64, right: 64, bottom: 20),
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Event Name",
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff736464),
                ),
                onChanged: (String value) {
                  userFields['title'] = value;
                  //print(userFields);
                },
              ),
            ),
          ),
          // first row for Beginning Time
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(
                      Icons.access_time,
                      color: Color(0xFF736464),
                      size: 30,
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 3,
                  child: FlatButton(
                    padding: EdgeInsets.only(right: 30),
                    child: _displayDate(userFields['date_start']),
                    onPressed: () {
                      _selectDate(context, userFields['date_start'], 0);
                    },
                  ),
                ),
                //Spacer(flex: 1),

                Expanded(
                  flex: 3,
                  child: FlatButton(
                    padding: EdgeInsets.only(right: 30),
                    child: _displayTime(userFields['time_start']),
                    onPressed: () {
                      _selectTime(context, userFields['time_start'], 0);
                    },
                  ),
                ),
                Spacer(flex: 4)
              ],
            ),
          ),
          //Spacer(flex: 1),
          // second row for ending time
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 3,
                  child: FlatButton(
                    padding: EdgeInsets.only(right: 30),
                    child: _displayDate(userFields['date_end']),
                    onPressed: () {
                      _selectDate(context, userFields['date_end'], 1);
                    },
                  ),
                ),
                //Spacer(flex: 1),
                Expanded(
                  flex: 3,
                  child: FlatButton(
                    padding: EdgeInsets.only(right: 30),
                    child: _displayTime(userFields['time_end']),
                    onPressed: () {
                      _selectTime(context, userFields['time_end'], 1);
                    },
                  ),
                ),
                Spacer(flex: 4)
              ],
            ),
          ),
          Spacer(flex: 1),
          // third row for repeat
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      'Repeat',
                      textAlign: TextAlign.left,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                //Spacer(flex: 1),
                Expanded(
                  flex: 5,
                  child: Text(
                    userFields['repeat'],
                    softWrap: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios_sharp),
                    onPressed: _changeRepeat,
                  ),
                ),
                Spacer(flex: 3),
              ],
            ),
          ),
          Spacer(flex: 1),
          // fourth row for location
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF736464),
                      size: 35,
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Add",
                    ),
                    onChanged: (String value) {
                      userFields['location'] = value;
                    },
                  ),
                ),
                Spacer(flex: 8),
              ],
            ),
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: Icon(
                      Icons.notifications_none,
                      color: Color(0xFF736464),
                      size: 35,
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 6,
                  child: FlatButton(
                    padding: EdgeInsets.only(right: 30),
                    child: _displayNotification(),
                    onPressed: () {
                      _buildNotificationPicker();
                      userFields['notification_timer'] =
                          this.numMin.toString() + " " + this.time;
                    },
                  ),
                ),
                Spacer(flex: 6),
              ],
            ),
          ),

          // filler for the rest of page
          Spacer(flex: 1),
          Spacer(flex: 1),
          Spacer(flex: 1),
          Spacer(flex: 8)
        ],
      ),
    );
  }

  Widget _displayNotification() {
    String comb = this.numMin.toString() + " " + this.time + " before";
    return Text(comb,
        softWrap: false,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 17,
        ));
  }

  void _buildNotificationPicker() {
    showModalBottomSheet(
      //backgroundColor: Color(0x00000000),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          child: Row(
            children: <Widget>[
              // widget picker for Number
              Spacer(flex: 3),
              Expanded(
                flex: 2,
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: 29),
                  backgroundColor: Color(0x00000000),
                  children: List.generate(
                      60,
                      (int index) =>
                          Center(child: Text((index + 1).toString()))),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      this.numMin = index + 1;
                    });
                  },
                ),
              ),
              // widget picker for time
              Expanded(
                flex: 2,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: 0),
                  backgroundColor: Color(0x00000000),
                  children: <Widget>[
                    Center(child: Text('minutes')),
                    Center(child: Text('hours')),
                  ],
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      if (index == 0) {
                        this.time = "minutes";
                      } else {
                        this.time = "hours";
                      }
                    });
                  },
                ),
              ),
              Spacer(flex: 3),
            ],
          ),
        );
      },
    );
  }
}

class RepeatPage extends StatefulWidget {
  final String current;

  const RepeatPage({Key key, this.current}) : super(key: key);

  _RepeatPageState createState() => _RepeatPageState(repeat: this.current);
}

class _RepeatPageState extends State<RepeatPage> {
  String repeat;

  _RepeatPageState({this.repeat});

  List<bool> selected = new List(6);
  int number = 2;
  int ind = 0;
  List<String> customTime = ["Days", "Weeks", "Months"];

  void initState() {
    int temp = 0;
    if (repeat == 'Does not repeat') {
      temp = 0;
    } else if (repeat == 'Every Day') {
      temp = 1;
    } else if (repeat == 'Every Week') {
      temp = 2;
    } else if (repeat == 'Every Month') {
      temp = 3;
    } else if (repeat == 'Every Year') {
      temp = 4;
    } else {
      temp = 5;
    }
    //print(temp);
    _setRepeat(temp);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Repeat'),
        automaticallyImplyLeading: false,
        // button for going back

        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop(this.repeat);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Spacer(flex: 2),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 50, right: 50),
              title: Text(
                'Does not repeat',
              ),
              trailing: Icon(
                selected[0] ? Icons.check : null,
              ),
              onTap: () {
                setState(() {
                  repeat = 'Does not repeat';
                  _setRepeat(0);
                });
              },
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 50, right: 50),
              title: Text(
                'Every Day',
              ),
              trailing: Icon(
                selected[1] ? Icons.check : null,
              ),
              onTap: () {
                setState(() {
                  repeat = 'Every Day';
                  _setRepeat(1);
                });
              },
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 50, right: 50),
              title: Text(
                'Every Week',
              ),
              trailing: Icon(
                selected[2] ? Icons.check : null,
              ),
              onTap: () {
                setState(() {
                  repeat = 'Every Week';
                  _setRepeat(2);
                });
              },
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 50, right: 50),
              title: Text(
                'Every Month',
              ),
              trailing: Icon(
                selected[3] ? Icons.check : null,
              ),
              onTap: () {
                setState(() {
                  repeat = 'Every Month';
                  _setRepeat(3);
                });
              },
            ),
          ),
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 50, right: 50),
              title: Text(
                'Every Year',
              ),
              trailing: Icon(
                selected[4] ? Icons.check : null,
              ),
              onTap: () {
                setState(() {
                  repeat = 'Every Year';
                  _setRepeat(4);
                });
              },
            ),
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 1,
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 50, right: 50),
              title: Text(
                'Custom',
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                ),

                // version with constant
                /* 
                onPressed: () {
                  setState(() {
                    _setRepeat(5);
                    print(selected);
                  });
                },
                */

                // version with drop down
                onPressed: _buildDatePicker,
              ),
            ),
          ),
          // version with drop down
          Spacer(flex: 8)

          // version with constant
          /* 
          selected[5]
              ? _buildDatePicker2()
              : Spacer(
                  flex: 8,
                ),
          */
        ],
      ),
    );
  }

  void _buildDatePicker3() {
    Builder(builder: (BuildContext context) {
      Scaffold.of(context).showBottomSheet((BuildContext context) {
        return Container(
          height: 500,
          child: Text("hello"),
        );
      });
    });
  }

  Widget _buildDatePicker2() {
    return Expanded(
      flex: 8,
      child: Row(
        children: <Widget>[
          // widget picker for Number
          Spacer(flex: 3),
          Expanded(
            flex: 2,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: 0),
              backgroundColor: Color(0x00000000),
              children: List.generate(30,
                  (int index) => Center(child: Text((index + 2).toString()))),
              itemExtent: 40,
              onSelectedItemChanged: (int index) {
                this.number = index + 2;
                _setRepeat(5);
                setState(() {});
              },
            ),
          ),
          // widget picker for time
          Expanded(
            flex: 2,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: 0),
              backgroundColor: Color(0x00000000),
              children: <Widget>[
                Center(child: Text('days')),
                Center(child: Text('weeks')),
                Center(child: Text('months')),
              ],
              itemExtent: 40,
              onSelectedItemChanged: (int index) {
                this.ind = index;
                setState(() {});
                _setRepeat(5);
              },
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }

  void _buildDatePicker() {
    showModalBottomSheet(
      //backgroundColor: Color(0x00000000),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          child: Row(
            children: <Widget>[
              // widget picker for Number
              Spacer(flex: 3),
              Expanded(
                flex: 2,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: 0),
                  backgroundColor: Color(0x00000000),
                  children: List.generate(
                      30,
                      (int index) =>
                          Center(child: Text((index + 2).toString()))),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    this.number = index + 2;
                    _setRepeat(5);
                    setState(() {});
                  },
                ),
              ),
              // widget picker for time
              Expanded(
                flex: 2,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: 0),
                  backgroundColor: Color(0x00000000),
                  children: <Widget>[
                    Center(child: Text('days')),
                    Center(child: Text('weeks')),
                    Center(child: Text('months')),
                  ],
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    this.ind = index;
                    setState(() {});
                    _setRepeat(5);
                  },
                ),
              ),
              Spacer(flex: 3),
            ],
          ),
        );
      },
    );
  }

  void _setRepeat(int k) {
    for (var i = 0; i < selected.length; i++) {
      selected[i] = false;
    }

    selected[k] = true;

    if (k == 5) {
      String temp = customTime[this.ind];
      this.repeat = 'Every $number $temp';
    }
  }
}
