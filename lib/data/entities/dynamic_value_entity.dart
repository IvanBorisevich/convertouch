import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:floor/floor.dart';

const String dynamicValuesTableName = 'refreshable_values';

@Entity(
  tableName: dynamicValuesTableName,
  indices: [
    Index(value: ['unit_id'], unique: true),
  ],
  foreignKeys: [
    ForeignKey(
      childColumns: ['unit_id'],
      parentColumns: ['id'],
      entity: UnitEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class DynamicValueEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  @ColumnInfo(name: "unit_id")
  final int unitId;
  final String? value;

  const DynamicValueEntity({
    this.id,
    required this.unitId,
    this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit_id': unitId,
      'value': value,
    };
  }
}