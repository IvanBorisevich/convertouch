import 'dart:async';

import 'package:convertouch/data/dao/db/refreshable_value_dao_db.dart';
import 'package:convertouch/data/dao/db/unit_dao_db.dart';
import 'package:convertouch/data/dao/db/unit_group_dao_db.dart';
import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'dbconfig.g.dart';

const int dbVersion = 1;

@Database(
  version: dbVersion,
  entities: [
    UnitGroupEntity,
    UnitEntity,
    RefreshableValueEntity,
  ],
)
abstract class ConvertouchDatabase extends FloorDatabase {
  static const String databaseName = "convertouch_database.db";

  UnitGroupDaoDb get unitGroupDao;

  UnitDaoDb get unitDao;

  RefreshableValueDaoDb get refreshableValueDao;
}
