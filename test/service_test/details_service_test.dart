import 'package:flutter_test/flutter_test.dart';
import 'package:testing/services/details_service.dart';

void main() {
  group('DetailsService Unit Tests', () {
    late DetailsService detailsService;

    setUp(() {
      // Start each test with count = 5
      detailsService = DetailsService(count: 5);
    });

    test('initial currentCount should match input count', () {
      expect(detailsService.currentCount, 5);
    });

    test('message should say "Count is a multiple of 5" if multiple of 5', () {
      expect(detailsService.message, 'Count is a multiple of 5');

      detailsService.updateCount(10);
      expect(detailsService.message, 'Count is a multiple of 5');
    });

    test('message should say "Regular count value" if not multiple of 5', () {
      detailsService.updateCount(1);
      expect(detailsService.message, 'Regular count value');

      detailsService.updateCount(7);
      expect(detailsService.message, 'Regular count value');
    });

    test('updateCount should update currentCount', () {
      expect(detailsService.currentCount, 5);

      detailsService.updateCount(9);
      expect(detailsService.currentCount, 9);
    });

    test('reset should restore to original count', () {
      detailsService.updateCount(3);
      expect(detailsService.currentCount, 3);

      detailsService.reset();
      expect(detailsService.currentCount, 5);
    });

    test('reset should not affect original count', () {
      detailsService.updateCount(0);
      expect(detailsService.currentCount, 0);

      detailsService.reset();
      expect(detailsService.currentCount, 5);

      // Update again to something else and reset
      detailsService.updateCount(100);
      detailsService.reset();
      expect(detailsService.currentCount, 5);
    });
  });
}
