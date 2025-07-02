import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing/controller/details_service.dart';
import 'package:testing/screen/details_screen.dart';

void main() {
  group('DetailsScreen Widget Tests', () {
    late DetailsService detailsService;

    setUp(() {
      detailsService = DetailsService(count: 5); // initial count
    });

    testWidgets('displays initial count and message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DetailsScreen(
            detailsService: detailsService,
          ),
        ),
      );

      // For the Text widget showing the count
      expect(find.byKey(const Key('count_text')), findsOneWidget);
      expect(
          find
              .text('5')
              .evaluate()
              .where((element) => element.widget is Text)
              .length,
          1);

// For the input field having '5' as initial value
      final textFieldFinder = find.byKey(const Key('count_input_field'));
      expect(textFieldFinder, findsOneWidget);
      final textFieldWidget = tester.widget<TextField>(textFieldFinder);
      expect(textFieldWidget.controller?.text ?? '', '5');

      expect(find.byKey(const Key('message_text')), findsOneWidget);
      expect(find.text('Count is a multiple of 5'), findsOneWidget);
    });

    testWidgets('updates message on valid input and recalculate',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DetailsScreen(
            detailsService: detailsService,
          ),
        ),
      );

      // Enter new value
      await tester.enterText(find.byKey(const Key('count_input_field')), '3');
      await tester.tap(find.byKey(const Key('recalculate_button')));
      await tester.pumpAndSettle();

      // Expect updated count and message
      expect(find.text('3'), findsWidgets); // input and count
      expect(find.text('Regular count value'), findsOneWidget);
    });

    testWidgets('reset should restore initial count and message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DetailsScreen(
            detailsService: detailsService,
          ),
        ),
      );

      // Change state
      await tester.enterText(find.byKey(const Key('count_input_field')), '9');
      await tester.tap(find.byKey(const Key('recalculate_button')));
      await tester.pump();

      expect(find.text('9'), findsWidgets);
      expect(find.text('Regular count value'), findsOneWidget);

      // Reset
      await tester.tap(find.byKey(const Key('reset_button')));
      await tester.pump();

      expect(find.text('5'), findsWidgets);
      expect(find.text('Count is a multiple of 5'), findsOneWidget);
    });

    testWidgets('back button triggers pop navigation',
        (WidgetTester tester) async {
      final testObserver = _TestNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: DetailsScreen(
            detailsService: detailsService,
          ),
          navigatorObservers: [testObserver],
        ),
      );

      await tester.tap(find.byKey(const Key('back_button')));
      await tester.pumpAndSettle();

      expect(testObserver.didPopRoute, isTrue);
    });
  });
}

class _TestNavigatorObserver extends NavigatorObserver {
  bool didPopRoute = false;

  @override
  void didPop(Route route, Route? previousRoute) {
    didPopRoute = true;
    super.didPop(route, previousRoute);
  }
}
