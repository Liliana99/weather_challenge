import 'package:flutter/material.dart';

class LastUpdated extends StatelessWidget {
  final DateTime dateTime;

  // ignore: sort_constructors_first
  LastUpdated({Key key, @required this.dateTime})
      : assert(dateTime != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Updated: ${TimeOfDay.fromDateTime(dateTime).format(context)}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w200,
        color: Colors.white,
      ),
    );
  }
}
