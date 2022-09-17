import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MaterialApp(
    title: 'Compass Screen Test',
    home: CompassScreen(),
  ));
}

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});
  
  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {

  double _angle = 0.0;

  void _updateAngle(double newAngle) {
    setState(() {
      _angle = newAngle % 360;
    });
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
              angle: -_angle * (math.pi / 180),
              child: const FlutterLogo(size: 200),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Currently displayed direction:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Text(
              '${_angle.toInt()} degrees',
              style: Theme.of(context).textTheme.displayMedium,
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
              icon: const Icon(Icons.navigation_rounded), 
              onPressed: () => print('you are already on this page'),
            ),
            label: 'Locator',
          ),
        ],
      ),
    );
  }

}