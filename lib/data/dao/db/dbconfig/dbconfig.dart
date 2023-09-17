import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:convertouch/data/dao/db/unit_group_dao_db.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';

part 'dbconfig.g.dart';

@Database(
  version: 1,
  entities: [
    UnitGroupEntity,
  ],
)
abstract class ConvertouchDatabase extends FloorDatabase {
  UnitGroupDaoDb get unitGroupDao;
}
