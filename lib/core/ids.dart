import 'dart:math';

/// Generates a short, collision-resistant identifier for local entities.
///
/// There are no accounts or sync, so ids only need to be unique on-device.
/// Timestamp + random suffix is more than enough.
///
/// Web-safe: avoids `1 << 32` (which overflows dart2js' 32-bit bitwise shift)
/// and microsecond precision. [Random.nextInt] requires a bound that fits in a
/// 32-bit int, so we cap it at the 31-bit max.
String newId() {
  final ts = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
  final rand = _random.nextInt(0x7fffffff).toRadixString(36);
  return '$ts-$rand';
}

final Random _random = Random();
