// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $ShotSpecsTable extends ShotSpecs
    with TableInfo<$ShotSpecsTable, ShotSpecRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShotSpecsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clubMeta = const VerificationMeta('club');
  @override
  late final GeneratedColumn<int> club = GeneratedColumn<int>(
      'club', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _carryYardsMeta =
      const VerificationMeta('carryYards');
  @override
  late final GeneratedColumn<int> carryYards = GeneratedColumn<int>(
      'carry_yards', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _trajectoryMeta =
      const VerificationMeta('trajectory');
  @override
  late final GeneratedColumn<int> trajectory = GeneratedColumn<int>(
      'trajectory', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _curveShapeMeta =
      const VerificationMeta('curveShape');
  @override
  late final GeneratedColumn<int> curveShape = GeneratedColumn<int>(
      'curve_shape', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _curveMagMeta =
      const VerificationMeta('curveMag');
  @override
  late final GeneratedColumn<int> curveMag = GeneratedColumn<int>(
      'curve_mag', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, club, carryYards, trajectory, curveShape, curveMag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shot_specs';
  @override
  VerificationContext validateIntegrity(Insertable<ShotSpecRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('club')) {
      context.handle(
          _clubMeta, club.isAcceptableOrUnknown(data['club']!, _clubMeta));
    } else if (isInserting) {
      context.missing(_clubMeta);
    }
    if (data.containsKey('carry_yards')) {
      context.handle(
          _carryYardsMeta,
          carryYards.isAcceptableOrUnknown(
              data['carry_yards']!, _carryYardsMeta));
    } else if (isInserting) {
      context.missing(_carryYardsMeta);
    }
    if (data.containsKey('trajectory')) {
      context.handle(
          _trajectoryMeta,
          trajectory.isAcceptableOrUnknown(
              data['trajectory']!, _trajectoryMeta));
    } else if (isInserting) {
      context.missing(_trajectoryMeta);
    }
    if (data.containsKey('curve_shape')) {
      context.handle(
          _curveShapeMeta,
          curveShape.isAcceptableOrUnknown(
              data['curve_shape']!, _curveShapeMeta));
    } else if (isInserting) {
      context.missing(_curveShapeMeta);
    }
    if (data.containsKey('curve_mag')) {
      context.handle(_curveMagMeta,
          curveMag.isAcceptableOrUnknown(data['curve_mag']!, _curveMagMeta));
    } else if (isInserting) {
      context.missing(_curveMagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShotSpecRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShotSpecRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      club: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}club'])!,
      carryYards: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}carry_yards'])!,
      trajectory: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trajectory'])!,
      curveShape: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}curve_shape'])!,
      curveMag: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}curve_mag'])!,
    );
  }

  @override
  $ShotSpecsTable createAlias(String alias) {
    return $ShotSpecsTable(attachedDatabase, alias);
  }
}

class ShotSpecRow extends DataClass implements Insertable<ShotSpecRow> {
  final String id;
  final int club;
  final int carryYards;
  final int trajectory;
  final int curveShape;
  final int curveMag;
  const ShotSpecRow(
      {required this.id,
      required this.club,
      required this.carryYards,
      required this.trajectory,
      required this.curveShape,
      required this.curveMag});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['club'] = Variable<int>(club);
    map['carry_yards'] = Variable<int>(carryYards);
    map['trajectory'] = Variable<int>(trajectory);
    map['curve_shape'] = Variable<int>(curveShape);
    map['curve_mag'] = Variable<int>(curveMag);
    return map;
  }

  ShotSpecsCompanion toCompanion(bool nullToAbsent) {
    return ShotSpecsCompanion(
      id: Value(id),
      club: Value(club),
      carryYards: Value(carryYards),
      trajectory: Value(trajectory),
      curveShape: Value(curveShape),
      curveMag: Value(curveMag),
    );
  }

  factory ShotSpecRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShotSpecRow(
      id: serializer.fromJson<String>(json['id']),
      club: serializer.fromJson<int>(json['club']),
      carryYards: serializer.fromJson<int>(json['carryYards']),
      trajectory: serializer.fromJson<int>(json['trajectory']),
      curveShape: serializer.fromJson<int>(json['curveShape']),
      curveMag: serializer.fromJson<int>(json['curveMag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'club': serializer.toJson<int>(club),
      'carryYards': serializer.toJson<int>(carryYards),
      'trajectory': serializer.toJson<int>(trajectory),
      'curveShape': serializer.toJson<int>(curveShape),
      'curveMag': serializer.toJson<int>(curveMag),
    };
  }

  ShotSpecRow copyWith(
          {String? id,
          int? club,
          int? carryYards,
          int? trajectory,
          int? curveShape,
          int? curveMag}) =>
      ShotSpecRow(
        id: id ?? this.id,
        club: club ?? this.club,
        carryYards: carryYards ?? this.carryYards,
        trajectory: trajectory ?? this.trajectory,
        curveShape: curveShape ?? this.curveShape,
        curveMag: curveMag ?? this.curveMag,
      );
  ShotSpecRow copyWithCompanion(ShotSpecsCompanion data) {
    return ShotSpecRow(
      id: data.id.present ? data.id.value : this.id,
      club: data.club.present ? data.club.value : this.club,
      carryYards:
          data.carryYards.present ? data.carryYards.value : this.carryYards,
      trajectory:
          data.trajectory.present ? data.trajectory.value : this.trajectory,
      curveShape:
          data.curveShape.present ? data.curveShape.value : this.curveShape,
      curveMag: data.curveMag.present ? data.curveMag.value : this.curveMag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShotSpecRow(')
          ..write('id: $id, ')
          ..write('club: $club, ')
          ..write('carryYards: $carryYards, ')
          ..write('trajectory: $trajectory, ')
          ..write('curveShape: $curveShape, ')
          ..write('curveMag: $curveMag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, club, carryYards, trajectory, curveShape, curveMag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShotSpecRow &&
          other.id == this.id &&
          other.club == this.club &&
          other.carryYards == this.carryYards &&
          other.trajectory == this.trajectory &&
          other.curveShape == this.curveShape &&
          other.curveMag == this.curveMag);
}

class ShotSpecsCompanion extends UpdateCompanion<ShotSpecRow> {
  final Value<String> id;
  final Value<int> club;
  final Value<int> carryYards;
  final Value<int> trajectory;
  final Value<int> curveShape;
  final Value<int> curveMag;
  final Value<int> rowid;
  const ShotSpecsCompanion({
    this.id = const Value.absent(),
    this.club = const Value.absent(),
    this.carryYards = const Value.absent(),
    this.trajectory = const Value.absent(),
    this.curveShape = const Value.absent(),
    this.curveMag = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShotSpecsCompanion.insert({
    required String id,
    required int club,
    required int carryYards,
    required int trajectory,
    required int curveShape,
    required int curveMag,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        club = Value(club),
        carryYards = Value(carryYards),
        trajectory = Value(trajectory),
        curveShape = Value(curveShape),
        curveMag = Value(curveMag);
  static Insertable<ShotSpecRow> custom({
    Expression<String>? id,
    Expression<int>? club,
    Expression<int>? carryYards,
    Expression<int>? trajectory,
    Expression<int>? curveShape,
    Expression<int>? curveMag,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (club != null) 'club': club,
      if (carryYards != null) 'carry_yards': carryYards,
      if (trajectory != null) 'trajectory': trajectory,
      if (curveShape != null) 'curve_shape': curveShape,
      if (curveMag != null) 'curve_mag': curveMag,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShotSpecsCompanion copyWith(
      {Value<String>? id,
      Value<int>? club,
      Value<int>? carryYards,
      Value<int>? trajectory,
      Value<int>? curveShape,
      Value<int>? curveMag,
      Value<int>? rowid}) {
    return ShotSpecsCompanion(
      id: id ?? this.id,
      club: club ?? this.club,
      carryYards: carryYards ?? this.carryYards,
      trajectory: trajectory ?? this.trajectory,
      curveShape: curveShape ?? this.curveShape,
      curveMag: curveMag ?? this.curveMag,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (club.present) {
      map['club'] = Variable<int>(club.value);
    }
    if (carryYards.present) {
      map['carry_yards'] = Variable<int>(carryYards.value);
    }
    if (trajectory.present) {
      map['trajectory'] = Variable<int>(trajectory.value);
    }
    if (curveShape.present) {
      map['curve_shape'] = Variable<int>(curveShape.value);
    }
    if (curveMag.present) {
      map['curve_mag'] = Variable<int>(curveMag.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShotSpecsCompanion(')
          ..write('id: $id, ')
          ..write('club: $club, ')
          ..write('carryYards: $carryYards, ')
          ..write('trajectory: $trajectory, ')
          ..write('curveShape: $curveShape, ')
          ..write('curveMag: $curveMag, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShotAttemptsTable extends ShotAttempts
    with TableInfo<$ShotAttemptsTable, ShotAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShotAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _specIdMeta = const VerificationMeta('specId');
  @override
  late final GeneratedColumn<String> specId = GeneratedColumn<String>(
      'spec_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES shot_specs (id)'));
  static const VerificationMeta _timestampMillisMeta =
      const VerificationMeta('timestampMillis');
  @override
  late final GeneratedColumn<int> timestampMillis = GeneratedColumn<int>(
      'timestamp_millis', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _carryYardsMeta =
      const VerificationMeta('carryYards');
  @override
  late final GeneratedColumn<int> carryYards = GeneratedColumn<int>(
      'carry_yards', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
      'height', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _curveShapeMeta =
      const VerificationMeta('curveShape');
  @override
  late final GeneratedColumn<int> curveShape = GeneratedColumn<int>(
      'curve_shape', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _curveMagMeta =
      const VerificationMeta('curveMag');
  @override
  late final GeneratedColumn<int> curveMag = GeneratedColumn<int>(
      'curve_mag', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endSideYardsMeta =
      const VerificationMeta('endSideYards');
  @override
  late final GeneratedColumn<int> endSideYards = GeneratedColumn<int>(
      'end_side_yards', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endShortLongYardsMeta =
      const VerificationMeta('endShortLongYards');
  @override
  late final GeneratedColumn<int> endShortLongYards = GeneratedColumn<int>(
      'end_short_long_yards', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<int> result = GeneratedColumn<int>(
      'result', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        specId,
        timestampMillis,
        carryYards,
        height,
        curveShape,
        curveMag,
        endSideYards,
        endShortLongYards,
        result,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shot_attempts';
  @override
  VerificationContext validateIntegrity(Insertable<ShotAttemptRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('spec_id')) {
      context.handle(_specIdMeta,
          specId.isAcceptableOrUnknown(data['spec_id']!, _specIdMeta));
    } else if (isInserting) {
      context.missing(_specIdMeta);
    }
    if (data.containsKey('timestamp_millis')) {
      context.handle(
          _timestampMillisMeta,
          timestampMillis.isAcceptableOrUnknown(
              data['timestamp_millis']!, _timestampMillisMeta));
    } else if (isInserting) {
      context.missing(_timestampMillisMeta);
    }
    if (data.containsKey('carry_yards')) {
      context.handle(
          _carryYardsMeta,
          carryYards.isAcceptableOrUnknown(
              data['carry_yards']!, _carryYardsMeta));
    } else if (isInserting) {
      context.missing(_carryYardsMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('curve_shape')) {
      context.handle(
          _curveShapeMeta,
          curveShape.isAcceptableOrUnknown(
              data['curve_shape']!, _curveShapeMeta));
    } else if (isInserting) {
      context.missing(_curveShapeMeta);
    }
    if (data.containsKey('curve_mag')) {
      context.handle(_curveMagMeta,
          curveMag.isAcceptableOrUnknown(data['curve_mag']!, _curveMagMeta));
    } else if (isInserting) {
      context.missing(_curveMagMeta);
    }
    if (data.containsKey('end_side_yards')) {
      context.handle(
          _endSideYardsMeta,
          endSideYards.isAcceptableOrUnknown(
              data['end_side_yards']!, _endSideYardsMeta));
    } else if (isInserting) {
      context.missing(_endSideYardsMeta);
    }
    if (data.containsKey('end_short_long_yards')) {
      context.handle(
          _endShortLongYardsMeta,
          endShortLongYards.isAcceptableOrUnknown(
              data['end_short_long_yards']!, _endShortLongYardsMeta));
    } else if (isInserting) {
      context.missing(_endShortLongYardsMeta);
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShotAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShotAttemptRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      specId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}spec_id'])!,
      timestampMillis: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp_millis'])!,
      carryYards: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}carry_yards'])!,
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}height'])!,
      curveShape: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}curve_shape'])!,
      curveMag: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}curve_mag'])!,
      endSideYards: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_side_yards'])!,
      endShortLongYards: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}end_short_long_yards'])!,
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}result'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $ShotAttemptsTable createAlias(String alias) {
    return $ShotAttemptsTable(attachedDatabase, alias);
  }
}

class ShotAttemptRow extends DataClass implements Insertable<ShotAttemptRow> {
  final String id;
  final String specId;
  final int timestampMillis;
  final int carryYards;
  final int height;
  final int curveShape;
  final int curveMag;
  final int endSideYards;
  final int endShortLongYards;
  final int result;
  final String? notes;
  const ShotAttemptRow(
      {required this.id,
      required this.specId,
      required this.timestampMillis,
      required this.carryYards,
      required this.height,
      required this.curveShape,
      required this.curveMag,
      required this.endSideYards,
      required this.endShortLongYards,
      required this.result,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['spec_id'] = Variable<String>(specId);
    map['timestamp_millis'] = Variable<int>(timestampMillis);
    map['carry_yards'] = Variable<int>(carryYards);
    map['height'] = Variable<int>(height);
    map['curve_shape'] = Variable<int>(curveShape);
    map['curve_mag'] = Variable<int>(curveMag);
    map['end_side_yards'] = Variable<int>(endSideYards);
    map['end_short_long_yards'] = Variable<int>(endShortLongYards);
    map['result'] = Variable<int>(result);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ShotAttemptsCompanion toCompanion(bool nullToAbsent) {
    return ShotAttemptsCompanion(
      id: Value(id),
      specId: Value(specId),
      timestampMillis: Value(timestampMillis),
      carryYards: Value(carryYards),
      height: Value(height),
      curveShape: Value(curveShape),
      curveMag: Value(curveMag),
      endSideYards: Value(endSideYards),
      endShortLongYards: Value(endShortLongYards),
      result: Value(result),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory ShotAttemptRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShotAttemptRow(
      id: serializer.fromJson<String>(json['id']),
      specId: serializer.fromJson<String>(json['specId']),
      timestampMillis: serializer.fromJson<int>(json['timestampMillis']),
      carryYards: serializer.fromJson<int>(json['carryYards']),
      height: serializer.fromJson<int>(json['height']),
      curveShape: serializer.fromJson<int>(json['curveShape']),
      curveMag: serializer.fromJson<int>(json['curveMag']),
      endSideYards: serializer.fromJson<int>(json['endSideYards']),
      endShortLongYards: serializer.fromJson<int>(json['endShortLongYards']),
      result: serializer.fromJson<int>(json['result']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'specId': serializer.toJson<String>(specId),
      'timestampMillis': serializer.toJson<int>(timestampMillis),
      'carryYards': serializer.toJson<int>(carryYards),
      'height': serializer.toJson<int>(height),
      'curveShape': serializer.toJson<int>(curveShape),
      'curveMag': serializer.toJson<int>(curveMag),
      'endSideYards': serializer.toJson<int>(endSideYards),
      'endShortLongYards': serializer.toJson<int>(endShortLongYards),
      'result': serializer.toJson<int>(result),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ShotAttemptRow copyWith(
          {String? id,
          String? specId,
          int? timestampMillis,
          int? carryYards,
          int? height,
          int? curveShape,
          int? curveMag,
          int? endSideYards,
          int? endShortLongYards,
          int? result,
          Value<String?> notes = const Value.absent()}) =>
      ShotAttemptRow(
        id: id ?? this.id,
        specId: specId ?? this.specId,
        timestampMillis: timestampMillis ?? this.timestampMillis,
        carryYards: carryYards ?? this.carryYards,
        height: height ?? this.height,
        curveShape: curveShape ?? this.curveShape,
        curveMag: curveMag ?? this.curveMag,
        endSideYards: endSideYards ?? this.endSideYards,
        endShortLongYards: endShortLongYards ?? this.endShortLongYards,
        result: result ?? this.result,
        notes: notes.present ? notes.value : this.notes,
      );
  ShotAttemptRow copyWithCompanion(ShotAttemptsCompanion data) {
    return ShotAttemptRow(
      id: data.id.present ? data.id.value : this.id,
      specId: data.specId.present ? data.specId.value : this.specId,
      timestampMillis: data.timestampMillis.present
          ? data.timestampMillis.value
          : this.timestampMillis,
      carryYards:
          data.carryYards.present ? data.carryYards.value : this.carryYards,
      height: data.height.present ? data.height.value : this.height,
      curveShape:
          data.curveShape.present ? data.curveShape.value : this.curveShape,
      curveMag: data.curveMag.present ? data.curveMag.value : this.curveMag,
      endSideYards: data.endSideYards.present
          ? data.endSideYards.value
          : this.endSideYards,
      endShortLongYards: data.endShortLongYards.present
          ? data.endShortLongYards.value
          : this.endShortLongYards,
      result: data.result.present ? data.result.value : this.result,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShotAttemptRow(')
          ..write('id: $id, ')
          ..write('specId: $specId, ')
          ..write('timestampMillis: $timestampMillis, ')
          ..write('carryYards: $carryYards, ')
          ..write('height: $height, ')
          ..write('curveShape: $curveShape, ')
          ..write('curveMag: $curveMag, ')
          ..write('endSideYards: $endSideYards, ')
          ..write('endShortLongYards: $endShortLongYards, ')
          ..write('result: $result, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      specId,
      timestampMillis,
      carryYards,
      height,
      curveShape,
      curveMag,
      endSideYards,
      endShortLongYards,
      result,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShotAttemptRow &&
          other.id == this.id &&
          other.specId == this.specId &&
          other.timestampMillis == this.timestampMillis &&
          other.carryYards == this.carryYards &&
          other.height == this.height &&
          other.curveShape == this.curveShape &&
          other.curveMag == this.curveMag &&
          other.endSideYards == this.endSideYards &&
          other.endShortLongYards == this.endShortLongYards &&
          other.result == this.result &&
          other.notes == this.notes);
}

class ShotAttemptsCompanion extends UpdateCompanion<ShotAttemptRow> {
  final Value<String> id;
  final Value<String> specId;
  final Value<int> timestampMillis;
  final Value<int> carryYards;
  final Value<int> height;
  final Value<int> curveShape;
  final Value<int> curveMag;
  final Value<int> endSideYards;
  final Value<int> endShortLongYards;
  final Value<int> result;
  final Value<String?> notes;
  final Value<int> rowid;
  const ShotAttemptsCompanion({
    this.id = const Value.absent(),
    this.specId = const Value.absent(),
    this.timestampMillis = const Value.absent(),
    this.carryYards = const Value.absent(),
    this.height = const Value.absent(),
    this.curveShape = const Value.absent(),
    this.curveMag = const Value.absent(),
    this.endSideYards = const Value.absent(),
    this.endShortLongYards = const Value.absent(),
    this.result = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShotAttemptsCompanion.insert({
    required String id,
    required String specId,
    required int timestampMillis,
    required int carryYards,
    required int height,
    required int curveShape,
    required int curveMag,
    required int endSideYards,
    required int endShortLongYards,
    required int result,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        specId = Value(specId),
        timestampMillis = Value(timestampMillis),
        carryYards = Value(carryYards),
        height = Value(height),
        curveShape = Value(curveShape),
        curveMag = Value(curveMag),
        endSideYards = Value(endSideYards),
        endShortLongYards = Value(endShortLongYards),
        result = Value(result);
  static Insertable<ShotAttemptRow> custom({
    Expression<String>? id,
    Expression<String>? specId,
    Expression<int>? timestampMillis,
    Expression<int>? carryYards,
    Expression<int>? height,
    Expression<int>? curveShape,
    Expression<int>? curveMag,
    Expression<int>? endSideYards,
    Expression<int>? endShortLongYards,
    Expression<int>? result,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (specId != null) 'spec_id': specId,
      if (timestampMillis != null) 'timestamp_millis': timestampMillis,
      if (carryYards != null) 'carry_yards': carryYards,
      if (height != null) 'height': height,
      if (curveShape != null) 'curve_shape': curveShape,
      if (curveMag != null) 'curve_mag': curveMag,
      if (endSideYards != null) 'end_side_yards': endSideYards,
      if (endShortLongYards != null) 'end_short_long_yards': endShortLongYards,
      if (result != null) 'result': result,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShotAttemptsCompanion copyWith(
      {Value<String>? id,
      Value<String>? specId,
      Value<int>? timestampMillis,
      Value<int>? carryYards,
      Value<int>? height,
      Value<int>? curveShape,
      Value<int>? curveMag,
      Value<int>? endSideYards,
      Value<int>? endShortLongYards,
      Value<int>? result,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return ShotAttemptsCompanion(
      id: id ?? this.id,
      specId: specId ?? this.specId,
      timestampMillis: timestampMillis ?? this.timestampMillis,
      carryYards: carryYards ?? this.carryYards,
      height: height ?? this.height,
      curveShape: curveShape ?? this.curveShape,
      curveMag: curveMag ?? this.curveMag,
      endSideYards: endSideYards ?? this.endSideYards,
      endShortLongYards: endShortLongYards ?? this.endShortLongYards,
      result: result ?? this.result,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (specId.present) {
      map['spec_id'] = Variable<String>(specId.value);
    }
    if (timestampMillis.present) {
      map['timestamp_millis'] = Variable<int>(timestampMillis.value);
    }
    if (carryYards.present) {
      map['carry_yards'] = Variable<int>(carryYards.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (curveShape.present) {
      map['curve_shape'] = Variable<int>(curveShape.value);
    }
    if (curveMag.present) {
      map['curve_mag'] = Variable<int>(curveMag.value);
    }
    if (endSideYards.present) {
      map['end_side_yards'] = Variable<int>(endSideYards.value);
    }
    if (endShortLongYards.present) {
      map['end_short_long_yards'] = Variable<int>(endShortLongYards.value);
    }
    if (result.present) {
      map['result'] = Variable<int>(result.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShotAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('specId: $specId, ')
          ..write('timestampMillis: $timestampMillis, ')
          ..write('carryYards: $carryYards, ')
          ..write('height: $height, ')
          ..write('curveShape: $curveShape, ')
          ..write('curveMag: $curveMag, ')
          ..write('endSideYards: $endSideYards, ')
          ..write('endShortLongYards: $endShortLongYards, ')
          ..write('result: $result, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $ShotSpecsTable shotSpecs = $ShotSpecsTable(this);
  late final $ShotAttemptsTable shotAttempts = $ShotAttemptsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [shotSpecs, shotAttempts];
}

typedef $$ShotSpecsTableCreateCompanionBuilder = ShotSpecsCompanion Function({
  required String id,
  required int club,
  required int carryYards,
  required int trajectory,
  required int curveShape,
  required int curveMag,
  Value<int> rowid,
});
typedef $$ShotSpecsTableUpdateCompanionBuilder = ShotSpecsCompanion Function({
  Value<String> id,
  Value<int> club,
  Value<int> carryYards,
  Value<int> trajectory,
  Value<int> curveShape,
  Value<int> curveMag,
  Value<int> rowid,
});

final class $$ShotSpecsTableReferences
    extends BaseReferences<_$AppDb, $ShotSpecsTable, ShotSpecRow> {
  $$ShotSpecsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShotAttemptsTable, List<ShotAttemptRow>>
      _shotAttemptsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
          db.shotAttempts,
          aliasName:
              $_aliasNameGenerator(db.shotSpecs.id, db.shotAttempts.specId));

  $$ShotAttemptsTableProcessedTableManager get shotAttemptsRefs {
    final manager = $$ShotAttemptsTableTableManager($_db, $_db.shotAttempts)
        .filter((f) => f.specId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shotAttemptsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ShotSpecsTableFilterComposer
    extends Composer<_$AppDb, $ShotSpecsTable> {
  $$ShotSpecsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get club => $composableBuilder(
      column: $table.club, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carryYards => $composableBuilder(
      column: $table.carryYards, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get trajectory => $composableBuilder(
      column: $table.trajectory, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get curveShape => $composableBuilder(
      column: $table.curveShape, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get curveMag => $composableBuilder(
      column: $table.curveMag, builder: (column) => ColumnFilters(column));

  Expression<bool> shotAttemptsRefs(
      Expression<bool> Function($$ShotAttemptsTableFilterComposer f) f) {
    final $$ShotAttemptsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shotAttempts,
        getReferencedColumn: (t) => t.specId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShotAttemptsTableFilterComposer(
              $db: $db,
              $table: $db.shotAttempts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShotSpecsTableOrderingComposer
    extends Composer<_$AppDb, $ShotSpecsTable> {
  $$ShotSpecsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get club => $composableBuilder(
      column: $table.club, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carryYards => $composableBuilder(
      column: $table.carryYards, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get trajectory => $composableBuilder(
      column: $table.trajectory, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get curveShape => $composableBuilder(
      column: $table.curveShape, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get curveMag => $composableBuilder(
      column: $table.curveMag, builder: (column) => ColumnOrderings(column));
}

class $$ShotSpecsTableAnnotationComposer
    extends Composer<_$AppDb, $ShotSpecsTable> {
  $$ShotSpecsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get club =>
      $composableBuilder(column: $table.club, builder: (column) => column);

  GeneratedColumn<int> get carryYards => $composableBuilder(
      column: $table.carryYards, builder: (column) => column);

  GeneratedColumn<int> get trajectory => $composableBuilder(
      column: $table.trajectory, builder: (column) => column);

  GeneratedColumn<int> get curveShape => $composableBuilder(
      column: $table.curveShape, builder: (column) => column);

  GeneratedColumn<int> get curveMag =>
      $composableBuilder(column: $table.curveMag, builder: (column) => column);

  Expression<T> shotAttemptsRefs<T extends Object>(
      Expression<T> Function($$ShotAttemptsTableAnnotationComposer a) f) {
    final $$ShotAttemptsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shotAttempts,
        getReferencedColumn: (t) => t.specId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShotAttemptsTableAnnotationComposer(
              $db: $db,
              $table: $db.shotAttempts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShotSpecsTableTableManager extends RootTableManager<
    _$AppDb,
    $ShotSpecsTable,
    ShotSpecRow,
    $$ShotSpecsTableFilterComposer,
    $$ShotSpecsTableOrderingComposer,
    $$ShotSpecsTableAnnotationComposer,
    $$ShotSpecsTableCreateCompanionBuilder,
    $$ShotSpecsTableUpdateCompanionBuilder,
    (ShotSpecRow, $$ShotSpecsTableReferences),
    ShotSpecRow,
    PrefetchHooks Function({bool shotAttemptsRefs})> {
  $$ShotSpecsTableTableManager(_$AppDb db, $ShotSpecsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShotSpecsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShotSpecsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShotSpecsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> club = const Value.absent(),
            Value<int> carryYards = const Value.absent(),
            Value<int> trajectory = const Value.absent(),
            Value<int> curveShape = const Value.absent(),
            Value<int> curveMag = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShotSpecsCompanion(
            id: id,
            club: club,
            carryYards: carryYards,
            trajectory: trajectory,
            curveShape: curveShape,
            curveMag: curveMag,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int club,
            required int carryYards,
            required int trajectory,
            required int curveShape,
            required int curveMag,
            Value<int> rowid = const Value.absent(),
          }) =>
              ShotSpecsCompanion.insert(
            id: id,
            club: club,
            carryYards: carryYards,
            trajectory: trajectory,
            curveShape: curveShape,
            curveMag: curveMag,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ShotSpecsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({shotAttemptsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (shotAttemptsRefs) db.shotAttempts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shotAttemptsRefs)
                    await $_getPrefetchedData<ShotSpecRow, $ShotSpecsTable,
                            ShotAttemptRow>(
                        currentTable: table,
                        referencedTable: $$ShotSpecsTableReferences
                            ._shotAttemptsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShotSpecsTableReferences(db, table, p0)
                                .shotAttemptsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.specId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ShotSpecsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $ShotSpecsTable,
    ShotSpecRow,
    $$ShotSpecsTableFilterComposer,
    $$ShotSpecsTableOrderingComposer,
    $$ShotSpecsTableAnnotationComposer,
    $$ShotSpecsTableCreateCompanionBuilder,
    $$ShotSpecsTableUpdateCompanionBuilder,
    (ShotSpecRow, $$ShotSpecsTableReferences),
    ShotSpecRow,
    PrefetchHooks Function({bool shotAttemptsRefs})>;
typedef $$ShotAttemptsTableCreateCompanionBuilder = ShotAttemptsCompanion
    Function({
  required String id,
  required String specId,
  required int timestampMillis,
  required int carryYards,
  required int height,
  required int curveShape,
  required int curveMag,
  required int endSideYards,
  required int endShortLongYards,
  required int result,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$ShotAttemptsTableUpdateCompanionBuilder = ShotAttemptsCompanion
    Function({
  Value<String> id,
  Value<String> specId,
  Value<int> timestampMillis,
  Value<int> carryYards,
  Value<int> height,
  Value<int> curveShape,
  Value<int> curveMag,
  Value<int> endSideYards,
  Value<int> endShortLongYards,
  Value<int> result,
  Value<String?> notes,
  Value<int> rowid,
});

final class $$ShotAttemptsTableReferences
    extends BaseReferences<_$AppDb, $ShotAttemptsTable, ShotAttemptRow> {
  $$ShotAttemptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShotSpecsTable _specIdTable(_$AppDb db) => db.shotSpecs.createAlias(
      $_aliasNameGenerator(db.shotAttempts.specId, db.shotSpecs.id));

  $$ShotSpecsTableProcessedTableManager get specId {
    final $_column = $_itemColumn<String>('spec_id')!;

    final manager = $$ShotSpecsTableTableManager($_db, $_db.shotSpecs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_specIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ShotAttemptsTableFilterComposer
    extends Composer<_$AppDb, $ShotAttemptsTable> {
  $$ShotAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestampMillis => $composableBuilder(
      column: $table.timestampMillis,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carryYards => $composableBuilder(
      column: $table.carryYards, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get curveShape => $composableBuilder(
      column: $table.curveShape, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get curveMag => $composableBuilder(
      column: $table.curveMag, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endSideYards => $composableBuilder(
      column: $table.endSideYards, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endShortLongYards => $composableBuilder(
      column: $table.endShortLongYards,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$ShotSpecsTableFilterComposer get specId {
    final $$ShotSpecsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.specId,
        referencedTable: $db.shotSpecs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShotSpecsTableFilterComposer(
              $db: $db,
              $table: $db.shotSpecs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShotAttemptsTableOrderingComposer
    extends Composer<_$AppDb, $ShotAttemptsTable> {
  $$ShotAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestampMillis => $composableBuilder(
      column: $table.timestampMillis,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carryYards => $composableBuilder(
      column: $table.carryYards, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get curveShape => $composableBuilder(
      column: $table.curveShape, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get curveMag => $composableBuilder(
      column: $table.curveMag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endSideYards => $composableBuilder(
      column: $table.endSideYards,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endShortLongYards => $composableBuilder(
      column: $table.endShortLongYards,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$ShotSpecsTableOrderingComposer get specId {
    final $$ShotSpecsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.specId,
        referencedTable: $db.shotSpecs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShotSpecsTableOrderingComposer(
              $db: $db,
              $table: $db.shotSpecs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShotAttemptsTableAnnotationComposer
    extends Composer<_$AppDb, $ShotAttemptsTable> {
  $$ShotAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get timestampMillis => $composableBuilder(
      column: $table.timestampMillis, builder: (column) => column);

  GeneratedColumn<int> get carryYards => $composableBuilder(
      column: $table.carryYards, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get curveShape => $composableBuilder(
      column: $table.curveShape, builder: (column) => column);

  GeneratedColumn<int> get curveMag =>
      $composableBuilder(column: $table.curveMag, builder: (column) => column);

  GeneratedColumn<int> get endSideYards => $composableBuilder(
      column: $table.endSideYards, builder: (column) => column);

  GeneratedColumn<int> get endShortLongYards => $composableBuilder(
      column: $table.endShortLongYards, builder: (column) => column);

  GeneratedColumn<int> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ShotSpecsTableAnnotationComposer get specId {
    final $$ShotSpecsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.specId,
        referencedTable: $db.shotSpecs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShotSpecsTableAnnotationComposer(
              $db: $db,
              $table: $db.shotSpecs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShotAttemptsTableTableManager extends RootTableManager<
    _$AppDb,
    $ShotAttemptsTable,
    ShotAttemptRow,
    $$ShotAttemptsTableFilterComposer,
    $$ShotAttemptsTableOrderingComposer,
    $$ShotAttemptsTableAnnotationComposer,
    $$ShotAttemptsTableCreateCompanionBuilder,
    $$ShotAttemptsTableUpdateCompanionBuilder,
    (ShotAttemptRow, $$ShotAttemptsTableReferences),
    ShotAttemptRow,
    PrefetchHooks Function({bool specId})> {
  $$ShotAttemptsTableTableManager(_$AppDb db, $ShotAttemptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShotAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShotAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShotAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> specId = const Value.absent(),
            Value<int> timestampMillis = const Value.absent(),
            Value<int> carryYards = const Value.absent(),
            Value<int> height = const Value.absent(),
            Value<int> curveShape = const Value.absent(),
            Value<int> curveMag = const Value.absent(),
            Value<int> endSideYards = const Value.absent(),
            Value<int> endShortLongYards = const Value.absent(),
            Value<int> result = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShotAttemptsCompanion(
            id: id,
            specId: specId,
            timestampMillis: timestampMillis,
            carryYards: carryYards,
            height: height,
            curveShape: curveShape,
            curveMag: curveMag,
            endSideYards: endSideYards,
            endShortLongYards: endShortLongYards,
            result: result,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String specId,
            required int timestampMillis,
            required int carryYards,
            required int height,
            required int curveShape,
            required int curveMag,
            required int endSideYards,
            required int endShortLongYards,
            required int result,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShotAttemptsCompanion.insert(
            id: id,
            specId: specId,
            timestampMillis: timestampMillis,
            carryYards: carryYards,
            height: height,
            curveShape: curveShape,
            curveMag: curveMag,
            endSideYards: endSideYards,
            endShortLongYards: endShortLongYards,
            result: result,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ShotAttemptsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({specId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (specId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.specId,
                    referencedTable:
                        $$ShotAttemptsTableReferences._specIdTable(db),
                    referencedColumn:
                        $$ShotAttemptsTableReferences._specIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ShotAttemptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $ShotAttemptsTable,
    ShotAttemptRow,
    $$ShotAttemptsTableFilterComposer,
    $$ShotAttemptsTableOrderingComposer,
    $$ShotAttemptsTableAnnotationComposer,
    $$ShotAttemptsTableCreateCompanionBuilder,
    $$ShotAttemptsTableUpdateCompanionBuilder,
    (ShotAttemptRow, $$ShotAttemptsTableReferences),
    ShotAttemptRow,
    PrefetchHooks Function({bool specId})>;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$ShotSpecsTableTableManager get shotSpecs =>
      $$ShotSpecsTableTableManager(_db, _db.shotSpecs);
  $$ShotAttemptsTableTableManager get shotAttempts =>
      $$ShotAttemptsTableTableManager(_db, _db.shotAttempts);
}
