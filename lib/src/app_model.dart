import 'package:flutter/foundation.dart';
import 'domain/enums.dart';
import 'domain/models.dart';
import 'domain/service.dart';
// ignore: unused_import
import 'domain/store.dart';
import 'domain/insights.dart';
import 'domain/scoring.dart';
import 'domain/store_drift.dart'; // <-- import Drift-backed store
import 'domain/custom_distances_loader.dart';

class AppModel extends ChangeNotifier {
  final PracticeService service;
  UserPrefs prefs;
  ShotSpec? currentSpec;
  ScoreResult? lastScore;
  List<PatternStats> insights = const [];
  int totalAttempts = 0;
  double avgScore = 0;

  AppModel({required this.service, required this.prefs});

  static Future<AppModel> initial() async {
    // Load custom distances and selected clubs from JSON file
    final customDistances = await CustomDistancesLoader.loadCustomDistances();
    final selectedClubs = await CustomDistancesLoader.getSelectedClubs();
    
    return AppModel(
      service: PracticeService(store: DriftStore()), // <-- use Drift
      prefs: UserPrefs(
        inBag: selectedClubs, // Use clubs that have valid distances in JSON
        skill: SkillLevel.intermediate,
        yardages: customDistances, // Use custom distances as default yardages
      ),
    );
  }

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
    prefs = prefs.copyWith(skill: s);
    notifyListeners();
  }

  void updateStrictness(GeneratorStrictness g) {
    prefs = prefs.copyWith(generatorStrictness: g);
    notifyListeners();
  }

  void toggleClub(Club c, bool on) {
    final bag = {...prefs.inBag};
    on ? bag.add(c) : bag.remove(c);
    var showCarry = prefs.showCarryChip;
    if (showCarry && !_bagHasCompleteRanges(bag, prefs.yardages)) {
      showCarry = false;
    }
    prefs = prefs.copyWith(inBag: bag, showCarryChip: showCarry);
    notifyListeners();
  }

  void setShowClubChip(bool on) {
    if (!on && !prefs.showCarryChip) return;
    prefs = prefs.copyWith(showClubChip: on);
    notifyListeners();
  }

  bool setShowCarryChip(bool on) {
    if (!on && !prefs.showClubChip) return false;
    if (on && !_bagHasCompleteRanges(prefs.inBag, prefs.yardages)) {
      return false;
    }
    prefs = prefs.copyWith(showCarryChip: on);
    notifyListeners();
    return true;
  }

  bool updateClubYardageRange(Club club, {int? min, int? max}) {
    final yardages = Map<Club, ClubYardageRange>.from(prefs.yardages);
    final hasRange = min != null && max != null && min > 0 && max >= min;
    if (hasRange) {
      yardages[club] = ClubYardageRange(min: min, max: max);
    } else {
      yardages.remove(club);
    }

    var showCarry = prefs.showCarryChip;
    if (showCarry && !_bagHasCompleteRanges(prefs.inBag, yardages)) {
      showCarry = false;
    }

    prefs = prefs.copyWith(yardages: yardages, showCarryChip: showCarry);
    notifyListeners();
    return hasRange;
  }

  bool get hasCompleteYardages =>
      _bagHasCompleteRanges(prefs.inBag, prefs.yardages);

  List<Club> get clubsMissingYardages => prefs.inBag
      .where((club) => !(prefs.yardages[club]?.isValid ?? false))
      .toList(growable: false);

  static bool _bagHasCompleteRanges(
      Set<Club> bag, Map<Club, ClubYardageRange> yardages) {
    for (final club in bag) {
      final range = yardages[club];
      if (range == null || !range.isValid) {
        return false;
      }
    }
    return true;
  }
}
