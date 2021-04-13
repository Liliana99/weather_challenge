import 'package:flutter/material.dart';

class CitySelection extends StatefulWidget {
  @override
  State<CitySelection> createState() => _CitySelectionState();
}

class _CitySelectionState extends State<CitySelection> {
  final TextEditingController _textController = TextEditingController();

  String get _text => _textController.text;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Search'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: TextField(
                key: const Key('city_SelectionPage_search_textfield'),
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  hintText: 'Chicago',
                ),
              ),
            ),
          ),
          IconButton(
            key: const Key('city_SelectionPage_search_iconButton'),
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).pop(_text),
          )
        ],
      ),
    );
  }
}
