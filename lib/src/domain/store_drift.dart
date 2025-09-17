import 'package:drift/drift.dart' as d;
import '../data/db.dart';
import 'models.dart' as domain;
import 'store.dart';
import 'enums.dart';

int _toIndex(Object e) => (e as dynamic).index as int; // keep storage compact
T _fromIndex<T>(List<T> values, int i) => values[i];

class DriftStore implements Store {
  final AppDb db;
  DriftStore({AppDb? db}) : db = db ?? AppDb();

  // ---- Specs ----
  @override
  Future<void> putSpec(domain.ShotSpec spec) async {
    await db.into(db.shotSpecs).insertOnConflictUpdate(ShotSpecsCompanion(
      id: d.Value(spec.id),
      club: d.Value(_toIndex(spec.club)),
      carryYards: d.Value(spec.carryYards),
      trajectory: d.Value(_toIndex(spec.trajectory)),
      curveShape: d.Value(_toIndex(spec.curveShape)),
      curveMag: d.Value(_toIndex(spec.curveMag)),
    ));
  }

  @override
  Future<domain.ShotSpec?> getSpec(String id) async {
    final row = await (db.select(db.shotSpecs)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return domain.ShotSpec(
      id: row.id,
      club: _fromIndex(Club.values, row.club),
      carryYards: row.carryYards,
      trajectory: _fromIndex(Trajectory.values, row.trajectory),
      curveShape: _fromIndex(CurveShape.values, row.curveShape),
      curveMag: _fromIndex(CurveMag.values, row.curveMag),
    );
    // Why: translate DB row ↔ domain model to keep UI/store separated cleanly
  }

  // ---- Attempts ----
  @override
  Future<void> putAttempt(domain.ShotAttempt attempt) async {
    await db.into(db.shotAttempts).insertOnConflictUpdate(ShotAttemptsCompanion(
      id: d.Value(attempt.id),
      specId: d.Value(attempt.specId),
      timestampMillis: d.Value(attempt.timestamp.millisecondsSinceEpoch),
      carryYards: d.Value(attempt.carryYards),
      height: d.Value(_toIndex(attempt.height)),
      curveShape: d.Value(_toIndex(attempt.curveShape)),
      curveMag: d.Value(_toIndex(attempt.curveMag)),
      endSideYards: d.Value(attempt.endSideYards),
      endShortLongYards: d.Value(attempt.endShortLongYards),
      result: d.Value(_toIndex(attempt.result)),
      notes: d.Value(attempt.notes),
    ));
  }

  @override
  Future<List<domain.ShotAttempt>> allAttempts() async {
    final rows = await (db.select(db.shotAttempts)
          ..orderBy([(t) => d.OrderingTerm(expression: t.timestampMillis)]))
        .get();
    return [
      for (final r in rows)
        domain.ShotAttempt(
          id: r.id,
          specId: r.specId,
          timestamp: DateTime.fromMillisecondsSinceEpoch(r.timestampMillis),
          carryYards: r.carryYards,
          height: _fromIndex(Trajectory.values, r.height),
          curveShape: _fromIndex(CurveShape.values, r.curveShape),
          curveMag: _fromIndex(CurveMag.values, r.curveMag),
          endSideYards: r.endSideYards,
          endShortLongYards: r.endShortLongYards,
          result: _fromIndex(domain.AttemptResult.values, r.result),
          notes: r.notes,
        ),
    ];
  }
}