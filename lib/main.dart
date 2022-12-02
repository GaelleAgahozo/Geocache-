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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _itemSort());
  }

  final _itemSet = <Item>{};
  List<Item> items = [
    const Item(
        name: "Bailey Library", latitude: 35.10136, longitude: -92.44295),
    const Item(
        name: "Pecan Court Gazebo", latitude: 35.09928, longitude: -92.44269),
    const Item(name: "Purple Cow", latitude: 35.10252, longitude: -92.43848),
    const Item(name: "Mills Center", latitude: 35.10007, longitude: -92.44314),
    const Item(
        name: "MC Reynolds",
        latitude: 35.10018858540446,
        longitude: -92.44270084106084),
    const Item(
        name: "MC Acxiom",
        latitude: 35.100770074226894,
        longitude: -92.44270292029088),
    const Item(
        name: "Bailey Lawn",
        latitude: 35.10111422366941,
        longitude: -92.44268089976055),
    const Item(
        name: "Veasey Hall",
        latitude: 35.10132204341581,
        longitude: -92.4419402838443),
    const Item(
        name: "Raney Hall",
        latitude: 35.10175156360877,
        longitude: -92.44223162462217),
    const Item(
        name: "Galloway Hall",
        latitude: 35.10176458760888,
        longitude: -92.44147246344146),
    const Item(
        name: "Galloway Circle Gazebo",
        latitude: 35.101807270560705,
        longitude: -92.44192056605185),
    const Item(
        name: "Dawkins Welcome Center",
        latitude: 35.101754142948145,
        longitude: -92.44087475788315),
    const Item(
        name: "SLTC",
        latitude: 35.10057275369828,
        longitude: -92.44081523738961),
    const Item(
        name: "SLTC South Entrance",
        latitude: 35.100224026191405,
        longitude: -92.44048246429975),
    const Item(
        name: "Windgate Museum of Art",
        latitude: 35.10060090513588,
        longitude: -92.44172428457483),
    const Item(
        name: "Hundley Shell Theater",
        latitude: 35.100536089211516,
        longitude: -92.44174210977862),
    const Item(
        name: "SLTC Sun Porch",
        latitude: 35.1005633997448,
        longitude: -92.4401785764301),
    const Item(
        name: "Spirit Store",
        latitude: 35.10051713290303,
        longitude: -92.44046194441404),
    const Item(
        name: "Post Office",
        latitude: 35.100715588017344,
        longitude: -92.44056475452217),
    const Item(
        name: "Couch Circle",
        latitude: 35.09988345795402,
        longitude: -92.44097146818086),
    const Item(
        name: "Couch Hall",
        latitude: 35.099653400587286,
        longitude: -92.44068451459995),
    const Item(
        name: "Houses Lawn",
        latitude: 35.098525223187664,
        longitude: -92.4404939288982),
    const Item(
        name: "Hardin Hall",
        latitude: 35.098848049618695,
        longitude: -92.44121504722796),
    const Item(
        name: "Martin Hall",
        latitude: 35.09946048834069,
        longitude: -92.4414218546726),
    const Item(
        name: "The Houses",
        latitude: 35.09884669100099,
        longitude: -92.4404946045966),
    const Item(
        name: "Brick Pit",
        latitude: 35.09990380607854,
        longitude: -92.44214403128834),
    const Item(
        name: "Pecan Court",
        latitude: 35.09986223589199,
        longitude: -92.44272225550272),
    const Item(
        name: "Staples Auditorium",
        latitude: 35.09955388317853,
        longitude: -92.4430374569569),
    const Item(
        name: "Greene Chapel",
        latitude: 35.09942388370321,
        longitude: -92.44318164952753),
    const Item(
        name: "The Fountain",
        latitude: 35.09958755144096,
        longitude: -92.44254262518265),
    const Item(
        name: "DW Reynolds",
        latitude: 35.099573853380704,
        longitude: -92.44240248234794),
    const Item(
        name: "Buhler Hall",
        latitude: 35.09912010088489,
        longitude: -92.44242753906292),
    const Item(
        name: "Fausett Hall",
        latitude: 35.098789436530396,
        longitude: -92.44248175205115),
    const Item(
        name: "Turtle Pond",
        latitude: 35.09892044591174,
        longitude: -92.44263221584934),
    const Item(
        name: "Trieschmann",
        latitude: 35.09884032254213,
        longitude: -92.44355769204554),
    const Item(
        name: "Labyrinth",
        latitude: 35.098209971877864,
        longitude: -92.44359334245311),
    const Item(
        name: "Ellis Hall",
        latitude: 35.09821470738214,
        longitude: -92.44263651383676),
    const Item(
        name: "Front Street Apartments",
        latitude: 35.09714938729536,
        longitude: -92.44288339372731),
    const Item(
        name: "Front Lawn",
        latitude: 35.096992201934505,
        longitude: -92.44222188064532),
    const Item(
        name: "Art Building A",
        latitude: 35.09655245579655,
        longitude: -92.44280293829814),
    const Item(
        name: "Art Building B",
        latitude: 35.096578734615775,
        longitude: -92.44225417859111),
    const Item(
        name: "Art Building C",
        latitude: 35.096620672965294,
        longitude: -92.44195159189144),
    const Item(
        name: "Hendrix Corner Apartments",
        latitude: 35.09604626248158,
        longitude: -92.44286209237731),
    const Item(
        name: "Bluesail",
        latitude: 35.09247959483371,
        longitude: -92.44166648188492),
    const Item(
        name: "Office of Public Safety",
        latitude: 35.10124964415345,
        longitude: -92.44458679274163),
    const Item(
        name: "Counseling Services",
        latitude: 35.10058996164505,
        longitude: -92.44447167870032),
    const Item(
        name: "Huntington Apartments",
        latitude: 35.10127731781292,
        longitude: -92.44538624746761),
    const Item(
        name: "Clifton Apartments",
        latitude: 35.10180216691025,
        longitude: -92.4453747929068),
    const Item(
        name: "Clifton A-Frame",
        latitude: 35.10195202531743,
        longitude: -92.44575483404238),
    const Item(
        name: "WAC",
        latitude: 35.099876424835415,
        longitude: -92.43833959333358),
    const Item(
        name: "Market Square South",
        latitude: 35.10230442881089,
        longitude: -92.43880121855355),
    const Item(
        name: "Market Square East",
        latitude: 35.10289868070269,
        longitude: -92.4384395258748),
    const Item(
        name: "Market Square North",
        latitude: 35.1030611489657,
        longitude: -92.4390703251792),
    const Item(
        name: "Village Green",
        latitude: 35.10273304260475,
        longitude: -92.43908368205449),
    const Item(
        name: "Creek Preserve",
        latitude: 35.104611783872734,
        longitude: -92.43648849352971),
    const Item(
        name: "Softball Field",
        latitude: 35.10051220769681,
        longitude: -92.43495812306354),
    const Item(
        name: "Beach Volleyball Court",
        latitude: 35.098377687053855,
        longitude: -92.44057523072459),
    const Item(
        name: "Tennis Courts",
        latitude: 35.101568894130686,
        longitude: -92.43928220557744)
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
                      const InputDecoration(hintText: "type something here"),
                ),
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

  void _itemSort() {
    // a function that sorts the item
    items.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    setState(() {});
  }

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
      Item item = Item(
          name: valueText,
          latitude: double.parse(a[0]),
          longitude: double.parse(a[1]));
      items.insert(0, item);
      _itemSort();
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
        }));
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
