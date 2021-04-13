import 'package:flutter/foundation.dart';
import 'package:weather_challenge/app/weather/models/models.dart';
import 'package:weather_challenge/app/data/services/api_client.dart';

class WeatherApiClientProvider {
  static const String baseUrl = 'https://www.metaweather.com';

  final ApiClient apiClient;
  // ignore: sort_constructors_first
  WeatherApiClientProvider({@required this.apiClient})
      : assert(apiClient != null);

  Future<int> getLocationId(String city) async {
    final locationUrl = '$baseUrl/api/location/search/?query=$city';
    final response = await apiClient.dio.get(locationUrl);
    // ignore: prefer_typing_uninitialized_variables
    var data;
    if (response.statusCode != 200) {
      throw Exception('error getting locationId for city');
    }
    try {
      final result = response.data[0];
      result.forEach((index, value) {
        // ignore: prefer_final_locals
        var mivalue = result['woeid'];
        data = mivalue;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return (data as int);
  }

  Future<Weather> fetchWeather(int locationId) async {
    final weatherUrl = '$baseUrl/api/location/$locationId';
    final weatherResponse = await apiClient.dio.get(weatherUrl);

    if (weatherResponse.statusCode != 200) {
      throw Exception('error getting weather for location');
    }
    final response = weatherResponse.data;
    return Weather.fromJson(response);
  }
}
