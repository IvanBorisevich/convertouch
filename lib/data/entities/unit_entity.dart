import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:floor/floor.dart';

const String unitsTableName = 'units';

@Entity(
  tableName: unitsTableName,
  indices: [
    Index(value: ['code', 'unit_group_id'], unique: true),
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
  final String code;
  final String? symbol;
  final double? coefficient;
  @ColumnInfo(name: 'unit_group_id')
  final int unitGroupId;
  @ColumnInfo(name: 'value_type')
  final int? valueType;
  @ColumnInfo(name: 'min_value')
  final double? minValue;
  @ColumnInfo(name: 'max_value')
  final double? maxValue;
  final int? oob;

  const UnitEntity({
    this.id,
    required this.name,
    required this.code,
    this.symbol,
    this.coefficient,
    required this.unitGroupId,
    this.valueType,
    this.minValue,
    this.maxValue,
    this.oob,
  });

  UnitEntity.coalesce({
    required UnitEntity savedEntity,
    double? coefficient,
  }) : this(
          id: savedEntity.id,
          name: savedEntity.name,
          code: savedEntity.code,
          unitGroupId: savedEntity.unitGroupId,
          coefficient: ObjectUtils.coalesce(
            what: savedEntity.coefficient,
            patchWith: coefficient,
          ),
          symbol: savedEntity.symbol,
          valueType: savedEntity.valueType,
          minValue: savedEntity.minValue,
          maxValue: savedEntity.maxValue,
        );

  static Map<String, Object?> entityToRow(
    Map<String, dynamic> entity,
    int unitGroupId,
  ) {
    return {
      'name': entity['name'],
      'code': entity['code'],
      'symbol': entity['symbol'],
      'coefficient': entity['coefficient'],
      'unit_group_id': unitGroupId,
      'value_type': entity['valueType'] != null
          ? (entity['valueType'] as ConvertouchValueType).val
          : null,
      'min_value': entity['minValue'],
      'max_value': entity['maxValue'],
      'oob': entity['oob'] ?? 1,
    };
  }
}
