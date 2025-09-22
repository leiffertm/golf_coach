import 'enums.dart';
import 'models.dart';

class ScoreResult {
  final int score;
  final double eCarry, eHeight, eCurveShape, eCurveMag, eSide;
  const ScoreResult({
    required this.score,
    required this.eCarry,
    required this.eHeight,
    required this.eCurveShape,
    required this.eCurveMag,
    required this.eSide,
  });
}

class Scoring {
  static ScoreResult score({required SkillLevel skill, required ShotSpec spec, required ShotAttempt attempt}) {
    final eCarry = (attempt.carryYards - spec.carryYards).abs().toDouble();
    final eHeight = _heightErr(attempt.height, spec.trajectory);
    final eCurveShape = _curveShapeErr(attempt.curveShape, spec.curveShape);

    final magDelta = ([_mag(attempt.curveMag), _mag(spec.curveMag)]..sort()).reduce((a, b) => (b - a).abs());
    final double eCurveMag = magDelta == 0 ? 0.0 : (magDelta == 1 ? 2.0 : 4.0);

    final targetSide = switch (spec.curveMag) {
          CurveMag.small => 5,
          CurveMag.medium => 10,
          CurveMag.large => 18,
        } * (spec.curveShape == CurveShape.fade ? 1 : spec.curveShape == CurveShape.draw ? -1 : 0);
    final eSide = (attempt.endSideYards - targetSide).abs().toDouble();

    final (w1, w2, w3, w4, w5) = _weights(skill);
    final raw = w1 * eCarry + w2 * eHeight + w3 * eCurveShape + w4 * eCurveMag + w5 * eSide;
    final score = (100 - raw).clamp(0, 100).round();
    return ScoreResult(
      score: score,
      eCarry: eCarry,
      eHeight: eHeight,
      eCurveShape: eCurveShape,
      eCurveMag: eCurveMag,
      eSide: eSide,
    );
  }

  static double _heightErr(Trajectory a, Trajectory b) {
    if (a == b) return 0;
    final adj = (a == Trajectory.low && b == Trajectory.normal) ||
        (a == Trajectory.normal && (b == Trajectory.low || b == Trajectory.high)) ||
        (a == Trajectory.high && b == Trajectory.normal);
    return adj ? 4 : 8;
  }

  static double _curveShapeErr(CurveShape a, CurveShape b) {
    if (a == b) return 0;
    if (a == CurveShape.straight || b == CurveShape.straight) return 5;
    return 10;
  }

  static int _mag(CurveMag m) => switch (m) { CurveMag.small => 0, CurveMag.medium => 1, CurveMag.large => 2 };

  static (double, double, double, double, double) _weights(SkillLevel s) {
    final base = (0.8, 1.0, 1.2, 0.7, 0.5);
    final k = switch (s) {
      SkillLevel.beginner => 0.8,
      SkillLevel.intermediate => 1.0,
      SkillLevel.advanced => 1.2,
      SkillLevel.plus => 1.35,
    };
    return (base.$1 * k, base.$2 * k, base.$3 * k, base.$4 * k, base.$5 * k);
  }
}

