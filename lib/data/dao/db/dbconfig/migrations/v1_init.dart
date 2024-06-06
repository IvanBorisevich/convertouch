import 'package:convertouch/data/dao/db/dbconfig/migrations/migration.dart';
import 'package:convertouch/domain/constants/default_units.dart';
import 'package:sqflite/sqflite.dart';

class InitialMigration extends ConvertouchDbMigration {
  @override
  Future<void> execute(Database database) async {
    ConvertouchDbMigration.fillUnits(
      database,
      entities: unitsData[0],
    );
  }
}
