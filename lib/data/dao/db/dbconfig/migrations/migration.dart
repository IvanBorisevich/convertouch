import 'package:sqflite/sqflite.dart';

abstract class ConvertouchDbMigration {
  Future<void> execute(Database database);
}