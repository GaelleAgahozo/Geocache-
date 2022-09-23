import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

class TestPlaces {
  static const Position BAILEY_LIBRARY = Position(
      latitude: 35.10136,
      longitude: -92.44295,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  static const Position WEST_GAZEBO = Position(
      latitude: 35.09928,
      longitude: -92.44269,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  static const Position PURPLE_COW = Position(
      latitude: 35.10252,
      longitude: -92.43848,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  static const Position NORTH_POLE = Position(
      latitude: 90,
      longitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
}

void main() {
  runApp(MaterialApp(
    title: 'Compass Screen Test',
    home: CompassScreen(),
  ));
}

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  final Position target = TestPlaces.BAILEY_LIBRARY;

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  _CompassScreenState() {
    // Listeners are initialized inside the State's constructor
    // magnetometer listener (updates angle)
    magnetometerEvents.listen(
      (event) {
        _angleOffset = _convertMagnetometerEventToHeading(event);
        _updateAngle();
      },
    );

    // geolocator listener (updates position/distance)
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _pos = position;
      });
      _updateTargetDist();
    });
  }

  double _angleOffset = 0.0; // compass heading of device
  double _angle = 0.0; // angle to display on screen
  int _targetDist = 0; // distance to target, in meters
  Position? _pos; // current device position

  double _convertMagnetometerEventToHeading(MagnetometerEvent event) {
    // transform the magnetometer vector into a compass heading

    // fix negative zero issues (breaks some calculations)
    double x = event.x == -0 ? 0 : event.x;
    double y = event.y == -0 ? 0 : event.y;
    // find the angle between the x-axis and the vector (x,y)
    double val = math.atan(y / x);
    val += x < 0 ? math.pi : 0;
    val *= 180 / math.pi; // radians to degrees
    // match output to output of Geolocator.bearingBetween(...)
    val -= 90;
    return val;
  }

  void _updateAngle() {
    // Outputs of Geolocator.bearingBetween(...):
    //   0 = north
    //  90 = east
    // 180 = south
    // -90 = west
    double bearing = Geolocator.bearingBetween(_pos?.latitude ?? 0,
        _pos?.longitude ?? 0, widget.target.latitude, widget.target.longitude);

    setState(() {
      _angle = bearing - _angleOffset;
    });
  }

  void _updateTargetDist() {
    double rawDist = Geolocator.distanceBetween(_pos?.latitude ?? 0,
        _pos?.longitude ?? 0, widget.target.latitude, widget.target.longitude);
    _targetDist = rawDist.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
              shadows: [
                Shadow(
                  color: Colors.black38,
                  offset: Offset.fromDirection(1, 8),
                  blurRadius: 2,
                )
              ],
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
            '${_targetDist}m',
            style: Theme.of(context).textTheme.headlineSmall,
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
