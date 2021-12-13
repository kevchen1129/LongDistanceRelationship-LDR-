import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'calendar/calendar_main_v2.dart';
import 'calendar/calendar_main.dart';
import 'chat/chat_screen.dart';
import 'chat/home_to_chat.dart';
import './map.dart';

/*class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
		title: 'Homepage',
		theme: ThemeData(
			visualDensity: VisualDensity.adaptivePlatformDensity,
		),
		home: MyHomePage(),
		);
	}
	}*/

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _dayNum = 36;
  String _eventName = 'we meet';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("assets/background.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin: EdgeInsets.only(top: 0),
                    child: Stack(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 50, left: 60, right: 60),
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 225, 213, 0.50),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: DefaultTabController(
                          length: 3,
                          child: new TabBar(
                              unselectedLabelColor: Colors.black,
                              labelColor: Colors.black,
                              indicator: BoxDecoration(),
                              tabs: [
                                Tab(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("home"),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("map"),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("goal"),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      Stack(children: <Widget>[
                        Center(
                            child: Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ProfileCard(),
                              Image(
                                image: new AssetImage("assets/timer.png"),
                              ),
                              Text(
                                '$_dayNum' + ' Days',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'until ' + '$_eventName',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              ProfileCard(),
                            ],
                          ),
                        )),
                      ])
                    ]))),
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.home, color: Color(0xFF736464)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today, color: Color(0xFF736464)),
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return LDRCalendar();
                        }));
                      });
                    },
                  ),
                  Container(
                    height: 90,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_library, color: Color(0xFF736464)),
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserMap()),
                );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.person, color: Color(0xFF736464)),
                    onPressed: () {
                      setState(() {
                        final uid = FirebaseAuth.instance.currentUser.uid;

                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return HomeToChat(uid: uid);
                        }));
                      });
                    },
                  ),
                ],
              ),
            )));
  }
}

class ProfileCard extends StatefulWidget {
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 180,
        height: 180,
        margin: EdgeInsets.all(30),
        child: new Stack(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: new DecorationImage(
                  image: new AssetImage("assets/girl.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "30˚C",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Clock(),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class WeatherModel {
  final temp;
  double get getTemp => temp - 272.5;

  WeatherModel(this.temp);

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(json["temp"]);
  }
}

class WeatherRepo {
  Future<WeatherModel> getWeather(String cityName) async {
    final result = await http.Client().get(
        "http://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=43ea6baaad7663dc17637e22ee6f78f2");

    if (result.statusCode != 200) throw Exception();

    return parsedJson(result.body);
  }

  WeatherModel parsedJson(final response) {
    final jsonDecoded = json.decode(response);

    final jsonWeather = jsonDecoded["main"];

    return WeatherModel.fromJson(jsonWeather);
  }
}

class Clock extends StatefulWidget {
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String _now;
  Timer _everySecond;
  @override
  void initState() {
    super.initState();
    _now = _timeToString(DateTime.now());
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (!mounted) return;
      setState(() {
        _now = _timeToString(DateTime.now());
      });
    });
  }

  String _timeToString(DateTime now) {
    String timeString =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    return timeString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(_now,
            style: TextStyle(
              color: Colors.white,
            )));
  }
}

// class CurrentWeather extends StatefulWidget {
// 	_CurrentWeatherState createState() => _CurrentWeatherState();
// }

// class _CurrentWeatherState extends State<CurrentWeather> {
// 	WeatherFactory wf = new WeatherFactory("7bf8cec48e8a6deec18afe54b571d22c");
// 	String cityName = "Taipei";
// 	Weather w = await wf.currentWeatherByCityName(cityName);
// 	double celsius = w.temperature.celsius;

// 	String display = "";

//   @override
//   Widget build(BuildContext context) {
//     return(
//       Container(
//         child:
//           Text(display),
//       )
//   	);
//   }
// }
