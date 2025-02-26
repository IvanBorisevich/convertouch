import 'package:convertouch/data/entities/conversion_param_set_entity.dart';
import 'package:floor/floor.dart';

const String conversionParamsTableName = 'conversion_params';

@Entity(
  tableName: conversionParamsTableName,
  indices: [
    Index(value: ['name', 'param_set_id'], unique: false),
  ],
  foreignKeys: [
    ForeignKey(
      childColumns: ['param_set_id'],
      parentColumns: ['id'],
      entity: ConversionParamSetEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class ConversionParamEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final bool calculable;
  @ColumnInfo(name: 'unit_group_id')
  final int? unitGroupId;
  @ColumnInfo(name: 'selected_unit_id')
  final int? selectedUnitId;
  @ColumnInfo(name: 'list_type')
  final int? listType;
  @ColumnInfo(name: 'param_set_id')
  final int paramSetId;

  const ConversionParamEntity({
    this.id,
    required this.name,
    required this.calculable,
    this.unitGroupId,
    this.selectedUnitId,
    this.listType,
    required this.paramSetId,
  });
}
