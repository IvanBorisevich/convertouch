import 'package:sqflite/sqflite.dart';

abstract class ConvertouchDbMigration {
  const ConvertouchDbMigration();

  Future<void> execute(Database database);
}
