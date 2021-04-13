part of 'weather_bloc_bloc.dart';

abstract class WeatherBlocState extends Equatable {
  const WeatherBlocState();

  @override
  List<Object> get props => [];
}

class WeatherEmpty extends WeatherBlocState {}

class WeatherLoading extends WeatherBlocState {}

class WeatherLoaded extends WeatherBlocState {
  final Weather weather;

  WeatherLoaded({@required this.weather})
      : assert(weather != null),
        super();
}

class WeatherError extends WeatherBlocState {}

class WeatherBlocInitial extends WeatherBlocState {}
