import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:floor/floor.dart';

const String refreshableValuesTableName = 'refreshable_values';

@Entity(
  tableName: refreshableValuesTableName,
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
class RefreshableValueEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  @ColumnInfo(name: "unit_id")
  final int unitId;
  final String value;

  const RefreshableValueEntity({
    this.id,
    required this.unitId,
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit_id': unitId,
      'value': value,
    };
  }
}