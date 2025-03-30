import 'dart:async';

import 'package:convertouch/data/dao/db/conversion_dao_db.dart';
import 'package:convertouch/data/dao/db/conversion_param_value_dao_db.dart';
import 'package:convertouch/data/dao/db/conversion_unit_value_dao_db.dart';
import 'package:convertouch/data/dao/db/conversion_param_dao_db.dart';
import 'package:convertouch/data/dao/db/conversion_param_set_dao_db.dart';
import 'package:convertouch/data/dao/db/dbhelper/dbhelper.dart';
import 'package:convertouch/data/dao/db/dynamic_value_dao_db.dart';
import 'package:convertouch/data/dao/db/unit_dao_db.dart';
import 'package:convertouch/data/dao/db/unit_group_dao_db.dart';
import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:convertouch/data/entities/conversion_item_value_entity.dart';
import 'package:convertouch/data/entities/conversion_param_entity.dart';
import 'package:convertouch/data/entities/conversion_param_set_entity.dart';
import 'package:convertouch/data/entities/conversion_param_unit_entity.dart';
import 'package:convertouch/data/entities/dynamic_value_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'dbconfig.g.dart';

@Database(
  version: ConvertouchDatabaseHelper.dbVersion,
  entities: [
    UnitGroupEntity,
    UnitEntity,
    DynamicValueEntity,
    ConversionEntity,
    ConversionUnitValueEntity,
    ConversionParamSetEntity,
    ConversionParamEntity,
    ConversionParamUnitEntity,
    ConversionParamValueEntity,
  ],
)
abstract class ConvertouchDatabase extends FloorDatabase {
  UnitGroupDaoDb get unitGroupDao;

  UnitDaoDb get unitDao;

  DynamicValueDaoDb get dynamicValueDao;

  ConversionDaoDb get conversionDao;

  ConversionUnitValueDaoDb get conversionUnitValueDao;

  ConversionParamValueDaoDb get conversionParamValueDao;

  ConversionParamDaoDb get conversionParamDao;

  ConversionParamSetDaoDb get conversionParamSetDao;
}
