import 'dart:math';
class IdGen {
  final Random _rng;
  IdGen([int? seed]) : _rng = Random(seed);
  String next(String prefix) => '$prefix-${DateTime.now().microsecondsSinceEpoch}-${_rng.nextInt(1 << 32)}';
}
