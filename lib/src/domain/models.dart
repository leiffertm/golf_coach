import 'enums.dart';

typedef Id = String;

class ShotSpec {
  final Id id;
  final Club club;
  final int carryYards;
  final Trajectory trajectory;
  final CurveShape curveShape;
  final CurveMag curveMag;
  const ShotSpec({
    required this.id,
    required this.club,
    required this.carryYards,
    required this.trajectory,
    required this.curveShape,
    required this.curveMag,
  });
}

enum AttemptResult { executed, mulligan, aborted }

class ShotAttempt {
  final Id id;
  final Id specId;
  final DateTime timestamp;
  final int carryYards;
  final Trajectory height;
  final CurveShape curveShape;
  final CurveMag curveMag;
  final int endSideYards; // +R / -L
  final int endShortLongYards; // +long / -short
  final AttemptResult result;
  final String? notes;
  const ShotAttempt({
    required this.id,
    required this.specId,
    required this.timestamp,
    required this.carryYards,
    required this.height,
    required this.curveShape,
    required this.curveMag,
    required this.endSideYards,
    required this.endShortLongYards,
    required this.result,
    this.notes,
  });
}

class Session {
  final Id id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? location;
  final List<Id> attemptIds;
  const Session({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.location,
    this.attemptIds = const [],
  });
}

class ClubYardageRange {
  final int min;
  final int max;
  const ClubYardageRange({required this.min, required this.max});

  bool get isValid => min > 0 && max >= min;
}

class UserPrefs {
  final Units units;
  final SkillLevel skill;
  final Set<Club> inBag;
  final GeneratorStrictness generatorStrictness;
  final bool showClubChip;
  final bool showCarryChip;
  final Map<Club, ClubYardageRange> yardages;
  UserPrefs({
    this.units = Units.yards,
    this.skill = SkillLevel.intermediate,
    required Set<Club> inBag,
    this.generatorStrictness = GeneratorStrictness.defaultStrict,
    this.showClubChip = true,
    this.showCarryChip = true,
    Map<Club, ClubYardageRange> yardages = const <Club, ClubYardageRange>{},
  })  : inBag = Set.unmodifiable(inBag),
        yardages = Map.unmodifiable(yardages);

  UserPrefs copyWith({
    Units? units,
    SkillLevel? skill,
    Set<Club>? inBag,
    GeneratorStrictness? generatorStrictness,
    bool? showClubChip,
    bool? showCarryChip,
    Map<Club, ClubYardageRange>? yardages,
  }) {
    return UserPrefs(
      units: units ?? this.units,
      skill: skill ?? this.skill,
      inBag: inBag ?? this.inBag,
      generatorStrictness: generatorStrictness ?? this.generatorStrictness,
      showClubChip: showClubChip ?? this.showClubChip,
      showCarryChip: showCarryChip ?? this.showCarryChip,
      yardages: yardages ?? this.yardages,
    );
  }

  UserPrefs withInBag(Set<Club> newBag) => copyWith(inBag: newBag);
  UserPrefs withYardages(Map<Club, ClubYardageRange> newYardages) =>
      copyWith(yardages: newYardages);
}
