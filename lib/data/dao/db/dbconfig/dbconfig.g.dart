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
            'CREATE TABLE IF NOT EXISTS `unit_groups` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `icon_name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `units` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `abbreviation` TEXT NOT NULL, `coefficient` REAL NOT NULL, `unit_group_id` INTEGER NOT NULL, FOREIGN KEY (`unit_group_id`) REFERENCES `unit_groups` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_unit_groups_name` ON `unit_groups` (`name`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_units_name_unit_group_id` ON `units` (`name`, `unit_group_id`)');

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
                  'icon_name': item.iconName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UnitGroupEntity> _unitGroupEntityInsertionAdapter;

  @override
  Future<List<UnitGroupEntity>> fetchUnitGroups() async {
    return _queryAdapter.queryList('select * from unit_groups',
        mapper: (Map<String, Object?> row) => UnitGroupEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            iconName: row['icon_name'] as String));
  }

  @override
  Future<UnitGroupEntity?> getUnitGroup(int id) async {
    return _queryAdapter.query(
        'select * from unit_groups where id = ?1 limit 1',
        mapper: (Map<String, Object?> row) => UnitGroupEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            iconName: row['icon_name'] as String),
        arguments: [id]);
  }

  @override
  Future<int> addUnitGroup(UnitGroupEntity unitGroupEntity) {
    return _unitGroupEntityInsertionAdapter.insertAndReturnId(
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
                  'abbreviation': item.abbreviation,
                  'coefficient': item.coefficient,
                  'unit_group_id': item.unitGroupId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UnitEntity> _unitEntityInsertionAdapter;

  @override
  Future<List<UnitEntity>> fetchUnitsOfGroup(int unitGroupId) async {
    return _queryAdapter.queryList(
        'select * from units where unit_group_id = ?1',
        mapper: (Map<String, Object?> row) => UnitEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            abbreviation: row['abbreviation'] as String,
            coefficient: row['coefficient'] as double,
            unitGroupId: row['unit_group_id'] as int),
        arguments: [unitGroupId]);
  }

  @override
  Future<UnitEntity?> getBaseUnit(int unitGroupId) async {
    return _queryAdapter.query(
        'select * from units where unit_group_id = ?1 and coefficient = 1',
        mapper: (Map<String, Object?> row) => UnitEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            abbreviation: row['abbreviation'] as String,
            coefficient: row['coefficient'] as double,
            unitGroupId: row['unit_group_id'] as int),
        arguments: [unitGroupId]);
  }

  @override
  Future<UnitEntity?> getFirstUnit(int unitGroupId) async {
    return _queryAdapter.query(
        'select * from units where unit_group_id = ?1 limit 1',
        mapper: (Map<String, Object?> row) => UnitEntity(
            id: row['id'] as int?,
            name: row['name'] as String,
            abbreviation: row['abbreviation'] as String,
            coefficient: row['coefficient'] as double,
            unitGroupId: row['unit_group_id'] as int),
        arguments: [unitGroupId]);
  }

  @override
  Future<int> addUnit(UnitEntity unit) {
    return _unitEntityInsertionAdapter.insertAndReturnId(
        unit, OnConflictStrategy.abort);
  }
}
