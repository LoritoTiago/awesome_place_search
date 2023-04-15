import 'dart:async';
import 'dart:ui';

abstract class IDebouncer {
  void call({required VoidCallback callback});
}

class Debouncer implements IDebouncer {
  final int milliseconds;

  Timer? _timer;

  Debouncer({
    required this.milliseconds,
  });

  @override
  void call({required VoidCallback callback}) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), callback);
  }
}
