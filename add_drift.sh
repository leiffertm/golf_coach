#!/usr/bin/env bash
set -euo pipefail
# Add Drift (SQLite) persistence and fix prior compile errors.
# Usage: bash add_drift.sh   (run from project root where pubspec.yaml lives)

# 1) Update pubspec.yaml with Drift deps
awk '
  BEGIN{inDeps=0; inDev=0}
  {
    print $0
    if ($0 ~ /^dependencies:/) {inDeps=1; next}
    if (inDeps==1 && $0 ~ /^dev_dependencies:/) {inDeps=0; inDev=1}
  }
' pubspec.yaml >/dev/null 2>&1 || true

# Append required deps if missing
add_dep(){ grep -q "^  $1:" pubspec.yaml || echo "  $1: $2" >> .pubspec.tmp; }
add_dev(){ grep -q "^  $1:" pubspec.yaml || echo "  $1: $2" >> .pubspec.dev.tmp; }

# Build new pubspec by splicing in deps after existing blocks
awk 'BEGIN{p=1}
{
  if($0 ~ /^dependencies:/){print; print "  drift: ^2.18.0\n  sqlite3_flutter_libs: ^0.5.24\n  path_provider: ^2.1.4\n  path: ^1.9.0"; next}
  if($0 ~ /^dev_dependencies:/){print; print "  drift_dev: ^2.18.0\n  build_runner: ^2.4.10"; next}
  print
}' pubspec.yaml > pubspec.yaml.tmp && mv pubspec.yaml.tmp pubspec.yaml

# 2) Create data layer with Drift
mkdir -p lib/src/data
cat > lib/src/data/db.dart <<'DART'
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'db.g.dart';

class ShotSpecs extends Table {
  TextColumn get id => text()();
  IntColumn get club => integer()();
  IntColumn get carryYards => integer()();
  IntColumn get trajectory => integer()();
  IntColumn get curveShape => integer()();
  IntColumn get curveMag => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class ShotAttempts extends Table {
  TextColumn get id => text()();
  TextColumn get specId => text().references(ShotSpecs, #id)();
  IntColumn get timestampMillis => integer()();
  IntColumn get carryYards => integer()();
  IntColumn get height => integer()();
  IntColumn get curveShape => integer()();
  IntColumn get curveMag => integer()();
  IntColumn get endSideYards => integer()();
  IntColumn get endShortLongYards => integer()();
  IntColumn get result => integer()();
  TextColumn get notes => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [ShotSpecs, ShotAttempts])
class AppDb extends _$AppDb {
  AppDb() : super(_open());
  @override
  int get schemaVersion => 1;
}

LazyDatabase _open() => LazyDatabase(() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'golf_coach.sqlite'));
  return NativeDatabase.createInBackground(file);
});
DART

# 3) Implement Drift-backed Store
cat > lib/src/domain/store_drift.dart <<'DART'
import 'package:drift/drift.dart' as d;
import '../data/db.dart';
import 'models.dart';
import 'store.dart';
import 'enums.dart';

int _e(Object e) => (e as dynamic).index as int; // enum -> int (why: compact storage)
T _d<T>(List<T> values, int i) => values[i];     // int -> enum

class DriftStore implements Store {
  final AppDb db;
  DriftStore({AppDb? db}) : db = db ?? AppDb();

  // ----- Specs -----
  @override
  Future<void> putSpec(ShotSpec spec) async {
    await db.into(db.shotSpecs).insertOnConflictUpdate(ShotSpecsCompanion(
      id: d.Value(spec.id),
      club: d.Value(_e(spec.club)),
      carryYards: d.Value(spec.carryYards),
      trajectory: d.Value(_e(spec.trajectory)),
      curveShape: d.Value(_e(spec.curveShape)),
      curveMag: d.Value(_e(spec.curveMag)),
    ));
  }

  @override
  Future<ShotSpec?> getSpec(String id) async {
    final row = await (db.select(db.shotSpecs)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return ShotSpec(
      id: row.id,
      club: _d(Club.values, row.club),
      carryYards: row.carryYards,
      trajectory: _d(Trajectory.values, row.trajectory),
      curveShape: _d(CurveShape.values, row.curveShape),
      curveMag: _d(CurveMag.values, row.curveMag),
    );
  }

  // ----- Attempts -----
  @override
  Future<void> putAttempt(ShotAttempt attempt) async {
    await db.into(db.shotAttempts).insertOnConflictUpdate(ShotAttemptsCompanion(
      id: d.Value(attempt.id),
      specId: d.Value(attempt.specId),
      timestampMillis: d.Value(attempt.timestamp.millisecondsSinceEpoch),
      carryYards: d.Value(attempt.carryYards),
      height: d.Value(_e(attempt.height)),
      curveShape: d.Value(_e(attempt.curveShape)),
      curveMag: d.Value(_e(attempt.curveMag)),
      endSideYards: d.Value(attempt.endSideYards),
      endShortLongYards: d.Value(attempt.endShortLongYards),
      result: d.Value(_e(attempt.result)),
      notes: d.Value(attempt.notes),
    ));
  }

  @override
  Future<List<ShotAttempt>> allAttempts() async {
    final rows = await (db.select(db.shotAttempts)
          ..orderBy([(t) => d.OrderingTerm(expression: t.timestampMillis)])
        ).get();
    return [
      for (final r in rows)
        ShotAttempt(
          id: r.id,
          specId: r.specId,
          timestamp: DateTime.fromMillisecondsSinceEpoch(r.timestampMillis),
          carryYards: r.carryYards,
          height: _d(Trajectory.values, r.height),
          curveShape: _d(CurveShape.values, r.curveShape),
          curveMag: _d(CurveMag.values, r.curveMag),
          endSideYards: r.endSideYards,
          endShortLongYards: r.endShortLongYards,
          result: _d(AttemptResult.values, r.result),
          notes: r.notes,
        ),
    ];
  }
}
DART

# 4) Switch AppModel to use DriftStore
perl -0777 -pe "s/PracticeService\(store: InMemoryStore\(\)\)/PracticeService(store: DriftStore())/g" -i lib/src/app_model.dart

# 5) Fix insights (records access) and scoring (double) if still present
# insights.dart: use positional record fields ($1,$2,$3)
sed -i '' -e "s/<PatternKey, List<\(double right, double short, bool opposite\)>>/<PatternKey, List<\(double, double, bool\)>>/" \
  -e "s/\.right\)/\.\$1)/g" \
  -e "s/\.short\)/\.\$2)/g" \
  -e "s/\.opposite\)/\.\$3)/g" lib/src/domain/insights.dart || true

# scoring.dart: ensure eCurveMag is double
perl -0777 -pe "s/final eCurveMag = magDelta == 0 \? 0 : \(magDelta == 1 \? 2 : 4\);/final double eCurveMag = magDelta == 0 ? 0.0 : (magDelta == 1 ? 2.0 : 4.0);/g" -i lib/src/domain/scoring.dart || true

# 6) Add build script to generate Drift code
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# 7) Analyze
flutter analyze

echo "\n✅ Drift integrated. Run: flutter run"
