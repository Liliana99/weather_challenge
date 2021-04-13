import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../settings.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage._({Key key}) : super(key: key);

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => SettingsPage._());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(),
      child: SettingsBody(
        settingsBloc: SettingsBloc(),
      ),
    );
  }
}

// ignore: must_be_immutable
class SettingsBody extends StatelessWidget {
  final SettingsBloc settingsBloc;
  bool prueba = false;
  // ignore: sort_constructors_first
  SettingsBody({Key key, @required this.settingsBloc})
      : assert(settingsBloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          BlocBuilder<SettingsBloc, SettingsState>(
            cubit: settingsBloc,
            builder: (_, SettingsState state) {
              final valueTemp = (state.temperatureUnits == null)
                  ? true
                  : state.temperatureUnits == TemperatureUnits.celsius;
              return ListTile(
                title: const Text(
                  'Temperature Units',
                ),
                isThreeLine: true,
                subtitle: const Text(
                    'Use metric measurements for temperature units.'),
                trailing: Switch(
                  value: valueTemp,
                  onChanged: (_) => settingsBloc.add(TemperatureUnitsToggled()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
