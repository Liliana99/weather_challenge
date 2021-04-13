import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_challenge/app/settings/blocs/settings_bloc.dart';
import 'package:weather_challenge/app/weather/models/weather.dart' as model;
import 'package:weather_challenge/app/weather/widgets/temperature_widget.dart';
import 'package:weather_challenge/app/weather/widgets/weather_condictions.dart';

class CombinedWeatherTemperature extends StatelessWidget {
  final model.Weather weather;

  // ignore: sort_constructors_first
  CombinedWeatherTemperature({
    Key key,
    @required this.weather,
  })  : assert(weather != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: WeatherConditions(condition: weather.condition),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocBuilder<SettingsBloc, SettingsState>(
                cubit: BlocProvider.of<SettingsBloc>(context),
                builder: (_, SettingsState state) {
                  return TemperatureWidget(
                    temperature: weather.temp,
                    high: weather.maxTemp,
                    low: weather.minTemp,
                    units: state.temperatureUnits,
                  );
                },
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            weather.formattedCondition,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
