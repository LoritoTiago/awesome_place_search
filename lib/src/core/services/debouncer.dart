import 'dart:async';
import 'dart:ui';

abstract class IDebounce {
  void call({required VoidCallback callback});
}

class Debounce implements IDebounce {
  final int milliseconds;

  Timer? _timer;

  Debounce({
    required this.milliseconds,
  });

  @override
  void call({required VoidCallback callback}) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), callback);
  }
}
