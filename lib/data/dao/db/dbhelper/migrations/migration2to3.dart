import 'dart:developer';

import 'package:convertouch/data/dao/db/dbhelper/migration.dart';
import 'package:sqflite/sqflite.dart';

class Migration2to3 extends ConvertouchDbMigration {
  @override
  Future<void> execute(Database database) async {
    log("Migration database from version 2 to 3");

    await database.execute(
      'CREATE TABLE IF NOT EXISTS `conversions` ('
      '`id` INTEGER PRIMARY KEY AUTOINCREMENT, '
      '`unit_group_id` INTEGER NOT NULL, '
      '`source_unit_id` INTEGER, '
      '`source_value` TEXT, '
      '`last_modified` INTEGER NOT NULL, '
      'FOREIGN KEY (`unit_group_id`) REFERENCES `unit_groups` (`id`) '
      ' ON UPDATE NO ACTION ON DELETE CASCADE)',
    );
    await database.execute(
      'CREATE TABLE IF NOT EXISTS `conversion_items` ('
      '`id` INTEGER PRIMARY KEY AUTOINCREMENT, '
      '`unit_id` INTEGER NOT NULL, '
      '`value` TEXT, '
      '`default_value` TEXT, '
      '`sequence_num` INTEGER NOT NULL, '
      '`conversion_id` INTEGER NOT NULL, '
      'FOREIGN KEY (`conversion_id`) REFERENCES `conversions` (`id`) '
      ' ON UPDATE NO ACTION ON DELETE CASCADE)',
    );

    await database.execute(
      'CREATE UNIQUE INDEX `index_conversions_last_modified` '
      'ON `conversions` (`last_modified`)',
    );
    await database.execute(
      'CREATE UNIQUE INDEX `index_conversion_items_unit_id_conversion_id` '
      'ON `conversion_items` (`unit_id`, `conversion_id`)',
    );
  }
}
