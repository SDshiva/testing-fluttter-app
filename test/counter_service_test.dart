import 'package:flutter_test/flutter_test.dart';
import 'package:testing/controller/counter_service.dart';

void main() {
  group('CounterService Unit Tests', () {
    late CounterService counterService;

    setUp(() {
      // Create a fresh instance before each test
      counterService = CounterService();
    });

    test('initial counter value should be 0', () {
      expect(counterService.counter, 0);
    });

    test('increment should increase counter by 1', () {
      counterService.increment();
      expect(counterService.counter, 1);

      counterService.increment();
      expect(counterService.counter, 2);
    });

    test('decrement should decrease counter by 1', () {
      // First increment to have a positive value
      counterService.increment();
      counterService.increment();
      expect(counterService.counter, 2);

      counterService.decrement();
      expect(counterService.counter, 1);
    });

    test('decrement should not go below 0', () {
      expect(counterService.counter, 0);

      counterService.decrement();
      expect(counterService.counter, 0);
    });

    test('reset should set counter to 0', () {
      counterService.increment();
      counterService.increment();
      counterService.increment();
      expect(counterService.counter, 3);

      counterService.reset();
      expect(counterService.counter, 0);
    });

    group('isEven tests', () {
      test('should return true for even numbers', () {
        expect(counterService.isEven(), true); // 0 is even

        counterService.increment();
        counterService.increment();
        expect(counterService.isEven(), true); // 2 is even
      });

      test('should return false for odd numbers', () {
        counterService.increment();
        expect(counterService.isEven(), false); // 1 is odd

        counterService.increment();
        counterService.increment();
        expect(counterService.isEven(), false); // 3 is odd
      });
    });

    group('getCounterStatus tests', () {
      test('should return "Zero" for 0', () {
        expect(counterService.getCounterStatus(), 'Zero');
      });

      test('should return "Low" for values 1-4', () {
        counterService.increment(); // 1
        expect(counterService.getCounterStatus(), 'Low');

        for (int i = 0; i < 3; i++) {
          counterService.increment();
        }
        expect(counterService.counter, 4);
        expect(counterService.getCounterStatus(), 'Low');
      });

      test('should return "Medium" for values 5-9', () {
        for (int i = 0; i < 5; i++) {
          counterService.increment();
        }
        expect(counterService.getCounterStatus(), 'Medium');

        for (int i = 0; i < 4; i++) {
          counterService.increment();
        }
        expect(counterService.counter, 9);
        expect(counterService.getCounterStatus(), 'Medium');
      });

      test('should return "High" for values 10 and above', () {
        for (int i = 0; i < 10; i++) {
          counterService.increment();
        }
        expect(counterService.getCounterStatus(), 'High');

        counterService.increment();
        expect(counterService.getCounterStatus(), 'High');
      });
    });
  });
}
