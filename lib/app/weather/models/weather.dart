import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum TemperatureUnits { fahrenheit, celsius }
enum WeatherCondition {
  snow,
  sleet,
  hail,
  thunderstorm,
  heavyRain,
  lightRain,
  showers,
  heavyCloud,
  lightCloud,
  clear,
  unknown
}

extension TemperatureUnitsX on TemperatureUnits {
  bool get isFahrenheit => this == TemperatureUnits.fahrenheit;
  bool get isCelsius => this == TemperatureUnits.celsius;
}

@JsonSerializable()
class Temperature extends Equatable {
  const Temperature({@required this.value});

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);

  final double value;

  Map<String, dynamic> toJson() => _$TemperatureToJson(this);

  @override
  List<Object> get props => [value];
}

@JsonSerializable()
class Weather extends Equatable {
  final WeatherCondition condition;
  final String formattedCondition;
  final DateTime lastUpdated;
  final String location;
  final Temperature temperature;
  final double minTemp;
  final double temp;
  final double maxTemp;
  final int locationId;
  final String created;

  // ignore: sort_constructors_first
  const Weather({
    @required this.condition,
    @required this.lastUpdated,
    @required this.location,
    @required this.temperature,
    this.minTemp,
    this.temp,
    this.maxTemp,
    this.formattedCondition,
    this.locationId,
    this.created,
  });

  // ignore: sort_constructors_first
  factory Weather.fromJson(dynamic json) {
    final consolidatedWeather = json['consolidated_weather'][0];
    return Weather(
      condition: _mapStringToWeatherCondition(
          consolidatedWeather['weather_state_abbr'] as String),
      formattedCondition: consolidatedWeather['weather_state_name'] as String,
      minTemp: consolidatedWeather['min_temp'] as double,
      temp: consolidatedWeather['the_temp'] as double,
      maxTemp: consolidatedWeather['max_temp'] as double,
      locationId: json['woeid'] as int,
      created: consolidatedWeather['created'] as String,
      lastUpdated: DateTime.now(),
      location: json['title'] as String,
      temperature: null,
    );
  }

  static final empty = Weather(
    condition: WeatherCondition.unknown,
    lastUpdated: DateTime(0),
    temperature: const Temperature(value: 0),
    location: '--',
  );

  @override
  List<Object> get props => [condition, lastUpdated, location, temperature];

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  Weather copyWith({
    WeatherCondition condition,
    DateTime lastUpdated,
    String location,
    Temperature temperature,
  }) {
    return Weather(
      condition: condition ?? this.condition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
    );
  }

  static WeatherCondition _mapStringToWeatherCondition(String input) {
    WeatherCondition state;
    switch (input) {
      case 'sn':
        state = WeatherCondition.snow;
        break;
      case 'sl':
        state = WeatherCondition.sleet;
        break;
      case 'h':
        state = WeatherCondition.hail;
        break;
      case 't':
        state = WeatherCondition.thunderstorm;
        break;
      case 'hr':
        state = WeatherCondition.heavyRain;
        break;
      case 'lr':
        state = WeatherCondition.lightRain;
        break;
      case 's':
        state = WeatherCondition.showers;
        break;
      case 'hc':
        state = WeatherCondition.heavyCloud;
        break;
      case 'lc':
        state = WeatherCondition.lightCloud;
        break;
      case 'c':
        state = WeatherCondition.clear;
        break;
      default:
        state = WeatherCondition.unknown;
    }
    return state;
  }
}
