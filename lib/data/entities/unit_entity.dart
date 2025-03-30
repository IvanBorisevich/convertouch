import 'package:convertouch/data/entities/entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';
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
class UnitEntity extends ConvertouchEntity {
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
  final int? invertible;
  final int? oob;

  const UnitEntity({
    super.id,
    required this.name,
    required this.code,
    this.symbol,
    this.coefficient,
    required this.unitGroupId,
    this.valueType,
    this.minValue,
    this.maxValue,
    this.invertible,
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
          coefficient: coefficient ?? savedEntity.coefficient,
          symbol: savedEntity.symbol,
          valueType: savedEntity.valueType,
          minValue: savedEntity.minValue,
          maxValue: savedEntity.maxValue,
          invertible: savedEntity.invertible,
          oob: savedEntity.oob,
        );

  @override
  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'symbol': symbol,
      'coefficient': coefficient,
      'unit_group_id': unitGroupId,
      'value_type': valueType,
      'min_value': minValue,
      'max_value': maxValue,
      'invertible': invertible,
      'oob': oob,
    };
  }

  static Map<String, dynamic> jsonToRow(
    Map<String, dynamic> json, {
    required int? unitGroupId,
    List<String> excludedColumns = const [],
  }) {
    var item = json[forUpdate] ?? json;

    return minify({
      'name': item['name'],
      'code': item['code'] is ClothingSizeCode
          ? (item['code'] as ClothingSizeCode).name
          : item['code'],
      'symbol': item['symbol'],
      'coefficient': item['coefficient'],
      'unit_group_id': unitGroupId,
      'value_type': item['valueType'] != null
          ? (item['valueType'] as ConvertouchValueType).val
          : null,
      'min_value': item['minValue'],
      'max_value': item['maxValue'],
      'invertible': bool2int(item['invertible']),
      'oob': bool2int(item['oob'], ifNull: 1),
    }, excludedColumns: excludedColumns);
  }
}
