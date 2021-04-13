part of 'weather_bloc_bloc.dart';

abstract class WeatherBlocEvent extends Equatable {
  // ignore: avoid_unused_constructor_parameters
  const WeatherBlocEvent(List<String> list);

  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherBlocEvent {
  final String city;

  // ignore: sort_constructors_first
  FetchWeather({@required this.city})
      : assert(city != null),
        super([city]);
}

class RefreshWeather extends WeatherBlocEvent {
  final String city;

  // ignore: sort_constructors_first
  RefreshWeather({@required this.city})
      : assert(city != null),
        super([city]);
}
