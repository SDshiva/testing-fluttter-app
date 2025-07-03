import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing/screen/api_data_screen.dart';

void main() {
  group('ApiDataScreen Widget Tests', () {
    testWidgets('should display initial UI elements',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('API Data'), findsOneWidget);
      expect(find.text('Random Post'), findsOneWidget);
      expect(find.text('Posts List'), findsOneWidget);
      expect(find.byKey(const Key('load_random_button')), findsOneWidget);
      expect(find.byKey(const Key('random_post_card')), findsOneWidget);
      expect(find.text('No random post loaded yet'), findsOneWidget);
    });

    testWidgets('should have correct app bar structure',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('API Data'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should show refresh indicator widget',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );

      // Assert
      expect(find.byKey(const Key('refresh_indicator')), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('should have scrollable content', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('should display random post section',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('Random Post'), findsOneWidget);
      expect(find.byKey(const Key('random_post_card')), findsOneWidget);
      expect(find.byKey(const Key('load_random_button')), findsOneWidget);
      expect(find.text('Load Random'), findsOneWidget);
      expect(find.text('No random post loaded yet'), findsOneWidget);
    });

    testWidgets('should display posts list section',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('Posts List'), findsOneWidget);
    });

    testWidgets('should handle button tap without crashing',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Act - Tap the load random button
      final loadRandomButton = find.byKey(const Key('load_random_button'));
      expect(loadRandomButton, findsOneWidget);

      await tester.tap(loadRandomButton);
      await tester.pump();

      // Assert - Should not crash and button should still exist
      expect(loadRandomButton, findsOneWidget);
    });

    testWidgets('should perform pull to refresh gesture',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Act - Perform pull to refresh
      await tester.fling(
        find.byKey(const Key('refresh_indicator')),
        const Offset(0, 300),
        1000,
      );
      await tester.pump();

      // Assert - Should complete without crashing
      expect(find.byKey(const Key('refresh_indicator')), findsOneWidget);
    });

    testWidgets('should have all required UI components',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Assert - Check all main UI components exist
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Card),
          findsAtLeastNWidgets(1)); // At least the random post card
      expect(find.byType(ElevatedButton),
          findsAtLeastNWidgets(1)); // Load random button
    });

    testWidgets('should handle multiple button taps',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Act - Tap button multiple times
      final loadRandomButton = find.byKey(const Key('load_random_button'));

      await tester.tap(loadRandomButton);
      await tester.pump();

      await tester.tap(loadRandomButton);
      await tester.pump();

      await tester.tap(loadRandomButton);
      await tester.pump();

      // Assert - Should handle multiple taps without crashing
      expect(loadRandomButton, findsOneWidget);
    });

    testWidgets('should display card widgets properly',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Assert - Check card structure
      expect(find.byKey(const Key('random_post_card')), findsOneWidget);
      expect(find.byType(Card), findsAtLeastNWidgets(1));

      // Check content inside random post card
      expect(find.text('Random Post'), findsOneWidget);
      expect(find.text('Load Random'), findsOneWidget);
      expect(find.text('No random post loaded yet'), findsOneWidget);
    });

    testWidgets('should have proper text content', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Assert - Check all expected text content
      expect(find.text('API Data'), findsOneWidget);
      expect(find.text('Random Post'), findsOneWidget);
      expect(find.text('Posts List'), findsOneWidget);
      expect(find.text('Load Random'), findsOneWidget);
      expect(find.text('No random post loaded yet'), findsOneWidget);
    });

    testWidgets('should handle widget lifecycle properly',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );

      // Pump multiple times to simulate widget lifecycle
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Should remain stable
      expect(find.text('API Data'), findsOneWidget);
      expect(find.byKey(const Key('load_random_button')), findsOneWidget);
    });

    testWidgets('should maintain UI state during interactions',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: ApiDataScreen(),
        ),
      );
      await tester.pump();

      // Act - Interact with UI elements
      await tester.tap(find.byKey(const Key('load_random_button')));
      await tester.pump();

      // Perform scroll
      await tester.drag(
          find.byType(SingleChildScrollView), const Offset(0, -100));
      await tester.pump();

      // Assert - UI should maintain its structure
      expect(find.text('API Data'), findsOneWidget);
      expect(find.text('Random Post'), findsOneWidget);
      expect(find.text('Posts List'), findsOneWidget);
      expect(find.byKey(const Key('load_random_button')), findsOneWidget);
    });
  });
}
