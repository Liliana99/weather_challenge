import 'package:flutter/material.dart';

import 'package:weather_challenge/app/weather/models/models.dart';
import 'package:weather_challenge/app/weather/views/weather_page.dart';
import 'package:weather_challenge/app/weather/widgets/last_update.dart';
import 'package:weather_challenge/app/weather/widgets/location.dart';
import 'package:weather_challenge/app/weather/widgets/weather_temperature.dart';

class LocationAndTemperature extends StatelessWidget {
  const LocationAndTemperature({
    Key key,
    @required this.weather,
    @required this.weatherWorld,
  }) : super(key: key);

  final Weather weather;
  final WeatherWorld weatherWorld;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Center(
            child: Location(
              location: weather.location,
              isDark: (weatherWorld.weatherType == WeatherType.sun),
            ),
          ),
        ),
        Center(
          child: LastUpdated(dateTime: weather.lastUpdated),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Center(
            child: CombinedWeatherTemperature(
              weather: weather,
            ),
          ),
        ),
      ],
    );
  }
}
