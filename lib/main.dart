import 'package:flutter/material.dart';
import 'package:geo_caching/nav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Bar',
      home: Nav(),
    );
  }
}
