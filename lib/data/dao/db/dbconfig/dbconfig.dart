import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:convertouch/data/dao/db/unit_group_dao_db.dart';
import 'package:convertouch/data/dao/db/unit_dao_db.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';

part 'dbconfig.g.dart';

@Database(
  version: 2,
  entities: [
    UnitGroupEntity,
    UnitEntity,
  ],
)
abstract class ConvertouchDatabase extends FloorDatabase {
  UnitGroupDaoDb get unitGroupDao;
  UnitDaoDb get unitDao;
}

final migration1to2 = Migration(1, 2, (database) {
  database.execute(
      'CREATE TABLE IF NOT EXISTS `units` ('
      '`id` INTEGER PRIMARY KEY AUTOINCREMENT, '
      '`name` TEXT NOT NULL, '
      '`abbreviation` TEXT NOT NULL, '
      '`coefficient` REAL, '
      '`unit_group_id` INTEGER NOT NULL, '
      'FOREIGN KEY (`unit_group_id`) '
      ' REFERENCES `unit_groups` (`id`)'
      ' ON UPDATE NO ACTION ON DELETE CASCADE)');
  return database.execute(
      'CREATE UNIQUE INDEX `index_units_name_unit_group_id` '
      'ON `units` (`name`, `unit_group_id`)');
});
