import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial());
  @override
  // ignore: override_on_non_overriding_member
  SettingsState get initialState =>
      SettingsState(temperatureUnits: TemperatureUnits.celsius);

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    SettingsState currentState;
    if (event is TemperatureUnitsToggled) {
      currentState = initialState;
      yield SettingsState(
        temperatureUnits:
            currentState.temperatureUnits == TemperatureUnits.celsius
                ? TemperatureUnits.fahrenheit
                : TemperatureUnits.celsius,
      );
    }
  }
}
