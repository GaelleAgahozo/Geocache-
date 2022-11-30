import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocaching_app/compass.dart';
import 'package:geocaching_app/location_items.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:geocaching_app/NewButton.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friends of the Farm',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        textTheme: GoogleFonts.novaSlimTextTheme(),
      ),
      home: LocationList(),
    );
  }
}
class LocationList extends StatefulWidget {
  const LocationList({super.key});

  @override
  State createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  final _itemSet = <Item>{};
  List<Item> items = [
    const Item(name: "Bailey Library", latitude: 35.10136, longitude: -92.44295),
    const Item(name: "Pecan Court Gazebo", latitude: 35.09928, longitude: -92.44269),
    const Item(name: "Purple Cow", latitude: 35.10252, longitude: -92.43848),
    const Item(name: "North Pole", latitude: 90.0, longitude: 0.0),
  ];
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Item To Add'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                    onChanged: (value) {
                      setState(() {
                        valueText = value;
                });
              },
                      controller: _inputController,
                      decoration:
                  const InputDecoration(hintText: "type something here"),),
                    TextField(
                        onChanged: (subttitle) {
                          setState(() {
                      itstext = subttitle;
                    });
                  },
                      controller: _directionsController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(hintText: "enter directions"),
                          /*inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],*/
                          ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    _handleNewItem(valueText, itstext);
                    Navigator.pop(context);
                  });
                },
              ),
              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('Cancel'),
                  );
                },
              ),
            ],
          );
        });
  }
  String valueText = "";
  String itstext = "";

  //final List<Item> itemss = [const Item(name: "add new direction", latitude: 0, longitude: 0 )];
  //final _itemSet = <Item>{};


  void _handleListChanged(Item item, bool saved) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      if (!saved) {
        print("Completing");
        _itemSet.clear();
        _itemSet.add(item);
        //MethodCall(updateTarget(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
      }
      
    });
  }
  /*void _handleDeleteItem(Item song) {
    setState(() {
      print("Deleting item");
      items.remove(song);
    });
  }*/

  void _handleNewItem(String valueText, String itstext) {
    setState(() {
      print("Adding new item");
      List<String> a = itstext.split(',');
      Item item = Item(name: valueText, latitude: double.parse(a[0]), longitude: double.parse(a[1]));
      items.insert(0, item);
      _inputController.clear();
      _directionsController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geocaching App"),
        backgroundColor: Colors.brown,
    ),
    
    body: ListView(
      key: ObjectKey(items.first),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: items.map((item) {
        return LocationItem(
          item: item,
          saved: _itemSet.contains(item),
          onListChanged: _handleListChanged,
        );
      }).toList(),
    ),
    floatingActionButton: NewButton(
          //child: const Icon(Icons.add),
            onPressed: () {
           _displayTextInputDialog(context);
          })
    );
  }
}


/*class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        //backgroundColor: Colors.black,
      ),
      body: const LocationList(),

    );
  }
}*/
