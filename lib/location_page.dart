import 'package:flutter/material.dart';
import 'package:geocaching_app/location_items.dart';

class LocationList extends StatefulWidget {
  const LocationList({super.key});

  @override
  State createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  final _itemSet = <Item>{};
  List<Item> items = [
    const Item(name: "Baily Library", latitude: 35.10136, longitude: -92.44295),
    const Item(
        name: "Pecan Court Gazebo", latitude: 35.09928, longitude: -92.44269),
    const Item(name: "Purple Cow", latitude: 35.10252, longitude: -92.43848),
    const Item(name: "North Pole", latitude: 90.0, longitude: 0.0),
  ];

  void _handleListChanged(Item item, bool current) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      if (!current) {
        print("Completing");
        _itemSet.clear();
        _itemSet.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: ObjectKey(items.first),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: items.map((item) {
        return LocationItem(
          item: item,
          current: _itemSet.contains(item),
          onListChanged: _handleListChanged,
        );
      }).toList(),
    );
  }
}
