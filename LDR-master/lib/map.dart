import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

class UserMap extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<UserMap> {

  double latitudeData = 0.0;
  double longitudeData = 0.0;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(geoposition.toString());
    setState(() {
      latitudeData = geoposition.latitude.toDouble();
      longitudeData = geoposition.longitude.toDouble();
    });

  }

//   Future<Position> getLocation() async
// {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     return position;
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(latitudeData.toString() + " / " + longitudeData.toString()),
      ),
      body: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(latitudeData, longitudeData),
          zoom: 2.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: 
              "https://api.mapbox.com/styles/v1/vanessatu20/ckixzx8xy2r0k19r5kpuyn4f6/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidmFuZXNzYXR1MjAiLCJhIjoiY2tpeHpqZ2JyMHB5ZzJxbTZhc3MxZGk3eSJ9.kXEEwtalZHTgEGsHmsCo3g",
            additionalOptions: {
              'accessToken':'pk.eyJ1IjoidmFuZXNzYXR1MjAiLCJhIjoiY2tpeTg0d3RuM2x5bTJwcDNrbWxyNHF0MCJ9.zOLcuVdUMHlv4cJwgSNtog',
              'id': 'mapbox.mapbox-streets-v8'
            }
          ),
          new MarkerLayerOptions( markers: [
            new Marker(
              width: 45,
              height: 45,
              point: new LatLng(latitudeData, longitudeData),
              builder: (context) => new Container(
                child: Icon(
                  Icons.location_on,
                  color: Colors.grey,
                  size: 45.0,
                )
              )
            )
          ])
          ],
        )
    );
  }
}
