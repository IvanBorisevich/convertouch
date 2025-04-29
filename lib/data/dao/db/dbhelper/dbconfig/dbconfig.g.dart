// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dbconfig.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $ConvertouchDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $ConvertouchDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $ConvertouchDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<ConvertouchDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorConvertouchDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ConvertouchDatabaseBuilderContract databaseBuilder(String name) =>
      _$ConvertouchDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ConvertouchDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$ConvertouchDatabaseBuilder(null);
}

class _$ConvertouchDatabaseBuilder
    implements $ConvertouchDatabaseBuilderContract {
  _$ConvertouchDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $ConvertouchDatabaseBuilderContract addMigrations(
      List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $ConvertouchDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
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

  ConversionUnitValueDaoDb? _conversionUnitValueDaoInstance;

  ConversionParamValueDaoDb? _conversionParamValueDaoInstance;

  ConversionParamDaoDb? _conversionParamDaoInstance;

  ConversionParamSetDaoDb? _conversionParamSetDaoInstance;

  ConversionParamUnitDaoDb? _conversionParamUnitDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 4,
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
            'CREATE TABLE IF NOT EXISTS `unit_groups` (`name` TEXT NOT NULL, `icon_name` TEXT, `conversion_type` INTEGER, `refreshable` INTEGER, `value_type` INTEGER NOT NULL, `min_value` REAL, `max_value` REAL, `oob` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `units` (`name` TEXT NOT NULL, `code` TEXT NOT NULL, `symbol` TEXT, `coefficient` REAL, `unit_group_id` INTEGER NOT NULL, `value_type` INTEGER, `list_type` INTEGER, `min_value` REAL, `max_value` REAL, `invertible` INTEGER, `oob` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT, FOREIGN KEY (`unit_group_id`) REFERENCES `unit_groups` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `refreshable_values` (`unit_id` INTEGER NOT NULL, `value` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT, FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `conversions` (`unit_group_id` INTEGER NOT NULL, `source_unit_id` INTEGER, `source_value` TEXT, `last_modified` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, FOREIGN KEY (`unit_group_id`) REFERENCES `unit_groups` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `conversion_items` (`unit_id` INTEGER NOT NULL, `value` TEXT, `default_value` TEXT, `sequence_num` INTEGER NOT NULL, `conversion_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, FOREIGN KEY (`conversion_id`) REFERENCES `conversions` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `conversion_param_sets` (`name` TEXT NOT NULL, `mandatory` INTEGER, `group_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, FOREIGN KEY (`group_id`) REFERENCES `unit_groups` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `conversion_params` (`name` TEXT NOT NULL, `calculable` INTEGER, `unit_group_id` INTEGER, `value_type` INTEGER NOT NULL, `list_type` INTEGER, `default_unit_id` INTEGER, `param_set_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, FOREIGN KEY (`param_set_id`) REFERENCES `conversion_param_sets` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `conversion_param_units` (`param_id` INTEGER NOT NULL, `unit_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, FOREIGN KEY (`param_id`) REFERENCES `conversion_params` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `conversion_param_values` (`param_id` INTEGER NOT NULL, `unit_id` INTEGER, `calculated` INTEGER, `value` TEXT, `default_value` TEXT, `sequence_num` INTEGER NOT NULL, `conversion_id` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, FOREIGN KEY (`conversion_id`) REFERENCES `conversions` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
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
        await database.execute(
            'CREATE UNIQUE INDEX `index_conversion_param_sets_name_group_id` ON `conversion_param_sets` (`name`, `group_id`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_conversion_params_name_param_set_id` ON `conversion_params` (`name`, `param_set_id`)');
        await database.execute(
            'CREATE INDEX `index_conversion_param_units_param_id` ON `conversion_param_units` (`param_id`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_conversion_param_values_param_id_conversion_id` ON `conversion_param_values` (`param_id`, `conversion_id`)');

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
  ConversionUnitValueDaoDb get conversionUnitValueDao {
    return _conversionUnitValueDaoInstance ??=
        _$ConversionUnitValueDaoDb(database, changeListener);
  }

  @override
  ConversionParamValueDaoDb get conversionParamValueDao {
    return _conversionParamValueDaoInstance ??=
        _$ConversionParamValueDaoDb(database, changeListener);
  }

  @override
  ConversionParamDaoDb get conversionParamDao {
    return _conversionParamDaoInstance ??=
        _$ConversionParamDaoDb(database, changeListener);
  }

  @override
  ConversionParamSetDaoDb get conversionParamSetDao {
    return _conversionParamSetDaoInstance ??=
        _$ConversionParamSetDaoDb(database, changeListener);
  }

  @override
  ConversionParamUnitDaoDb get conversionParamUnitDao {
    return _conversionParamUnitDaoInstance ??=
        _$ConversionParamUnitDaoDb(database, changeListener);
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
                  'name': item.name,
                  'icon_name': item.iconName,
                  'conversion_type': item.conversionType,
                  'refreshable': item.refreshable,
                  'value_type': item.valueType,
                  'min_value': item.minValue,
                  'max_value': item.maxValue,
                  'oob': item.oob,
                  'id': item.id
                }),
        _unitGroupEntityUpdateAdapter = UpdateAdapter(
            database,
            'unit_groups',
            ['id'],
            (UnitGroupEntity item) => <String, Object?>{
                  'name': item.name,
                  'icon_name': item.iconName,
                  'conversion_type': item.conversionType,
                  'refreshable': item.refreshable,
                  'value_type': item.valueType,
                  'min_value': item.minValue,
                  'max_value': item.maxValue,
                  'oob': item.oob,
                  'id': item.id
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UnitGroupEntity> _unitGroupEntityInsertionAdapter;

  final UpdateAdapter<UnitGroupEntity> _unitGroupEntityUpdateAdapter;

  @override
  Future<List<UnitGroupEntity>> getBySearchString({
    required String searchString,
    required int pageSize,
    required int offset,
  }) async {
    return _queryAdapter.queryList(
        'select * from unit_groups where name like ?1 order by name limit ?2 offset ?3',
        mapper: (Map<String, Object?> row) => UnitGroupEntity(id: row['id'] as int?, name: row['name'] as String, iconName: row['icon_name'] as String?, conversionType: row['conversion_type'] as int?, refreshable: row['refreshable'] as int?, valueType: row['value_type'] as int, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, oob: row['oob'] as int?),
        arguments: [searchString, pageSize, offset]);
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
                  'name': item.name,
                  'code': item.code,
                  'symbol': item.symbol,
                  'coefficient': item.coefficient,
                  'unit_group_id': item.unitGroupId,
                  'value_type': item.valueType,
                  'list_type': item.listType,
                  'min_value': item.minValue,
                  'max_value': item.maxValue,
                  'invertible': item.invertible,
                  'oob': item.oob,
                  'id': item.id
                }),
        _unitEntityUpdateAdapter = UpdateAdapter(
            database,
            'units',
            ['id'],
            (UnitEntity item) => <String, Object?>{
                  'name': item.name,
                  'code': item.code,
                  'symbol': item.symbol,
                  'coefficient': item.coefficient,
                  'unit_group_id': item.unitGroupId,
                  'value_type': item.valueType,
                  'list_type': item.listType,
                  'min_value': item.minValue,
                  'max_value': item.maxValue,
                  'invertible': item.invertible,
                  'oob': item.oob,
                  'id': item.id
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UnitEntity> _unitEntityInsertionAdapter;

  final UpdateAdapter<UnitEntity> _unitEntityUpdateAdapter;

  @override
  Future<List<UnitEntity>> searchWithGroupId({
    required String searchString,
    required int unitGroupId,
    required int pageSize,
    required int offset,
  }) async {
    return _queryAdapter.queryList(
        'select u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, u.invertible, u.oob, u.list_type, coalesce(u.value_type, g.value_type) value_type, coalesce(u.min_value, g.min_value) min_value, coalesce(u.max_value, g.max_value) max_value from units u inner join unit_groups g on g.id = u.unit_group_id where g.id = ?2 and (u.name like ?1 or u.code like ?1) order by u.code limit ?3 offset ?4',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, listType: row['list_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
        arguments: [searchString, unitGroupId, pageSize, offset]);
  }

  @override
  Future<List<UnitEntity>> getByParamId({
    required int paramId,
    required int pageSize,
    required int offset,
  }) async {
    return _queryAdapter.queryList(
        'select u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, u.invertible, u.oob, u.list_type, coalesce(u.value_type, g.value_type) value_type, coalesce(u.min_value, g.min_value) min_value, coalesce(u.max_value, g.max_value) max_value from units u inner join conversion_param_units p on p.unit_id = u.id inner join unit_groups g on g.id = u.unit_group_id where p.param_id = ?1 order by u.code limit ?2 offset ?3',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, listType: row['list_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
        arguments: [paramId, pageSize, offset]);
  }

  @override
  Future<List<UnitEntity>> searchWithParamIdAndPossibleUnits({
    required String searchString,
    required int paramId,
    required int pageSize,
    required int offset,
  }) async {
    return _queryAdapter.queryList(
        'select u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, u.invertible, u.oob, u.list_type, coalesce(u.value_type, g.value_type) value_type, coalesce(u.min_value, g.min_value) min_value, coalesce(u.max_value, g.max_value) max_value from units u inner join conversion_param_units p on p.unit_id = u.id inner join unit_groups g on g.id = u.unit_group_id where p.param_id = ?2 and (u.name like ?1 or u.code like ?1) order by u.code limit ?3 offset ?4',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, listType: row['list_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
        arguments: [searchString, paramId, pageSize, offset]);
  }

  @override
  Future<List<UnitEntity>> searchWithParamId({
    required String searchString,
    required int paramId,
    required int pageSize,
    required int offset,
  }) async {
    return _queryAdapter.queryList(
        'select u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, u.invertible, u.oob, u.list_type, coalesce(u.value_type, g.value_type) value_type, coalesce(u.min_value, g.min_value) min_value, coalesce(u.max_value, g.max_value) max_value from conversion_params p inner join units u on u.unit_group_id = p.unit_group_id inner join unit_groups g on g.id = u.unit_group_id where p.id = ?2 and (u.name like ?1 or u.code like ?1) order by u.code limit ?3 offset ?4',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, listType: row['list_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
        arguments: [searchString, paramId, pageSize, offset]);
  }

  @override
  Future<UnitEntity?> getByCode(
    int unitGroupId,
    String code,
  ) async {
    return _queryAdapter.query(
        'select u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, u.invertible, u.oob, u.list_type, coalesce(u.value_type, g.value_type) value_type, coalesce(u.min_value, g.min_value) min_value, coalesce(u.max_value, g.max_value) max_value from units u inner join unit_groups g on g.id = u.unit_group_id where g.id = ?1 and u.code = ?2',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, listType: row['list_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
        arguments: [unitGroupId, code]);
  }

  @override
  Future<List<UnitEntity>> getBaseUnits(int unitGroupId) async {
    return _queryAdapter.queryList(
        'select u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, u.invertible, u.oob, u.list_type, coalesce(u.value_type, g.value_type) value_type, coalesce(u.min_value, g.min_value) min_value, coalesce(u.max_value, g.max_value) max_value from units u inner join unit_groups g on g.id = u.unit_group_id where g.id = ?1 and cast(u.coefficient as int) = 1 limit 2',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, listType: row['list_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
        arguments: [unitGroupId]);
  }

  @override
  Future<UnitEntity?> getUnit(int id) async {
    return _queryAdapter.query(
        'select u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, u.invertible, u.oob, u.list_type, coalesce(u.value_type, g.value_type) value_type, coalesce(u.min_value, g.min_value) min_value, coalesce(u.max_value, g.max_value) max_value from units u inner join unit_groups g on g.id = u.unit_group_id where u.id = ?1 limit 1',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, listType: row['list_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<UnitEntity>> getUnitsByIds(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'select u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, u.invertible, u.oob, u.list_type, coalesce(u.value_type, g.value_type) value_type, coalesce(u.min_value, g.min_value) min_value, coalesce(u.max_value, g.max_value) max_value from units u inner join unit_groups g on g.id = u.unit_group_id where u.id in (' +
            _sqliteVariablesForIds +
            ')',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, listType: row['list_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
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
        'select u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, u.invertible, u.oob, u.list_type, coalesce(u.value_type, g.value_type) value_type, coalesce(u.min_value, g.min_value) min_value, coalesce(u.max_value, g.max_value) max_value from units u inner join unit_groups g on g.id = u.unit_group_id where 1=1 and g.name = ?1 and u.unit_group_id = g.id and u.code in (' +
            _sqliteVariablesForCodes +
            ')',
        mapper: (Map<String, Object?> row) => UnitEntity(id: row['id'] as int?, name: row['name'] as String, code: row['code'] as String, symbol: row['symbol'] as String?, coefficient: row['coefficient'] as double?, unitGroupId: row['unit_group_id'] as int, valueType: row['value_type'] as int?, listType: row['list_type'] as int?, minValue: row['min_value'] as double?, maxValue: row['max_value'] as double?, invertible: row['invertible'] as int?, oob: row['oob'] as int?),
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
                  'unit_group_id': item.unitGroupId,
                  'source_unit_id': item.sourceUnitId,
                  'source_value': item.sourceValue,
                  'last_modified': item.lastModified,
                  'id': item.id
                }),
        _conversionEntityUpdateAdapter = UpdateAdapter(
            database,
            'conversions',
            ['id'],
            (ConversionEntity item) => <String, Object?>{
                  'unit_group_id': item.unitGroupId,
                  'source_unit_id': item.sourceUnitId,
                  'source_value': item.sourceValue,
                  'last_modified': item.lastModified,
                  'id': item.id
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

class _$ConversionUnitValueDaoDb extends ConversionUnitValueDaoDb {
  _$ConversionUnitValueDaoDb(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<ConversionUnitValueEntity>> getByConversionId(
      int conversionId) async {
    return _queryAdapter.queryList(
        'select * from conversion_items where conversion_id = ?1 order by sequence_num',
        mapper: (Map<String, Object?> row) => ConversionUnitValueEntity(id: row['id'] as int?, unitId: row['unit_id'] as int, value: row['value'] as String?, defaultValue: row['default_value'] as String?, sequenceNum: row['sequence_num'] as int, conversionId: row['conversion_id'] as int),
        arguments: [conversionId]);
  }

  @override
  Future<void> removeByConversionId(int conversionId) async {
    await _queryAdapter.queryNoReturn(
        'delete from conversion_items where conversion_id = ?1',
        arguments: [conversionId]);
  }
}

class _$ConversionParamValueDaoDb extends ConversionParamValueDaoDb {
  _$ConversionParamValueDaoDb(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<ConversionParamValueEntity>> getByConversionId(
      int conversionId) async {
    return _queryAdapter.queryList(
        'select * from conversion_param_values where conversion_id = ?1 order by sequence_num',
        mapper: (Map<String, Object?> row) => ConversionParamValueEntity(id: row['id'] as int?, paramId: row['param_id'] as int, unitId: row['unit_id'] as int?, calculated: row['calculated'] as int?, value: row['value'] as String?, defaultValue: row['default_value'] as String?, sequenceNum: row['sequence_num'] as int, conversionId: row['conversion_id'] as int),
        arguments: [conversionId]);
  }

  @override
  Future<void> removeByConversionId(int conversionId) async {
    await _queryAdapter.queryNoReturn(
        'delete from conversion_param_values where conversion_id = ?1',
        arguments: [conversionId]);
  }
}

class _$ConversionParamDaoDb extends ConversionParamDaoDb {
  _$ConversionParamDaoDb(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<ConversionParamEntity>> get(int setId) async {
    return _queryAdapter.queryList(
        'SELECT p.* FROM conversion_params p WHERE p.param_set_id = ?1',
        mapper: (Map<String, Object?> row) => ConversionParamEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            calculable: row['calculable'] as int?,
            unitGroupId: row['unit_group_id'] as int?,
            valueType: row['value_type'] as int,
            listType: row['list_type'] as int?,
            defaultUnitId: row['default_unit_id'] as int?,
            paramSetId: row['param_set_id'] as int),
        arguments: [setId]);
  }
}

class _$ConversionParamSetDaoDb extends ConversionParamSetDaoDb {
  _$ConversionParamSetDaoDb(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<ConversionParamSetEntity>> getBySearchString({
    required String searchString,
    required int groupId,
    required int pageSize,
    required int offset,
  }) async {
    return _queryAdapter.queryList(
        'SELECT * FROM conversion_param_sets WHERE group_id = ?2 and name like ?1 limit ?3 offset ?4',
        mapper: (Map<String, Object?> row) => ConversionParamSetEntity(id: row['id'] as int?, name: row['name'] as String, mandatory: row['mandatory'] as int?, groupId: row['group_id'] as int),
        arguments: [searchString, groupId, pageSize, offset]);
  }

  @override
  Future<List<ConversionParamSetEntity>> getByIds(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM conversion_param_sets WHERE id in (' +
            _sqliteVariablesForIds +
            ')',
        mapper: (Map<String, Object?> row) => ConversionParamSetEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            mandatory: row['mandatory'] as int?,
            groupId: row['group_id'] as int),
        arguments: [...ids]);
  }

  @override
  Future<ConversionParamSetEntity?> getFirstMandatory(int groupId) async {
    return _queryAdapter.query(
        'SELECT * FROM conversion_param_sets WHERE group_id = ?1 AND mandatory = 1 limit 1',
        mapper: (Map<String, Object?> row) => ConversionParamSetEntity(id: row['id'] as int?, name: row['name'] as String, mandatory: row['mandatory'] as int?, groupId: row['group_id'] as int),
        arguments: [groupId]);
  }

  @override
  Future<int?> getCount(int groupId) async {
    return _queryAdapter.query(
        'SELECT count(1) FROM conversion_param_sets WHERE group_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [groupId]);
  }
}

class _$ConversionParamUnitDaoDb extends ConversionParamUnitDaoDb {
  _$ConversionParamUnitDaoDb(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<int?> hasPossibleUnits(int paramId) async {
    return _queryAdapter.query(
        'SELECT CASE count(1) WHEN 0 THEN 0 ELSE 1 END FROM conversion_param_units WHERE param_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [paramId]);
  }
}
