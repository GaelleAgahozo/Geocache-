import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geocaching_app/location_items.dart';
import 'dart:math' as math;

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key, required this.item});

  final Item item;

  @override
  State<CompassScreen> createState() => CompassScreenState();
}

class CompassScreenState extends State<CompassScreen> {
  CompassScreenState() {
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  double _angleOffset = 0.0; // compass heading of device
  double _angle = 0.0; // angle to display on screen
  int _targetDist = 0; // distance to target, in meters
  Position? _pos; // current device position

  @visibleForTesting
  double convertMagnetometerEventToHeading(MagnetometerEvent event) {
    return _convertMagnetometerEventToHeading(event);
  }

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
        _pos?.longitude ?? 0, widget.item.latitude, widget.item.longitude);

    setState(() {
      _angle = bearing - _angleOffset;
    });
  }

  void _updateTargetDist() {
    double rawDist = Geolocator.distanceBetween(_pos?.latitude ?? 0,
        _pos?.longitude ?? 0, widget.item.latitude, widget.item.longitude);
    _targetDist = rawDist.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compass'),
      ),
      body:Center(
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
              key: const Key('compass'),
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
