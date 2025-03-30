import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:convertouch/data/entities/entity.dart';
import 'package:floor/floor.dart';

const String conversionUnitValuesTableName = 'conversion_items';
const String conversionParamValuesTableName = 'conversion_param_values';

abstract class ConversionItemValueEntity extends ConvertouchEntity {
  final String? value;
  @ColumnInfo(name: 'default_value')
  final String? defaultValue;
  @ColumnInfo(name: 'sequence_num')
  final int sequenceNum;
  @ColumnInfo(name: 'conversion_id')
  final int conversionId;

  const ConversionItemValueEntity({
    super.id,
    this.value,
    this.defaultValue,
    required this.sequenceNum,
    required this.conversionId,
  });
}

@Entity(
  tableName: conversionUnitValuesTableName,
  indices: [
    Index(value: ['unit_id', 'conversion_id'], unique: true),
  ],
  foreignKeys: [
    ForeignKey(
      childColumns: ['conversion_id'],
      parentColumns: ['id'],
      entity: ConversionEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class ConversionUnitValueEntity extends ConversionItemValueEntity {
  @ColumnInfo(name: 'unit_id')
  final int unitId;

  const ConversionUnitValueEntity({
    super.id,
    required this.unitId,
    super.value,
    super.defaultValue,
    required super.sequenceNum,
    required super.conversionId,
  });

  @override
  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'unit_id': unitId,
      'value': value,
      'default_value': defaultValue,
      'sequence_num': sequenceNum,
      'conversion_id': conversionId,
    };
  }
}

@Entity(
  tableName: conversionParamValuesTableName,
  indices: [
    Index(value: ['param_id', 'conversion_id'], unique: true),
  ],
  foreignKeys: [
    ForeignKey(
      childColumns: ['conversion_id'],
      parentColumns: ['id'],
      entity: ConversionEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class ConversionParamValueEntity extends ConversionItemValueEntity {
  @ColumnInfo(name: 'param_id')
  final int paramId;
  @ColumnInfo(name: 'unit_id')
  final int? unitId;
  final int? calculated;

  const ConversionParamValueEntity({
    super.id,
    required this.paramId,
    this.unitId,
    this.calculated,
    super.value,
    super.defaultValue,
    required super.sequenceNum,
    required super.conversionId,
  });

  @override
  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'param_id': paramId,
      'unit_id': unitId,
      'calculated': calculated,
      'value': value,
      'default_value': defaultValue,
      'sequence_num': sequenceNum,
      'conversion_id': conversionId,
    };
  }
}
