import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_calc/main.dart';
import 'package:nexus_calc/screens/calculator_screen.dart';
import 'package:nexus_calc/widgets/button_grid.dart';
import 'package:nexus_calc/widgets/display_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('app boots into the calculator screen', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexusApp());
    await tester.pump();

    expect(find.byType(NexusApp), findsOneWidget);
    expect(find.byType(CalculatorScreen), findsOneWidget);
    expect(find.byType(DisplayPanel), findsOneWidget);
    expect(find.byType(ButtonGrid), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('history action is available in the app bar', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexusApp());
    await tester.pump();

    expect(find.byIcon(Icons.history_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
