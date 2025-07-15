extension IntExtension on int {
  DateTime milliSecondsToDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }

  double get toMegabytes {
    return this / (1024 * 1024);
  }

  bool get isSingle => this == 1;
}
