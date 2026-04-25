import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_calc/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('calculator renders the main mobile interface', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexusApp());
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('NEXUS'), findsOneWidget);
    expect(find.byIcon(Icons.history_rounded), findsOneWidget);
    expect(find.text('='), findsOneWidget);
    expect(find.text('AC'), findsOneWidget);
  });

  testWidgets('history panel opens from the app bar', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexusApp());
    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.byIcon(Icons.history_rounded));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('HISTORY'), findsOneWidget);
  });
}
