import 'package:convertouch/data/entities/conversion_param_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:floor/floor.dart';

const String conversionParamUnitsTableName = 'conversion_param_units';

@Entity(
  tableName: conversionParamUnitsTableName,
  indices: [
    Index(value: ['param_id'], unique: false),
  ],
  foreignKeys: [
    ForeignKey(
      childColumns: ['param_id'],
      parentColumns: ['id'],
      entity: ConversionParamEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
    ForeignKey(
      childColumns: ['unit_id'],
      parentColumns: ['id'],
      entity: UnitEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class ConversionParamUnitEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  @ColumnInfo(name: 'param_id')
  final int paramId;
  @ColumnInfo(name: 'unit_id')
  final int unitId;

  const ConversionParamUnitEntity({
    this.id,
    required this.paramId,
    required this.unitId,
  });
}