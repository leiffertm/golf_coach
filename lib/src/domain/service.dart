import 'enums.dart';
import 'generator.dart';
import 'insights.dart';
import 'models.dart';
import 'scoring.dart';
import 'store.dart';
import 'util_id.dart';

class PracticeService {
  final Store store;
  final IdGen _ids = IdGen();
  final ShotGenerator _gen = ShotGenerator();

  PracticeService({required this.store});

  Future<ShotSpec> generateSpec(UserPrefs prefs) async {
    final spec = _gen.generate(
      inBag: prefs.inBag,
      skill: prefs.skill,
      strictness: prefs.generatorStrictness,
      yardages: prefs.yardages,
    );
    await store.putSpec(spec);
    return spec;
  }

  Future<(ShotAttempt, ScoreResult)> logAttempt({
    required ShotSpec spec,
    required int carryYards,
    required Trajectory height,
    required CurveShape curveShape,
    required CurveMag curveMag,
    required int endSideYards,
    String? notes,
    required SkillLevel skill,
  }) async {
    final attempt = ShotAttempt(
      id: _ids.next('attempt'),
      specId: spec.id,
      timestamp: DateTime.now(),
      carryYards: carryYards,
      height: height,
      curveShape: curveShape,
      curveMag: curveMag,
      endSideYards: endSideYards,
      endShortLongYards: carryYards - spec.carryYards,
      notes: notes,
    );
    final scoreRes = Scoring.score(skill: skill, spec: spec, attempt: attempt);
    await store.putAttempt(attempt, score: scoreRes.score);
    return (attempt, scoreRes);
  }

  Future<List<PatternStats>> computeInsights({bool perClub = false}) async {
    final attempts = await store.allAttempts();
    final specsById = <String, ShotSpec>{};
    for (final a in attempts) {
      final s = await store.getSpec(a.specId);
      if (s != null) specsById[a.specId] = s;
    }
    final engine = InsightEngine();
    return engine.compute(
        attempts: attempts, specsById: specsById, perClub: perClub);
  }
}
