import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_challenge/simple_bloc_observer.dart';
import 'package:weather_challenge/weather_app.dart';
import 'app/data/services/api_client.dart';
import 'app/data/services/api_provider.dart';
import 'app/weather/repositories/repository.dart';

Future<void> main() async {
  // Inicializer libreries
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  runApp(WeatherApp(
    weatherRepository: WeatherRepository(
      weatherApiClient: WeatherApiClientProvider(
        apiClient: ApiClient(),
      ),
    ),
  ));
}
