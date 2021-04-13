part of 'settings_bloc.dart';

enum TemperatureUnits { fahrenheit, celsius }

class SettingsState extends Equatable {
  final TemperatureUnits temperatureUnits;

  // ignore: sort_constructors_first
  SettingsState({@required this.temperatureUnits}) : super();

  @override
  List<Object> get props => [temperatureUnits];
}

class SettingsInitial extends SettingsState {}
