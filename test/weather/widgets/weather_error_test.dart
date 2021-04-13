import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_challenge/app/weather/widgets/weather_error.dart';

void main() {
  group('WeatherError', () {
    testWidgets('renders correct text and icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeatherErrorResponse(),
          ),
        ),
      );
      expect(find.text('Something went wrong!'), findsOneWidget);
      expect(find.text('🙈'), findsOneWidget);
    });
  });
}
