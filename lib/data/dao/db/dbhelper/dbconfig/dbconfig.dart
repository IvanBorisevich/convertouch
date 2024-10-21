import 'dart:async';

import 'package:convertouch/data/dao/db/conversion_dao_db.dart';
import 'package:convertouch/data/dao/db/conversion_item_dao_db.dart';
import 'package:convertouch/data/dao/db/dbhelper/dbhelper.dart';
import 'package:convertouch/data/dao/db/dynamic_value_dao_db.dart';
import 'package:convertouch/data/dao/db/unit_dao_db.dart';
import 'package:convertouch/data/dao/db/unit_group_dao_db.dart';
import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:convertouch/data/entities/conversion_item_entity.dart';
import 'package:convertouch/data/entities/dynamic_value_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'dbconfig.g.dart';

@Database(
  version: ConvertouchDatabaseHelper.databaseVersion,
  entities: [
    UnitGroupEntity,
    UnitEntity,
    DynamicValueEntity,
    ConversionEntity,
    ConversionItemEntity,
  ],
)
abstract class ConvertouchDatabase extends FloorDatabase {
  UnitGroupDaoDb get unitGroupDao;

  UnitDaoDb get unitDao;

  DynamicValueDaoDb get dynamicValueDao;

  ConversionDaoDb get conversionDao;

  ConversionItemDaoDb get conversionItemDao;
}
