import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';

const String unitsTableName = 'units';

@Entity(
  tableName: unitsTableName,
  indices: [
    Index(value: ['name', 'unit_group_id'], unique: true),
  ],
  foreignKeys: [
    ForeignKey(
      childColumns: ['unit_group_id'],
      parentColumns: ['id'],
      entity: UnitGroupEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class UnitEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String abbreviation;
  final double coefficient;
  @ColumnInfo(name: 'unit_group_id')
  final int unitGroupId;

  const UnitEntity({
    this.id,
    required this.name,
    required this.abbreviation,
    required this.coefficient,
    required this.unitGroupId,
  });
}
