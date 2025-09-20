import 'dart:math';
import 'enums.dart';
import 'models.dart';
import 'util_id.dart';
import 'club_distance_table.dart';

class ShotGenerator {
  final IdGen _idGen;
  final Random _rng;
  ShotGenerator([int? seed])
      : _idGen = IdGen(seed),
        _rng = Random(seed);

  ShotSpec generate({
    required Set<Club> inBag,
    required SkillLevel skill,
    GeneratorStrictness strictness = GeneratorStrictness.defaultStrict,
    Map<Club, ClubYardageRange> yardages = const <Club, ClubYardageRange>{},
  }) {
    if (inBag.isEmpty) {
      throw StateError('No clubs in bag');
    }
    final club = inBag.elementAt(_rng.nextInt(inBag.length));
    final (defaultMin, defaultMax) = ClubDistanceTable.range(club, skill);
    final customRange = yardages[club];
    final min = customRange?.min ?? defaultMin;
    final max = customRange?.max ?? defaultMax;
    final bandTightener = switch (strictness) {
      GeneratorStrictness.relaxed => 0.0,
      GeneratorStrictness.defaultStrict => 0.15,
      GeneratorStrictness.strict => 0.3,
    };
    int low;
    int high;
    if (max <= min) {
      low = min;
      high = min;
    } else {
      final span = (max - min).toDouble();
      final tightSpan = (span * (1.0 - bandTightener)).clamp(12, span);
      low = min + ((span - tightSpan) / 2).round();
      high = (low + tightSpan).round();
    }
    final carry = _randInt(low, high);

    final trajectory = _pick<Trajectory>(
        [(Trajectory.normal, .6), (Trajectory.low, .2), (Trajectory.high, .2)]);
    final curveShape = _pick<CurveShape>([
      (CurveShape.draw, .35),
      (CurveShape.straight, .30),
      (CurveShape.fade, .35)
    ]);
    final curveMag = _pick<CurveMag>(
        [(CurveMag.small, .5), (CurveMag.medium, .35), (CurveMag.large, .15)]);

    return ShotSpec(
      id: _idGen.next('spec'),
      club: club,
      carryYards: carry,
      trajectory: trajectory,
      curveShape: curveShape,
      curveMag: curveMag,
    );
  }

  int _randInt(int a, int b) => a + _rng.nextInt((b - a + 1).clamp(1, 1000000));
  T _pick<T>(List<(T, double)> xs) {
    final total = xs.fold<double>(0, (s, e) => s + e.$2);
    final r = _rng.nextDouble() * total;
    double c = 0;
    for (final (v, w) in xs) {
      c += w;
      if (r <= c) return v;
    }
    return xs.last.$1;
  }
}
