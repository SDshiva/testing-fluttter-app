import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:testing/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('CounterScreen Integration Tests', () {
    testWidgets('complete app workflow test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Verify initial state
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Status: Zero'), findsOneWidget);
      expect(find.text('Even number'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));

      // Increment once
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Odd number'), findsOneWidget);

      // Increment 4 more times
      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Status: Medium'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));

      // Decrement
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('4'), findsOneWidget);
      expect(find.text('Status: Low'), findsOneWidget);

      // Reset
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Status: Zero'), findsOneWidget);
      expect(find.text('Even number'), findsOneWidget);
    });
  });

  group('DetailsScreen Integration Tests', () {
    testWidgets('navigate and interact with details screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Tap increment 5 times to reach count 5
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 500));
      }

      // Navigate to details screen
      final detailsButton = find.byKey(const Key('details_button'));
      expect(detailsButton, findsOneWidget);
      await tester.tap(detailsButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Check current count and message
      final countText = find.byKey(const Key('count_text'));
      final messageText = find.byKey(const Key('message_text'));

      expect(countText, findsOneWidget);
      expect(messageText, findsOneWidget);
      expect(find.text('Count is a multiple of 5'), findsOneWidget);

      // Change input to 3 and recalculate
      final inputField = find.byKey(const Key('count_input_field'));
      await tester.enterText(inputField, '3');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('recalculate_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('3'), findsWidgets); // input field + display
      expect(find.text('Regular count value'), findsOneWidget);

      // Press reset
      await tester.tap(find.byKey(const Key('reset_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('5'), findsWidgets); // input field + display
      expect(find.text('Count is a multiple of 5'), findsOneWidget);

      // Press back
      await tester.tap(find.byKey(const Key('back_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Confirm we're back to CounterScreen
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Status: Medium'), findsOneWidget);
    });
  });
}
