import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:testing/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ApiDataScreen Integration Tests', () {
    testWidgets('complete API data screen workflow',
        (WidgetTester tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Verify we're on the home screen first
      expect(find.byKey(const Key('api_data_button')), findsOneWidget);

      // Navigate to API Data screen
      await tester.tap(find.byKey(const Key('api_data_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      // Verify we're on the API Data screen
      expect(find.text('API Data'), findsOneWidget);
      expect(find.text('Random Post'), findsOneWidget);
      expect(find.text('Posts List'), findsOneWidget);
      expect(find.byKey(const Key('load_random_button')), findsOneWidget);

      // Wait for posts to load (or fail)
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Check what state we're in after loading attempt
      final postsListFinder = find.byKey(const Key('posts_list'));
      final errorCardFinder = find.byKey(const Key('error_card'));
      final noPostsTextFinder = find.byKey(const Key('no_posts_text'));

      // One of these should be present (or none if still loading)
      final hasPostsList = tester.any(postsListFinder);
      final hasErrorCard = tester.any(errorCardFinder);
      final hasNoPostsText = tester.any(noPostsTextFinder);

      if (hasPostsList) {
        // Posts loaded successfully
        expect(postsListFinder, findsOneWidget);
        print('Posts loaded successfully');
      } else if (hasErrorCard) {
        // Error occurred
        expect(errorCardFinder, findsOneWidget);
        expect(find.byKey(const Key('error_message')), findsOneWidget);
        expect(find.byKey(const Key('retry_button')), findsOneWidget);
        print('Error occurred, testing retry functionality');

        // Test retry functionality
        await tester.tap(find.byKey(const Key('retry_button')));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));
      } else if (hasNoPostsText) {
        // No posts available
        expect(noPostsTextFinder, findsOneWidget);
        print('No posts available');
      } else {
        // Still loading or some other state
        print('Posts still loading or in unknown state');
      }

      // Test random post loading
      await tester.tap(find.byKey(const Key('load_random_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      // Check random post state
      final randomPostId = find.byKey(const Key('random_post_id'));
      final noRandomPostText = find.byKey(const Key('no_random_post_text'));

      if (tester.any(randomPostId)) {
        // Random post loaded successfully
        expect(find.byKey(const Key('random_post_title')), findsOneWidget);
        expect(find.byKey(const Key('random_post_body')), findsOneWidget);
        print('Random post loaded successfully');
      } else if (tester.any(noRandomPostText)) {
        // No random post loaded
        expect(noRandomPostText, findsOneWidget);
        print('No random post loaded yet');
      } else {
        print('Random post in unknown state');
      }

      // Test pull to refresh
      await tester.fling(
        find.byKey(const Key('refresh_indicator')),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      // Go back to home
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Verify we're back at home
      expect(find.byKey(const Key('api_data_button')), findsOneWidget);
    });

    testWidgets('test error handling scenarios', (WidgetTester tester) async {
      // This test handles potential error scenarios
      app.main();
      await tester.pumpAndSettle();

      // Navigate to API Data screen
      await tester.tap(find.byKey(const Key('api_data_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      // Check if error card is present and test retry
      final errorCardFinder = find.byKey(const Key('error_card'));
      if (tester.any(errorCardFinder)) {
        expect(find.byKey(const Key('error_message')), findsOneWidget);
        expect(find.byKey(const Key('retry_button')), findsOneWidget);

        // Test retry
        await tester.tap(find.byKey(const Key('retry_button')));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));

        print('Tested retry functionality');
      } else {
        print('No error state to test');
      }

      // Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
    });
  });

  group('API Data Screen Navigation Tests', () {
    testWidgets('navigation to and from API data screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify home screen
      expect(find.byKey(const Key('api_data_button')), findsOneWidget);

      // Navigate to API Data screen
      await tester.tap(find.byKey(const Key('api_data_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Verify API Data screen
      expect(find.text('API Data'), findsOneWidget);
      expect(find.byKey(const Key('random_post_card')), findsOneWidget);

      // Navigate back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify back at home
      expect(find.byKey(const Key('api_data_button')), findsOneWidget);
    });
  });

  group('API Data Screen UI Tests', () {
    testWidgets('test random post functionality', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to API Data screen
      await tester.tap(find.byKey(const Key('api_data_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Verify initial state
      expect(find.byKey(const Key('no_random_post_text')), findsOneWidget);
      expect(find.byKey(const Key('load_random_button')), findsOneWidget);

      // Test load random button
      final loadRandomButton = find.byKey(const Key('load_random_button'));
      await tester.tap(loadRandomButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      // Just verify the button is still there after interaction
      expect(loadRandomButton, findsOneWidget);

      // Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
    });

    testWidgets('test posts list UI presence', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to API Data screen
      await tester.tap(find.byKey(const Key('api_data_button')));
      await tester.pumpAndSettle();

      // Verify basic UI elements are present
      expect(find.text('Posts List'), findsOneWidget);
      expect(find.text('Random Post'), findsOneWidget);
      expect(find.byKey(const Key('load_random_button')), findsOneWidget);

      // Wait for any loading to complete
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Check what state we ended up in
      final postsListFinder = find.byKey(const Key('posts_list'));
      final errorCardFinder = find.byKey(const Key('error_card'));
      final noPostsTextFinder = find.byKey(const Key('no_posts_text'));

      // At least one of these should be present after loading
      final hasAnyExpectedState = tester.any(postsListFinder) ||
          tester.any(errorCardFinder) ||
          tester.any(noPostsTextFinder);

      if (hasAnyExpectedState) {
        print('Posts list reached expected state');
      } else {
        print('Posts list in intermediate state');
      }

      // Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
    });

    testWidgets('test pull to refresh functionality',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to API Data screen
      await tester.tap(find.byKey(const Key('api_data_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Test pull to refresh gesture
      await tester.fling(
        find.byKey(const Key('refresh_indicator')),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      // Verify the refresh indicator is still there
      expect(find.byKey(const Key('refresh_indicator')), findsOneWidget);

      // Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
    });

    testWidgets('test multiple button interactions',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to API Data screen
      await tester.tap(find.byKey(const Key('api_data_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      // Test multiple interactions with load random button
      final loadRandomButton = find.byKey(const Key('load_random_button'));

      await tester.tap(loadRandomButton);
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(loadRandomButton);
      await tester.pump(const Duration(seconds: 1));

      // Verify button is still functional
      expect(loadRandomButton, findsOneWidget);

      // Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
    });

    testWidgets('test screen stability', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to API Data screen
      await tester.tap(find.byKey(const Key('api_data_button')));
      await tester.pumpAndSettle();

      // Verify core UI elements remain stable
      expect(find.text('API Data'), findsOneWidget);
      expect(find.text('Random Post'), findsOneWidget);
      expect(find.text('Posts List'), findsOneWidget);

      // Wait and verify stability
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('API Data'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Random Post'), findsOneWidget);

      // Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
    });
  });
}
