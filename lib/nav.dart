import 'package:flutter/material.dart';
import 'package:geocaching_app/main.dart';
import 'package:geocaching_app/NewButton.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocaching_app/location_items.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const NavigationScaffold());
  }
}

class NavigationScaffold extends StatefulWidget {
  const NavigationScaffold({super.key});

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> {
  int screenIndex = 0;
  final screens = const [
    LocationList(),
  ];

  void updateScreenIndex(int newScreenIndex) {
    setState(() {
      screenIndex = newScreenIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[screenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: screenIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Temp"),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.cloud),
          //   label: "Weather"
          // ),
        ],
        onTap: updateScreenIndex,
        selectedItemColor: Color.fromARGB(255, 140, 14, 14),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
