class WatchTimer {
  DateTime? _start;

  void start() {
    _start = DateTime.now();
  }

  int stop() {
    if (_start == null) return 0;
    final seconds = DateTime.now().difference(_start!).inSeconds;
    _start = null;
    return seconds;
  }
}
