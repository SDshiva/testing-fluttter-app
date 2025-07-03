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

      // Wait for posts to load
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Check if posts loaded or error occurred
      final postsListFinder = find.byKey(const Key('posts_list'));
      final errorCardFinder = find.byKey(const Key('error_card'));
      final loadingIndicatorFinder = find.byKey(const Key('loading_indicator'));

      if (tester.any(postsListFinder)) {
        // Posts loaded successfully
        expect(postsListFinder, findsOneWidget);

        // Check if post cards are present
        final postCardFinder = find.byWidgetPredicate((widget) =>
            widget is Card && widget.key.toString().contains('post_card_'));
        expect(postCardFinder, findsAtLeastNWidgets(1));
      } else if (tester.any(errorCardFinder)) {
        // Error occurred (network issues in testing environment)
        expect(errorCardFinder, findsOneWidget);
        expect(find.byKey(const Key('error_message')), findsOneWidget);
        expect(find.byKey(const Key('retry_button')), findsOneWidget);

        // Test retry functionality
        await tester.tap(find.byKey(const Key('retry_button')));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));
      } else if (tester.any(loadingIndicatorFinder)) {
        // Still loading, wait a bit more
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();
      }

      // Test random post loading
      await tester.tap(find.byKey(const Key('load_random_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      // Check if random post loaded or no internet
      final randomPostId = find.byKey(const Key('random_post_id'));
      final noRandomPostText = find.byKey(const Key('no_random_post_text'));

      if (tester.any(randomPostId)) {
        // Random post loaded successfully
        expect(find.byKey(const Key('random_post_title')), findsOneWidget);
        expect(find.byKey(const Key('random_post_body')), findsOneWidget);
      } else {
        // Either still loading or error occurred
        expect(noRandomPostText, findsOneWidget);
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

      // Verify we're back at home - use a more specific finder
      expect(find.byKey(const Key('api_data_button')), findsOneWidget);
      // Check for counter display instead of specific text
      expect(find.byType(FloatingActionButton), findsAtLeastNWidgets(1));
    });

    testWidgets('test error handling and retry', (WidgetTester tester) async {
      // This test simulates error scenarios
      app.main();
      await tester.pumpAndSettle();

      // Navigate to API Data screen
      await tester.tap(find.byKey(const Key('api_data_button')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      // If error card is present, test retry functionality
      if (tester.any(find.byKey(const Key('error_card')))) {
        expect(find.byKey(const Key('error_message')), findsOneWidget);
        expect(find.byKey(const Key('retry_button')), findsOneWidget);

        // Test retry
        await tester.tap(find.byKey(const Key('retry_button')));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));

        // Should show loading indicator
        expect(find.byKey(const Key('loading_indicator')), findsOneWidget);
      }
    });
  });

  group('API Data Screen Navigation Tests', () {
    testWidgets('navigation to and from API data screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify home screen using a more reliable finder
      expect(find.byKey(const Key('api_data_button')), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsAtLeastNWidgets(1));

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

      // Verify back at home using reliable finders
      expect(find.byKey(const Key('api_data_button')), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsAtLeastNWidgets(1));
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

      // Check if the button was disabled during loading
      // (This depends on network conditions)

      // Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
    });

    testWidgets('test posts list loading', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to API Data screen
      await tester.tap(find.byKey(const Key('api_data_button')));
      await tester.pumpAndSettle();

      // Initially should show loading
      expect(find.byKey(const Key('loading_indicator')), findsOneWidget);

      // Wait for loading to complete
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Check if posts loaded or error occurred
      final postsListFinder = find.byKey(const Key('posts_list'));
      final errorCardFinder = find.byKey(const Key('error_card'));
      final noPostsTextFinder = find.byKey(const Key('no_posts_text'));

      // One of these should be present
      expect(
        tester.any(postsListFinder) ||
            tester.any(errorCardFinder) ||
            tester.any(noPostsTextFinder),
        isTrue,
      );

      // Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
    });
  });
}
