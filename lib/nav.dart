import 'package:flutter/material.dart';
import 'package:geo_caching/home.dart';

void main() => runApp(const Nav());

class Nav extends StatelessWidget {
  const Nav({super.key});

  static const String _title = 'Geocaching App';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Text(
      'Compass',
      style: optionStyle,
    ),
    // Text(
    //   'Index 2: Success',
    //   style: optionStyle,
    // ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geocaching App'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration),
            label: 'Compass',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.message),
          //   label: 'Success',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(244, 149, 11, 164),
        onTap: _onItemTapped,
      ),
    );
  }
}




// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/material.dart';

// class Nav extends StatefulWidget {
//   const Nav({super.key});

//   @override
//   State<Nav> createState() => _NavState();
// }

// class _NavState extends State<Nav> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Geocaching App'),
//       ),
//       body: Text('HomePage'),
//       bottomNavigationBar:
//           BottomNavigationBar(items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//         BottomNavigationBarItem(
//             icon: Icon(Icons.compass_calibration), label: 'Compass'),
//         // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//       ]),
//     );
//   }
// }