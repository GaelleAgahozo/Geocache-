import 'package:flutter/material.dart';

class Item {
  const Item({required this.name});

  final String name;

  String abbrev() {
    return name.substring(0, 1);
  }
}

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);

class LocationItem extends StatelessWidget {
  LocationItem(
      {required this.item,
      required this.current,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(item));

  final Item item;
  final bool current;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return current //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!current) return null;

    return const TextStyle(
      color: Colors.black54,
      backgroundColor: Colors.lightGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(item, current);
      },
      onLongPress: current
          ? () {
              onDeleteItem(item);
            }
          : null,
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(item.abbrev()),
      ),
      title: Text(
        item.name,
        style: _getTextStyle(context),
      ),
    );
  }
}
