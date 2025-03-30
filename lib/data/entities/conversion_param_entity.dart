import 'package:convertouch/data/entities/conversion_param_set_entity.dart';
import 'package:convertouch/data/entities/entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:floor/floor.dart';

const String conversionParamsTableName = 'conversion_params';

@Entity(
  tableName: conversionParamsTableName,
  indices: [
    Index(value: ['name', 'param_set_id'], unique: true),
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
class ConversionParamEntity extends ConvertouchEntity {
  final String name;
  final int? calculable;
  @ColumnInfo(name: 'unit_group_id')
  final int? unitGroupId;
  @ColumnInfo(name: 'value_type')
  final int valueType;
  @ColumnInfo(name: 'param_set_id')
  final int paramSetId;

  const ConversionParamEntity({
    super.id,
    required this.name,
    this.calculable,
    this.unitGroupId,
    required this.valueType,
    required this.paramSetId,
  });

  @override
  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'name': name,
      'calculable': calculable,
      'unit_group_id': unitGroupId,
      'param_set_id': paramSetId,
      'value_type': valueType,
    };
  }

  static Map<String, dynamic> jsonToRow(
    Map<String, dynamic> json, {
    required int? paramSetId,
    required int? paramUnitGroupId,
    List<String> excludedColumns = const [],
  }) {
    var item = json[forUpdate] ?? json;

    return minify({
      'name': item['name'],
      'calculable': bool2int(item['calculable']),
      'unit_group_id': paramUnitGroupId,
      'param_set_id': paramSetId,
      'value_type': item['valueType'] != null
          ? (item['valueType'] as ConvertouchValueType).val
          : null,
    }, excludedColumns: excludedColumns);
  }
}
