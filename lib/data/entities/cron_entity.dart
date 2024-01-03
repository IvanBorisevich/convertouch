import 'package:floor/floor.dart';

const String cronTableName = 'cron';

@Entity(
  tableName: cronTableName,
)

class CronEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String expression;

  const CronEntity({
    this.id,
    required this.name,
    required this.expression,
  });
}