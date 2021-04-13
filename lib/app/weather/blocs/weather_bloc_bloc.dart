import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_challenge/app/weather/models/models.dart';
import 'package:weather_challenge/app/weather/repositories/weather_repository.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  final WeatherRepository weatherRepository;

  // ignore: sort_constructors_first
  WeatherBloc({@required this.weatherRepository})
      : assert(weatherRepository != null),
        super(WeatherEmpty());

  @override
  Stream<WeatherBlocState> mapEventToState(
    WeatherBlocEvent event,
  ) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        final weather = await weatherRepository.getWeather(event.city);
        yield WeatherLoaded(weather: weather);
      } catch (_) {
        yield WeatherError();
      }
    }
    if (event is RefreshWeather) {
      WeatherBlocState state;
      try {
        final weather = await weatherRepository.getWeather(event.city);
        yield WeatherLoaded(weather: weather);
      } catch (_) {
        yield state;
      }
    }
  }
}
