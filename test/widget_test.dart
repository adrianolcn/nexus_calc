import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_calc/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('calculator renders and performs a basic operation', (tester) async {
    await tester.pumpWidget(const NexusApp());
    await tester.pumpAndSettle();

    expect(find.text('NEXUS'), findsOneWidget);
    expect(find.text('='), findsOneWidget);

    await tester.tap(find.text('2'));
    await tester.pump();
    await tester.tap(find.text('+'));
    await tester.pump();
    await tester.tap(find.text('3'));
    await tester.pump();
    await tester.tap(find.text('='));
    await tester.pumpAndSettle();

    expect(find.text('5'), findsWidgets);
  });

  testWidgets('history panel opens from the app bar', (tester) async {
    await tester.pumpWidget(const NexusApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.history_rounded));
    await tester.pumpAndSettle();

    expect(find.text('HISTORY'), findsOneWidget);
  });
}
