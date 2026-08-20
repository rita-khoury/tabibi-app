import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabibi/main.dart';

void main() {
  testWidgets('Clinic app builds with an explicit theme mode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(initialThemeMode: ThemeMode.light));
    await tester.pump(const Duration(seconds: 4));

    expect(find.byType(MyApp), findsOneWidget);
  });
}
