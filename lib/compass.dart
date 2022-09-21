import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;

class TestPlaces {
  static const Position BAILEY_LIBRARY = Position(latitude: 35.10136, longitude: -92.44295, timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
  static const Position WEST_GAZEBO = Position(latitude: 35.09928, longitude: -92.44269, timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
  static const Position PURPLE_COW = Position(latitude: 35.10252, longitude: -92.43848, timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
  static const Position NORTH_POLE = Position(latitude: 90, longitude: 0, timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
}

void main() {
  runApp(MaterialApp(
    title: 'Compass Screen Test',
    home: CompassScreen(),
  ));
}

class CompassScreen extends StatefulWidget {
  CompassScreen({super.key});

  Position target = TestPlaces.PURPLE_COW;
  
  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {

  double _angle = 0.0;
  Position? _pos;
  late Timer _timer;

  void _updateAngle() {
    // Outputs of Geolocator.bearingBetween(...):
    //   0 = north
    //  90 = east
    // 180 = south
    // -90 = west
    double bearing = Geolocator.bearingBetween(
      _pos?.latitude ?? 0, _pos?.longitude ?? 0, 
      widget.target.latitude, widget.target.longitude
    );

    setState(() {
      _angle = bearing;
    });
  }

  void _updatePos() async {
    Position temp = await _determinePosition();
    print("posupdate");
    setState(() {
      _pos = temp;
      //_timer.isActive;
      //print("timer is active");
    });
    _updateAngle();
    /*_timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        _step();
      });
    });*/
    _timer = Timer.periodic(const Duration(seconds: 30), (_) { 
      setState(() {
        _getDistanceToTarget();
      });
    });
  }

  int _getDistanceToTarget() {
    _updatePos();
    double rawDist = Geolocator.distanceBetween(
      _pos?.latitude ?? 0, _pos?.longitude ?? 0, 
      widget.target.latitude, widget.target.longitude
    );
    return rawDist.toInt();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => print('going back'),
        ),
        title: const Text('Geocache Locator'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Direction to Geocache:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Transform.rotate(
              angle: _angle * (math.pi / 180),
              child: Icon(
                Icons.arrow_upward_rounded,
                size: 200,
                color: Theme.of(context).primaryColorDark,
                shadows: [Shadow(
                  color: Colors.black38,
                  offset: Offset.fromDirection(1, 8),
                  blurRadius: 2,
                )],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Distance to Target:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Text(
              '${_getDistanceToTarget()}m',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.home_rounded), 
              onPressed: () => print('navigating to homepage'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(CupertinoIcons.compass_fill), 
              onPressed: () => print('you are already on this page'),
            ),
            label: 'Locator',
          ),
        ],
      ),
    );
  }

}

/// Example position-finding method from the Geolocator API (https://pub.dev/packages/geolocator)
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.

  return await Geolocator.getCurrentPosition();
}