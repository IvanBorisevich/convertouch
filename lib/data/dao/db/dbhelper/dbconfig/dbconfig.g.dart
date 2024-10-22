// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dbconfig.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorConvertouchDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ConvertouchDatabaseBuilder databaseBuilder(String name) =>
      _$ConvertouchDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ConvertouchDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$ConvertouchDatabaseBuilder(null);
}

class _$ConvertouchDatabaseBuilder {
  _$ConvertouchDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$ConvertouchDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$ConvertouchDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<ConvertouchDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ConvertouchDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ConvertouchDatabase extends ConvertouchDatabase {
  _$ConvertouchDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UnitGroupDaoDb? _unitGroupDaoInstance;

  UnitDaoDb? _unitDaoInstance;

  DynamicValueDaoDb? _dynamicValueDaoInstance;

  ConversionDaoDb? _conversionDaoInstance;

  ConversionItemDaoDb? _conversionItemDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `unit_groups` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `icon_name` TEXT, `conversion_type` INTEGER, `refreshable` INTEGER, `value_type` INTEGER NOT NULL, `min_value` REAL, `max_value` REAL, `oob` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `units` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `code` TEXT NOT NULL, `symbol` TEXT, `coefficient` REAL, `unit_group_id` INTEGER NOT NULL, `value_type` INTEGER, `min_value` REAL, `max_value` REAL, `invertible` INTEGER, `oob` INTEGER, FOREIGN KEY (`unit_group_id`) REFERENCES `unit_groups` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `refreshable_values` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `unit_id` INTEGER NOT NULL, `value` TEXT, FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `conversions` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `unit_group_id` INTEGER NOT NULL, `source_unit_id` INTEGER, `source_value` TEXT, `last_modified` INTEGER NOT NULL, FOREIGN KEY (`unit_group_id`) REFERENCES `unit_groups` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `conversion_items` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `unit_id` INTEGER NOT NULL, `value` TEXT, `default_value` TEXT, `sequence_num` INTEGER NOT NULL, `conversion_id` INTEGER NOT NULL, FOREIGN KEY (`conversion_id`) REFERENCES `conversions` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_unit_groups_name` ON `unit_groups` (`name`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_units_code_unit_group_id` ON `units` (`code`, `unit_group_id`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_refreshable_values_unit_id` ON `refreshable_values` (`unit_id`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_conversions_last_modified` ON `conversions` (`last_modified`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_conversion_items_unit_id_conversion_id` ON `conversion_items` (`unit_id`, `conversion_id`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UnitGroupDaoDb get unitGroupDao {
    return _unitGroupDaoInstance ??= _$UnitGroupDaoDb(database, changeListener);
  }

  @override
  UnitDaoDb get unitDao {
    return _unitDaoInstance ??= _$UnitDaoDb(database, changeListener);
  }

  @override
  DynamicValueDaoDb get dynamicValueDao {
    return _dynamicValueDaoInstance ??=
        _$DynamicValueDaoDb(database, changeListener);
  }

  @override
  ConversionDaoDb get conversionDao {
    return _conversionDaoInstance ??=
        _$ConversionDaoDb(database, changeListener);
  }

  @override
  ConversionItemDaoDb get conversionItemDao {
    return _conversionItemDaoInstance ??=
        _$ConversionItemDaoDb(database, changeListener);
  }
}

class _$UnitGroupDaoDb extends UnitGroupDaoDb {
  _$UnitGroupDaoDb(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _unitGroupEntityInsertionAdapter = InsertionAdapter(
            database,
            'unit_groups',
            (UnitGroupEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'icon_name': item.iconName,
                  'conversion_type': item.conversionType,
                  'refreshable': item.refreshable,
                  'value_type': item.valueType,
                  'min_value': item.minValue,
                  'max_value': item.maxValue,
                  'oob': item.oob
                }),
        _unitGroupEntityUpdateAdapter = UpdateAdapter(
            database,
            'unit_groups',
            ['id'],
            (UnitGroupEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'icon_name': item.iconName,
                  'conversion_type': item.conversionType,
                  'refreshable': item.refreshable,
                  'value_type': item.valueType,
                  'min_value': item.minValue,
                  'max_value': item.maxValue,
                  'oob': item.oob
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UnitGroupEntity> _unitGroupEntityInsertionAdapter;

  final UpdateAdapter<UnitGroupEntity> _unitGroupEntityUpdateAdapter;

  @override
  Future<List<UnitGroupEntity>> getAll() async {
    return _queryAdapter.queryList('select * from unit_groups order by name',
        mapper: (Map<String, Object?> row) => UnitGroupEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            iconName: row['icon_name'] as String?,
            conversionType: row['conversion_type'] as int?,
            refreshable: row['refreshable'] as int?,
            valueType: row['value_type'] as int,
            minValue: row['min_value'] as double?,
            maxValue: row['max_value'] as double?,
            oob: row['oob'] as int?));
  }

  @override
  Future<List<UnitGroupEntity>> getBySearchString(String searchString) async {
    return _queryAdapter.queryList(
        'select * from unit_groups where name like ?1 order by name',
        mapper: (Map<String, Object?> row) => UnitGroupEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            iconName: row['icon_name'] as String?,
            conversionType: row['conversion_type'] as int?,
            refreshable: row['refreshable'] as int?,
            valueType: row['value_type'] as int,
            minValue: row['min_value'] as double?,
            maxValue: row['max_value'] as double?,
            oob: row['oob'] as int?),
        arguments: [searchString]);
  }

  @override
  Future<List<UnitGroupEntity>> getRefreshableGroups() async {
    return _queryAdapter.queryList(
        'select * from unit_groups where refreshable is not null',
        mapper: (Map<String, Object?> row) => UnitGroupEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            iconName: row['icon_name'] as String?,
            conversionType: row['conversion_type'] as int?,
            refreshable: row['refreshable'] as int?,
            valueType: row['value_type'] as int,
            minValue: row['min_value'] as double?,
            maxValue: row['max_value'] as double?,
            oob: row['oob'] as int?));
  }

  @override
  Future<UnitGroupEntity?> get(int id) async {
    return _queryAdapter.query(
        'select * from unit_groups where id = ?1 limit 1',
        mapper: (Map<String, Object?> row) => UnitGroupEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            iconName: row['icon_name'] as String?,
            conversionType: row['conversion_type'] as int?,
            refreshable: row['refreshable'] as int?,
            valueType: row['value_type'] as int,
            minValue: row['min_value'] as double?,
            maxValue: row['max_value'] as double?,
            oob: row['oob'] as int?),
        arguments: [id]);
  }

  @override
  Future<UnitGroupEntity?> getByName(String name) async {
    return _queryAdapter.query(
        'select * from unit_groups where name = ?1 limit 1',
        mapper: (Map<String, Object?> row) => UnitGroupEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            iconName: row['icon_name'] as String?,
            conversionType: row['conversion_type'] as int?,
            refreshable: row['refreshable'] as int?,
            valueType: row['value_type'] as int,
            minValue: row['min_value'] as double?,
            maxValue: row['max_value'] as double?,
            oob: row['oob'] as int?),
        arguments: [name]);
  }

  @override
  Future<void> remove(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'delete from unit_groups where id in (' + _sqliteVariablesForIds + ')',
        arguments: [...ids]);
  }

  @override
  Future<int> insert(UnitGroupEntity unitGroupEntity) {
    return _unitGroupEntityInsertionAdapter.insertAndReturnId(
        unitGroupEntity, OnConflictStrategy.fail);
  }

  @override
  Future<int> update(UnitGroupEntity unitGroupEntity) {
    return _unitGroupEntityUpdateAdapter.updateAndReturnChangedRows(
        unitGroupEntity, OnConflictStrategy.abort);
  }
}

class _$UnitDaoDb extends UnitDaoDb {
  _$UnitDaoDb(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _unitEntityInsertionAdapter = InsertionAdapter(
            database,
            'units',
            (UnitEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'symbol': item.symbol,
                  'coefficient': item.coefficient,
                  'unit_group_id': item.unitGroupId,
                  'value_type': item.valueType,
                  'min_value': item.minValue,
                  'max_value': item.maxValue,
                  'invertible': item.invertible,
                  'oob': item.oob
                }),
        _unitEntityUpdateAdapter = UpdateAdapter(
            database,
            'units',
            ['id'],
            (UnitEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'symbol': item.symbol,
                  'coefficient': item.coefficient,
                  'unit_group_id': item.unitGroupId,
                  'value_type': item.valueType,
                  'min_value': item.minValue,
                  'max_value': item.maxValue,
                  'invertible': item.invertible,
                  'oob': item.oob
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UnitEntity> _unitEntityInsertionAdapter;

  final UpdateAdapter<UnitEntity> _unitEntityUpdateAdapter;

  @override
  Future<List<UnitEntity>> getAll(int unitGroupId) async {
    return _queryAdapter.queryList(
        'select * from units where unit_group_id = ?1 order by code',
        mapper: (Map<String, Object?> row) => UnitEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            code: row['code'] as String,
            symbol: row['symbol'] as String?,
            coefficient: row['coefficient'] as double?,
            unitGroupId: row['unit_group_id'] as int,
            valueType: row['value_type'] as int?,
            minValue: row['min_value'] as double?,
            maxValue: row['max_value'] as double?,
            invertible: row['invertible'] as int?,
            oob: row['oob'] as int?),
        arguments: [unitGroupId]);
  }

  @override
  Future<List<UnitEntity>> getBySearchString(
    int unitGroupId,
    String searchString,
  ) async {
    return _queryAdapter.queryList(
        'select * from units where unit_group_id = ?1 and (name like ?2 or code like ?2) order by code',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
        arguments: [unitGroupId, searchString]);
  }

  @override
  Future<UnitEntity?> getByCode(
    int unitGroupId,
    String code,
  ) async {
    return _queryAdapter.query(
        'select * from units where unit_group_id = ?1 and code = ?2',
        mapper: (Map<String, Object?> row) => UnitEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            code: row['code'] as String,
            symbol: row['symbol'] as String?,
            coefficient: row['coefficient'] as double?,
            unitGroupId: row['unit_group_id'] as int,
            valueType: row['value_type'] as int?,
            minValue: row['min_value'] as double?,
            maxValue: row['max_value'] as double?,
            invertible: row['invertible'] as int?,
            oob: row['oob'] as int?),
        arguments: [unitGroupId, code]);
  }

  @override
  Future<List<UnitEntity>> getBaseUnits(int unitGroupId) async {
    return _queryAdapter.queryList(
        'select * from units where unit_group_id = ?1 and cast(coefficient as int) = 1 limit 2',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
        arguments: [unitGroupId]);
  }

  @override
  Future<UnitEntity?> getUnit(int id) async {
    return _queryAdapter.query('select * from units where id = ?1 limit 1',
        mapper: (Map<String, Object?> row) => UnitEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            code: row['code'] as String,
            symbol: row['symbol'] as String?,
            coefficient: row['coefficient'] as double?,
            unitGroupId: row['unit_group_id'] as int,
            valueType: row['value_type'] as int?,
            minValue: row['min_value'] as double?,
            maxValue: row['max_value'] as double?,
            invertible: row['invertible'] as int?,
            oob: row['oob'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<UnitEntity>> getUnitsByIds(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'select * from units where id in (' + _sqliteVariablesForIds + ')',
        mapper: (Map<String, Object?> row) => UnitEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            code: row['code'] as String,
            symbol: row['symbol'] as String?,
            coefficient: row['coefficient'] as double?,
            unitGroupId: row['unit_group_id'] as int,
            valueType: row['value_type'] as int?,
            minValue: row['min_value'] as double?,
            maxValue: row['max_value'] as double?,
            invertible: row['invertible'] as int?,
            oob: row['oob'] as int?),
        arguments: [...ids]);
  }

  @override
  Future<List<UnitEntity>> getUnitsByCodes(
    String unitGroupName,
    List<String> codes,
  ) async {
    const offset = 2;
    final _sqliteVariablesForCodes =
        Iterable<String>.generate(codes.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'select u.* from units u inner join unit_groups g where 1=1 and g.name = ?1 and u.unit_group_id = g.id and u.code in (' +
            _sqliteVariablesForCodes +
            ')',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
        arguments: [unitGroupName, ...codes]);
  }

  @override
  Future<void> remove(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'delete from units where id in (' + _sqliteVariablesForIds + ')',
        arguments: [...ids]);
  }

  @override
  Future<int> insert(UnitEntity unit) {
    return _unitEntityInsertionAdapter.insertAndReturnId(
        unit, OnConflictStrategy.fail);
  }

  @override
  Future<int> update(UnitEntity unit) {
    return _unitEntityUpdateAdapter.updateAndReturnChangedRows(
        unit, OnConflictStrategy.abort);
  }
}

class _$DynamicValueDaoDb extends DynamicValueDaoDb {
  _$DynamicValueDaoDb(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<DynamicValueEntity?> get(int unitId) async {
    return _queryAdapter.query(
        'select * from refreshable_values where unit_id = ?1 limit 1',
        mapper: (Map<String, Object?> row) => DynamicValueEntity(
            id: row['id'] as int?,
            unitId: row['unit_id'] as int,
            value: row['value'] as String?),
        arguments: [unitId]);
  }

  @override
  Future<List<DynamicValueEntity>> getList(List<int> unitIds) async {
    const offset = 1;
    final _sqliteVariablesForUnitIds =
        Iterable<String>.generate(unitIds.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'select * from refreshable_values where unit_id in (' +
            _sqliteVariablesForUnitIds +
            ')',
        mapper: (Map<String, Object?> row) => DynamicValueEntity(
            id: row['id'] as int?,
            unitId: row['unit_id'] as int,
            value: row['value'] as String?),
        arguments: [...unitIds]);
  }
}

class _$ConversionDaoDb extends ConversionDaoDb {
  _$ConversionDaoDb(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _conversionEntityInsertionAdapter = InsertionAdapter(
            database,
            'conversions',
            (ConversionEntity item) => <String, Object?>{
                  'id': item.id,
                  'unit_group_id': item.unitGroupId,
                  'source_unit_id': item.sourceUnitId,
                  'source_value': item.sourceValue,
                  'last_modified': item.lastModified
                }),
        _conversionEntityUpdateAdapter = UpdateAdapter(
            database,
            'conversions',
            ['id'],
            (ConversionEntity item) => <String, Object?>{
                  'id': item.id,
                  'unit_group_id': item.unitGroupId,
                  'source_unit_id': item.sourceUnitId,
                  'source_value': item.sourceValue,
                  'last_modified': item.lastModified
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ConversionEntity> _conversionEntityInsertionAdapter;

  final UpdateAdapter<ConversionEntity> _conversionEntityUpdateAdapter;

  @override
  Future<ConversionEntity?> getLast(int unitGroupId) async {
    return _queryAdapter.query(
        'SELECT c.* FROM conversions c INNER JOIN ( SELECT id, MAX(last_modified) as latest_modified FROM conversions WHERE unit_group_id = ?1 GROUP BY id LIMIT 1) mc ON c.id = mc.id AND c.last_modified = mc.latest_modified',
        mapper: (Map<String, Object?> row) => ConversionEntity(id: row['id'] as int?, unitGroupId: row['unit_group_id'] as int, sourceUnitId: row['source_unit_id'] as int?, sourceValue: row['source_value'] as String?, lastModified: row['last_modified'] as int),
        arguments: [unitGroupId]);
  }

  @override
  Future<void> removeByGroupIds(List<int> unitGroupIds) async {
    const offset = 1;
    final _sqliteVariablesForUnitGroupIds =
        Iterable<String>.generate(unitGroupIds.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'delete from conversions where id in (' +
            _sqliteVariablesForUnitGroupIds +
            ')',
        arguments: [...unitGroupIds]);
  }

  @override
  Future<int> insert(ConversionEntity conversion) {
    return _conversionEntityInsertionAdapter.insertAndReturnId(
        conversion, OnConflictStrategy.fail);
  }

  @override
  Future<int> update(ConversionEntity conversion) {
    return _conversionEntityUpdateAdapter.updateAndReturnChangedRows(
        conversion, OnConflictStrategy.abort);
  }
}

class _$ConversionItemDaoDb extends ConversionItemDaoDb {
  _$ConversionItemDaoDb(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<ConversionItemEntity>> getByConversionId(int conversionId) async {
    return _queryAdapter.queryList(
        'select * from conversion_items where conversion_id = ?1 order by sequence_num',
        mapper: (Map<String, Object?> row) => ConversionItemEntity(id: row['id'] as int?, unitId: row['unit_id'] as int, value: row['value'] as String?, defaultValue: row['default_value'] as String?, sequenceNum: row['sequence_num'] as int, conversionId: row['conversion_id'] as int),
        arguments: [conversionId]);
  }

  @override
  Future<void> removeByConversionId(int conversionId) async {
    await _queryAdapter.queryNoReturn(
        'delete from conversion_items where conversion_id = ?1',
        arguments: [conversionId]);
  }
}
