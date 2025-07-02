class CounterService {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
  }

  void decrement() {
    if (_counter > 0) {
      _counter--;
    }
  }

  void reset() {
    _counter = 0;
  }

  bool isEven() {
    return _counter % 2 == 0;
  }

  String getCounterStatus() {
    if (_counter == 0) {
      return 'Zero';
    } else if (_counter < 5) {
      return 'Low';
    } else if (_counter < 10) {
      return 'Medium';
    } else {
      return 'High';
    }
  }
}
