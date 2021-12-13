import 'package:flutter/material.dart';
import 'dart:math';

class SpecialDays extends StatelessWidget {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Special Days"),
          bottom: ColoredTabBar(
            // custom widget defined below
            Colors.white,
            TabBar(
              indicatorColor: Colors.white,
              //indicatorPadding: EdgeInsets.only(left: 20, top: 60),
              unselectedLabelColor: Color(0xFFA3A3A3),
              labelColor: Colors.white,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              indicator: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(22.5),
                color: Color(0xFF736464),
              ),
              tabs: <Widget>[
                Tab(
                  text: "Days Until",
                ),
                Tab(
                  text: "Days Since",
                ),
              ],
            ),
          ),
        ),
        body: SpecialDaysList(),
      ),
    );
  }
}

class SpecialDaysList extends StatefulWidget {
  SpecialDaysListState createState() => SpecialDaysListState();
}

class SpecialDaysListState extends State<SpecialDaysList> {
  final _savedUntil = List<Text>();

  var _savedSince = List<Text>();

  int whichTab = 0;
  void _filler() {}

  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        _createSavedList(0),
        _createSavedList(1),
      ],
    );
  }

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

  Widget _countDownIcon() {
    return SizedBox(
      height: 90,
      width: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 90,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFDFB8B7),
            ),
          ),
          Positioned(
            top: 8,
            child: Text(
              "D-Day",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            child: Text(
              Random().nextInt(365).toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _countUpIcon() {
    return SizedBox(
      height: 90,
      width: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 90,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFC8CED0),
            ),
          ),
          Positioned(
            top: 8,
            child: Text(
              Random().nextInt(365).toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            child: Text(
              "Days",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createSavedList(int k) {
    if (k == 0) {
      if (_savedUntil.isEmpty) {
        _savedUntil.add(Text("We Meet Again"));
        _savedUntil.add(Text("sample days until event 2"));
        _savedUntil.add(Text("sample days until event 3"));
        _savedUntil.add(Text("sample days until event 4"));
        _savedUntil.add(Text("sample days until event 5"));
      }

      final Iterable<ListTile> tiles = _savedUntil.map((Text event) {
        return ListTile(
          contentPadding: EdgeInsets.only(top: 10, bottom: 10),
          title: Text(
            event.data,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("September 30th, 2020"),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
            ),
            onPressed: () {
              _editEvent();
            },
          ),
          leading: _countDownIcon(),
          ////Icon(Icons.date_range),
        );
      });

      final List<Widget> divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return ListView(
        padding: EdgeInsets.all(10),
        children: divided,
      );
    }
    // code for days since
    if (_savedSince.isEmpty) {
      _savedSince.add(Text("Our First Trip"));
      _savedSince.add(Text("sample days since event 2"));
      _savedSince.add(Text("sample days since event 3"));
      _savedSince.add(Text("sample days since event 4"));
      _savedSince.add(Text("sample days since event 5"));
    }

    final Iterable<ListTile> tiles = _savedSince.map((Text event) {
      return ListTile(
        contentPadding: EdgeInsets.only(top: 10, bottom: 10),
        title: Text(
          event.data,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Sept 30th, 2017"),
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
        leading: _countUpIcon(),
      );
    });

    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return ListView(
      padding: EdgeInsets.all(10),
      children: divided,
    );
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}

class CountDownIcon {
  CountDownIcon(this.currDate, this.eventDate);

  final String currDate;
  final String eventDate;

  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[],
      ),
      color: Colors.pink[200],
    );
  }
}
