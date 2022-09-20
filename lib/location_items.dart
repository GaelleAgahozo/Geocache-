import 'package:flutter/material.dart';

class Item {
  const Item(
      {required this.name, required this.latitude, required this.longitude});

  final String name;
  final double latitude;
  final double longitude;
}

typedef LocationChangedCallback = Function(Item item, bool current);

class LocationItem extends StatelessWidget {
  LocationItem({
    required this.item,
    required this.current,
    required this.onListChanged,
  }) : super(key: ObjectKey(item));

  final Item item;
  final bool current;
  final LocationChangedCallback onListChanged;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return current //
        ? Colors.green
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!current) return null;

    return const TextStyle(
      color: Colors.black54,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(item, current);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
      ),
      title: Text(
        item.name,
        style: _getTextStyle(context),
      ),
      subtitle: Text("(" +
          item.latitude.toString() +
          ", " +
          item.longitude.toString() +
          ")"),
    );
  }
}
