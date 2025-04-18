import 'dart:developer';

import 'package:convertouch/data/const/oob_params.dart';
import 'package:convertouch/data/const/oob_units.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration.dart';
import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:sqflite/sqflite.dart';

class Migration3to4 extends ConvertouchDbMigration {
  @override
  Future<void> execute(Database database) async {
    log("Migration database from version 3 to 4");

    bool columnNew = await SqlUtils.isColumnNew(
      database,
      tableName: 'units',
      columnName: 'list_type',
    );

    if (columnNew) {
      await database.execute('''
        ALTER TABLE units ADD COLUMN list_type INTEGER
      ''');
    }

    await database.execute('''
      CREATE TABLE IF NOT EXISTS `conversion_param_sets` (
        `name` TEXT NOT NULL, 
        `mandatory` INTEGER, 
        `group_id` INTEGER NOT NULL, 
        `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
        FOREIGN KEY (`group_id`) REFERENCES `unit_groups` (`id`) 
          ON UPDATE NO ACTION ON DELETE CASCADE
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS `conversion_params` (
        `name` TEXT NOT NULL, 
        `calculable` INTEGER, 
        `unit_group_id` INTEGER, 
        `value_type` INTEGER NOT NULL, 
        `list_type` INTEGER,
        `default_unit_id` INTEGER, 
        `param_set_id` INTEGER NOT NULL, 
        `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
        FOREIGN KEY (`param_set_id`) REFERENCES `conversion_param_sets` (`id`) 
          ON UPDATE NO ACTION ON DELETE CASCADE
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS `conversion_param_units` (
        `param_id` INTEGER NOT NULL, 
        `unit_id` INTEGER NOT NULL, 
        `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
        FOREIGN KEY (`param_id`) REFERENCES `conversion_params` (`id`) 
          ON UPDATE NO ACTION ON DELETE CASCADE, 
        FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) 
          ON UPDATE NO ACTION ON DELETE CASCADE
      )  
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS `conversion_param_values` (
        `param_id` INTEGER NOT NULL, 
        `unit_id` INTEGER, 
        `calculated` INTEGER, 
        `value` TEXT, 
        `default_value` TEXT, 
        `sequence_num` INTEGER NOT NULL, 
        `conversion_id` INTEGER NOT NULL, 
        `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
        FOREIGN KEY (`conversion_id`) REFERENCES `conversions` (`id`) 
          ON UPDATE NO ACTION ON DELETE CASCADE
      )
    ''');

    await database.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS 
        `index_conversion_param_sets_name_group_id` 
      ON `conversion_param_sets` (`name`, `group_id`)
    ''');
    await database.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS 
        `index_conversion_params_name_param_set_id` 
      ON `conversion_params` (`name`, `param_set_id`)
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS `index_conversion_param_units_param_id` 
      ON `conversion_param_units` (`param_id`)
    ''');
    await database.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS 
        `index_conversion_param_values_param_id_conversion_id` 
      ON `conversion_param_values` (`param_id`, `conversion_id`)
    ''');

    await SqlUtils.mergeGroupsAndUnits(
      database,
      items: unitsV4,
    );

    await SqlUtils.mergeConversionParams(
      database,
      items: conversionParamsV1,
    );
  }
}
