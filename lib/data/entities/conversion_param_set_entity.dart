import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';

const String conversionParamSetsTableName = 'conversion_param_sets';

@Entity(
  tableName: conversionParamSetsTableName,
  indices: [
    Index(value: ['name', 'group_id'], unique: true),
  ],
  foreignKeys: [
    ForeignKey(
      childColumns: ['group_id'],
      parentColumns: ['id'],
      entity: UnitGroupEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class ConversionParamSetEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final bool mandatory;
  @ColumnInfo(name: 'group_id')
  final int groupId;

  const ConversionParamSetEntity({
    this.id,
    required this.name,
    required this.mandatory,
    required this.groupId,
  });
}