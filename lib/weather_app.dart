import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/settings/blocs/settings_bloc.dart';
import 'app/weather/repositories/repository.dart';
import 'app/weather/views/weather_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({
    Key key,
    @required WeatherRepository weatherRepository,
  })  : _weatherRepository = weatherRepository,
        super(key: key);

  final WeatherRepository _weatherRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _weatherRepository,
      child: WeatherAppView(
        weatherRepository: _weatherRepository,
      ),
    );
  }
}

class WeatherAppView extends StatelessWidget {
  final WeatherRepository weatherRepository;

  // ignore: sort_constructors_first
  const WeatherAppView({Key key, this.weatherRepository}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final _settingsBloc = SettingsBloc();
    return BlocProvider(
      create: (context) => _settingsBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          textTheme: GoogleFonts.rajdhaniTextTheme(),
          appBarTheme: AppBarTheme(
            textTheme: GoogleFonts.rajdhaniTextTheme(textTheme).apply(
              bodyColor: Colors.white,
            ),
          ),
        ),
        home: WeatherPage(
          weatherRepository: weatherRepository,
        ),
      ),
    );
  }
}
