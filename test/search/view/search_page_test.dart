import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:weather_challenge/app/settings/view/settings_page.dart';

void main() {
  group('SearchPage', () {
    testWidgets('is routable', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(SettingsPage.route());
              },
            ),
          ),
        ),
      ));
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsOneWidget);
    });
  });
  testWidgets('returns selected text when popped', (tester) async {
    String location;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                location = await Navigator.of(context).push(
                  SettingsPage.route(),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Chicago');
    await tester
        .tap(find.byKey(const Key('city_SelectionPage_search_iconButton')));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsNothing);
    expect(location, 'Chicago');
  });
}
