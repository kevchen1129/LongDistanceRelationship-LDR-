import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
/*
class SpecialDays extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Special Days')),
      body: SpecialDaysList(),
    );
  }
}

class SpecialDaysList extends StatefulWidget {
  SpecialDaysListState createState() => SpecialDaysListState();
}

class SpecialDaysListState extends State<SpecialDaysList> {
  // temp hardcoded saved dates
  final _savedUntil = List<Text>();

  var _savedSince = List<Text>();

  int whichTab = 0;

  void _filler() {}

  void _editEvent() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("page for editing special days"),
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
              onPressed: _filler,
            ),
          ],
        ),
        body: Center(
          child: Text("sample text"),
        ),
      );
    }));
  }

  var _sColor = Colors.white;
  var _nsColor = Color(0xFFA3A3A3);

  Widget _createSavedList(int k) {
    if (k == 0) {
      if (_savedUntil.isEmpty) {
        _savedUntil.add(Text("sample days until event 1"));
        _savedUntil.add(Text("sample days until event 2"));
        _savedUntil.add(Text("sample days until event 3"));
        _savedUntil.add(Text("sample days until event 4"));
        _savedUntil.add(Text("sample days until event 5"));
      }

      final Iterable<ListTile> tiles = _savedUntil.map((Text event) {
        return ListTile(
          title: Text(
            event.toString(),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("date goes here"),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editEvent();
            },
          ),
          leading: Icon(Icons.date_range),
        );
      });

      final List<Widget> divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return ListView(children: divided);
    }

    if (_savedSince.isEmpty) {
      _savedSince.add(Text("sample days since event 1"));
      _savedSince.add(Text("sample days since event 2"));
      _savedSince.add(Text("sample days since event 3"));
      _savedSince.add(Text("sample days since event 4"));
      _savedSince.add(Text("sample days since event 5"));
    }

    final Iterable<ListTile> tiles = _savedSince.map((Text event) {
      return ListTile(
        title: Text(
          event.toString(),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("date goes here"),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Text currEvent = event;
            setState(() {
              _savedSince[0] = Text("changed to something");
              print(identityHashCode(_savedSince[0]));
              print(identityHashCode(currEvent));
            });
          },
        ),
        leading: Icon(Icons.date_range),
      );
    });

    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return ListView(children: divided);
  }

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            width: 200,
            child: CupertinoSegmentedControl(
              padding: EdgeInsets.only(top: 30),
              //backgroundColor: Colors.grey[300],
              //thumbColor: Colors.green[200],
              selectedColor: Color(0xff736464),
              borderColor: Colors.black,
              unselectedColor: Colors.grey[100],
              groupValue: whichTab,
              children: <int, Widget>{
                0: Text(
                  'Days Until',
                  style: TextStyle(
                    color: _sColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                1: Text(
                  'Days Since',
                  style: TextStyle(
                    color: _nsColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              },
              onValueChanged: (T) {
                setState(() {
                  whichTab = T;
                  Color temp = _nsColor;
                  _nsColor = _sColor;
                  _sColor = temp;
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: _createSavedList(whichTab),
            ),
          ),
        ],
      ),
    );
  }
}
*/
