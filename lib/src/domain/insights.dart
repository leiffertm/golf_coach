import 'enums.dart';
import 'models.dart';

class PatternKey {
  final Trajectory trajectory;
  final CurveShape curveShape;
  final Club? club;
  const PatternKey({required this.trajectory, required this.curveShape, this.club});

  @override
  bool operator ==(Object other) =>
      other is PatternKey && trajectory == other.trajectory && curveShape == other.curveShape && club == other.club;
  @override
  int get hashCode => Object.hash(trajectory, curveShape, club);
}

class PatternStats {
  final PatternKey key;
  final int count;
  final double avgRight; // +R / -L
  final double avgShort; // -short / +long
  final double oppositeShapeRate;
  final double medianScore; // reserved

  const PatternStats({
    required this.key,
    required this.count,
    required this.avgRight,
    required this.avgShort,
    required this.oppositeShapeRate,
    required this.medianScore,
  });

  String toUserString() {
    final dir = avgRight >= 0 ? '${avgRight.abs().round()} yards right' : '${avgRight.abs().round()} yards left';
    final dist = avgShort <= 0 ? '${avgShort.abs().round()} yards short' : '${avgShort.round()} yards long';
    final traj = _cap(key.trajectory.name);
    final shape = key.curveShape.name;
    final clubTxt = key.club != null ? ' with ${key.club!.label}' : '';
    return 'When given a $traj $shape$clubTxt, you tend to miss on average $dir and $dist.';
  }

  String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class InsightEngine {
  List<PatternStats> compute({
    required List<ShotAttempt> attempts,
    required Map<String, ShotSpec> specsById,
    bool perClub = false,
  }) {
    final map = <PatternKey, List<(double, double, bool)>>{}; // (right, short, opposite)
    for (final a in attempts) {
      if (a.result != AttemptResult.executed) continue;
      final spec = specsById[a.specId];
      if (spec == null) continue;
      final key = PatternKey(
        trajectory: spec.trajectory,
        curveShape: spec.curveShape,
        club: perClub ? spec.club : null,
      );
      final list = map.putIfAbsent(key, () => <(double, double, bool)>[]);
      list.add((
        a.endSideYards.toDouble(),
        (a.carryYards - spec.carryYards).toDouble() * -1,
        _isOpposite(spec.curveShape, a.curveShape),
      ));
    }

    final out = <PatternStats>[];
    map.forEach((k, xs) {
      final n = xs.length;
      if (n == 0) return;
      final sumR = xs.fold<double>(0, (s, e) => s + e.$1);
      final sumS = xs.fold<double>(0, (s, e) => s + e.$2);
      final opp = xs.where((e) => e.$3).length / n;
      out.add(PatternStats(
        key: k,
        count: n,
        avgRight: sumR / n,
        avgShort: sumS / n,
        oppositeShapeRate: opp,
        medianScore: 0,
      ));
    });
    out.sort((a, b) => b.count.compareTo(a.count));
    return out;
  }

  bool _isOpposite(CurveShape target, CurveShape actual) {
    if (target == CurveShape.straight || actual == CurveShape.straight) return false;
    return (target == CurveShape.draw && actual == CurveShape.fade) ||
        (target == CurveShape.fade && actual == CurveShape.draw);
  }
}
