import 'package:flutter/material.dart';

class Location extends StatelessWidget {
  final String location;
  final bool isDark;

  // ignore: sort_constructors_first
  Location({Key key, @required this.location, this.isDark = false})
      : assert(location != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontColor = isDark ? Colors.black : Colors.white;
    return Text(
      location,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: fontColor,
      ),
    );
  }
}
