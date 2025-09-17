import 'package:flutter/foundation.dart';
import 'domain/enums.dart';
import 'domain/models.dart';
import 'domain/service.dart';
// ignore: unused_import
import 'domain/store.dart';
import 'domain/insights.dart';
import 'domain/scoring.dart';
import 'domain/store_drift.dart'; // <-- import Drift-backed store

class AppModel extends ChangeNotifier {
  final PracticeService service;
  UserPrefs prefs;
  ShotSpec? currentSpec;
  ScoreResult? lastScore;
  List<PatternStats> insights = const [];
  int totalAttempts = 0;
  double avgScore = 0;

  AppModel({required this.service, required this.prefs});

  factory AppModel.initial() => AppModel(
        service: PracticeService(store: DriftStore()), // <-- use Drift
        prefs: UserPrefs(
          inBag: {
            Club.driver, Club.w3, Club.h4,
            Club.i7, Club.i8, Club.i9, Club.pw, Club.sw,
          },
          skill: SkillLevel.intermediate,
        ),
      );

  Future<void> generate() async {
    currentSpec = await service.generateSpec(prefs);
    notifyListeners();
  }

  Future<void> logAttempt({
    required int carry,
    required Trajectory height,
    required CurveShape curveShape,
    required CurveMag curveMag,
    required int endSide,
    required AttemptResult result,
    String? notes,
  }) async {
    final spec = currentSpec;
    if (spec == null) return;
    final res = await service.logAttempt(
      spec: spec,
      carryYards: carry,
      height: height,
      curveShape: curveShape,
      curveMag: curveMag,
      endSideYards: endSide,
      result: result,
      notes: notes,
      skill: prefs.skill,
    );
    lastScore = res.$2;
    await _refreshStats();
    notifyListeners();
  }

  Future<void> _refreshStats() async {
    insights = await service.computeInsights(perClub: false);
    final attempts = await service.store.allAttempts();
    totalAttempts = attempts.length;
    if (attempts.isEmpty) {
      avgScore = 0;
      return;
    }
    double sum = 0;
    for (final a in attempts) {
      final spec = await service.store.getSpec(a.specId);
      if (spec == null) continue;
      sum += Scoring.score(skill: prefs.skill, spec: spec, attempt: a).score;
    }
    avgScore = sum / attempts.length;
  }

  void updateSkill(SkillLevel s) {
    prefs = UserPrefs(units: prefs.units, skill: s, inBag: prefs.inBag, generatorStrictness: prefs.generatorStrictness);
    notifyListeners();
  }

  void updateStrictness(GeneratorStrictness g) {
    prefs = UserPrefs(units: prefs.units, skill: prefs.skill, inBag: prefs.inBag, generatorStrictness: g);
    notifyListeners();
  }

  void toggleClub(Club c, bool on) {
    final bag = {...prefs.inBag};
    on ? bag.add(c) : bag.remove(c);
    prefs = prefs.withInBag(bag);
    notifyListeners();
  }
}