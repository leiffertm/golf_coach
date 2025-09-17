import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'db.g.dart';

@DataClassName('ShotSpecRow')
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

@DataClassName('ShotAttemptRow')
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
  // Why: avoid blocking UI thread on open
  return NativeDatabase.createInBackground(file);
});
