// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing/controller/counter_service.dart';
import 'package:testing/main.dart';
import 'package:testing/screen/counter_screen.dart';

void main() {
  group('CounterScreen Widget Tests', () {
    late CounterService counterService;

    setUp(() {
      counterService = CounterService();
    });

    testWidgets('should display initial counter value',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterScreen(counterService: counterService),
        ),
      );

      expect(find.text('0'), findsOneWidget);
      expect(find.byKey(const Key('counter_text')), findsOneWidget);
    });

    testWidgets('should display correct status and parity for initial value',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterScreen(counterService: counterService),
        ),
      );

      expect(find.text('Status: Zero'), findsOneWidget);
      expect(find.text('Even number'), findsOneWidget);
    });

    testWidgets('increment button should increase counter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterScreen(counterService: counterService),
        ),
      );

      // Find the increment button and tap it
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Status: Low'), findsOneWidget);
      expect(find.text('Odd number'), findsOneWidget);
    });

    testWidgets('decrement button should decrease counter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterScreen(counterService: counterService),
        ),
      );

      // First increment to have a positive value
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);

      // Then decrement
      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Status: Low'), findsOneWidget);
      expect(find.text('Odd number'), findsOneWidget);
    });

    testWidgets('decrement button should not go below 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterScreen(counterService: counterService),
        ),
      );

      // Try to decrement when counter is 0
      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
      expect(find.text('Status: Zero'), findsOneWidget);
    });

    testWidgets('reset button should reset counter to 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterScreen(counterService: counterService),
        ),
      );

      // Increment a few times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byKey(const Key('increment_button')));
      }
      await tester.pump();

      expect(find.text('5'), findsOneWidget);

      // Reset
      await tester.tap(find.byKey(const Key('reset_button')));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
      expect(find.text('Status: Zero'), findsOneWidget);
      expect(find.text('Even number'), findsOneWidget);
    });

    testWidgets('should find all required widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterScreen(counterService: counterService),
        ),
      );

      // Check that all key widgets are present
      expect(find.byKey(const Key('counter_text')), findsOneWidget);
      expect(find.byKey(const Key('status_text')), findsOneWidget);
      expect(find.byKey(const Key('parity_text')), findsOneWidget);
      expect(find.byKey(const Key('increment_button')), findsOneWidget);
      expect(find.byKey(const Key('decrement_button')), findsOneWidget);
      expect(find.byKey(const Key('reset_button')), findsOneWidget);
    });

    testWidgets('should display different statuses correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterScreen(counterService: counterService),
        ),
      );

      // Test "Low" status (1-4)
      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();
      expect(find.text('Status: Low'), findsOneWidget);

      // Test "Medium" status (5-9)
      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byKey(const Key('increment_button')));
      }
      await tester.pump();
      expect(find.text('Status: Medium'), findsOneWidget);

      // Test "High" status (10+)
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byKey(const Key('increment_button')));
      }
      await tester.pump();
      expect(find.text('Status: High'), findsOneWidget);
    });

    testWidgets('should handle rapid button taps', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterScreen(counterService: counterService),
        ),
      );

      // Rapidly tap increment button
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.byKey(const Key('increment_button')));
      }
      await tester.pump();

      expect(find.text('10'), findsOneWidget);
      expect(find.text('Status: High'), findsOneWidget);
      expect(find.text('Even number'), findsOneWidget);
    });
  });

  // If you want a separate smoke test, add it outside the group
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
