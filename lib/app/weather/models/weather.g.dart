// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Temperature _$TemperatureFromJson(Map<String, dynamic> json) {
  return Temperature(
    value: (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$TemperatureToJson(Temperature instance) =>
    <String, dynamic>{
      'value': instance.value,
    };

Weather _$WeatherFromJson(dynamic json, {WeatherCondition condition}) {
  return Weather(
    condition:
        _$enumDecodeNullable(_$WeatherConditionEnumMap, json['condition']),
    lastUpdated: json['lastUpdated'] == null
        ? null
        : DateTime.parse(json['lastUpdated'] as String),
    location: json['location'] as String,
    temperature: json['temperature'] == null
        ? null
        : Temperature.fromJson(json['temperature'] as Map<String, dynamic>),
    minTemp: (json['minTemp'] as num)?.toDouble(),
    temp: (json['temp'] as num)?.toDouble(),
    maxTemp: (json['maxTemp'] as num)?.toDouble(),
    formattedCondition: json['formattedCondition'] as String,
    locationId: json['locationId'] as int,
    created: json['created'] as String,
  );
}

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'condition': _$WeatherConditionEnumMap[instance.condition],
      'formattedCondition': instance.formattedCondition,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'location': instance.location,
      'temperature': instance.temperature,
      'minTemp': instance.minTemp,
      'temp': instance.temp,
      'maxTemp': instance.maxTemp,
      'locationId': instance.locationId,
      'created': instance.created,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$WeatherConditionEnumMap = {
  WeatherCondition.snow: 'snow',
  WeatherCondition.sleet: 'sleet',
  WeatherCondition.hail: 'hail',
  WeatherCondition.thunderstorm: 'thunderstorm',
  WeatherCondition.heavyRain: 'heavyRain',
  WeatherCondition.lightRain: 'lightRain',
  WeatherCondition.showers: 'showers',
  WeatherCondition.heavyCloud: 'heavyCloud',
  WeatherCondition.lightCloud: 'lightCloud',
  WeatherCondition.clear: 'clear',
  WeatherCondition.unknown: 'unknown',
};
