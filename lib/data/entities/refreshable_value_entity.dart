import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: unitsTableName,
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
  final int id;
  @ColumnInfo(name: "unit_id")
  final int unitId;
  final String value;

  const RefreshableValueEntity({
    required this.id,
    required this.unitId,
    required this.value,
  });
}