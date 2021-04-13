import 'package:flutter/foundation.dart';
import 'package:weather_challenge/app/weather/models/models.dart';
import 'package:weather_challenge/app/data/services/api_provider.dart';

class WeatherRepository {
  final WeatherApiClientProvider weatherApiClient;

  // ignore: sort_constructors_first
  WeatherRepository({@required this.weatherApiClient})
      : assert(weatherApiClient != null);

  Future<Weather> getWeather(String city) async {
    final locationId = await weatherApiClient.getLocationId(city);
    return weatherApiClient.fetchWeather(locationId);
  }
}
