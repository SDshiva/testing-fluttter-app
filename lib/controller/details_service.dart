class DetailsService {
  int _originalCount = 0;
  int _currentCount = 0;

  DetailsService({required int count}) {
    _originalCount = count;
    _currentCount = count;
  }

  int get currentCount => _currentCount;

  String get message {
    if (_currentCount % 5 == 0 && _currentCount != 0) {
      return 'Count is a multiple of 5';
    }
    return 'Regular count value';
  }

  void updateCount(int newCount) {
    _currentCount = newCount;
  }

  void reset() {
    _currentCount = _originalCount;
  }
}
