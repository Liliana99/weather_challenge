import 'package:weather_challenge/app/weather/models/weather.dart';
import 'package:weather_challenge/app/weather/views/weather_page.dart';

class WeatherConditionsWorld {
  WeatherType actWeatherWorld({WeatherCondition condition}) {
    WeatherType actCondition;

    switch (condition) {
      case WeatherCondition.clear:
      case WeatherCondition.lightCloud:
        actCondition = WeatherType.sun;
        break;
      case WeatherCondition.hail:
      case WeatherCondition.snow:
      case WeatherCondition.sleet:
        actCondition = WeatherType.snow;
        break;
      case WeatherCondition.heavyCloud:
        actCondition = WeatherType.snow;
        break;
      case WeatherCondition.heavyRain:
      case WeatherCondition.lightRain:
      case WeatherCondition.showers:
        actCondition = WeatherType.rain;
        break;
      case WeatherCondition.thunderstorm:
        actCondition = WeatherType.rain;
        break;
      case WeatherCondition.unknown:
        actCondition = WeatherType.sun;
        break;
    }
    return actCondition;
  }
}
