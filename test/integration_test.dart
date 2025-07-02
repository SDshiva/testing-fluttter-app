import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_testing_demo/main.dart' as app;
import 'package:testing/main.dart' as app;

void main() {
  group('Integration Tests', () {
    testWidgets('complete app workflow test', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Status: Zero'), findsOneWidget);
      expect(find.text('Even number'), findsOneWidget);

      // Test increment functionality
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Odd number'), findsOneWidget);

      // Test multiple increments
      for (int i = 0; i < 4; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
      }
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Status: Medium'), findsOneWidget);

      // Test decrement functionality
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(find.text('4'), findsOneWidget);
      expect(find.text('Status: Low'), findsOneWidget);

      // Test reset functionality
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Status: Zero'), findsOneWidget);
      expect(find.text('Even number'), findsOneWidget);
    });
  });
}
