import 'package:convertouch/data/entities/entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:floor/floor.dart';

const String unitGroupsTableName = 'unit_groups';

@Entity(
  tableName: unitGroupsTableName,
  indices: [
    Index(value: ['name'], unique: true),
  ],
)
class UnitGroupEntity extends ConvertouchEntity {
  final String name;
  @ColumnInfo(name: 'icon_name')
  final String? iconName;
  @ColumnInfo(name: 'conversion_type')
  final int? conversionType;
  final int? refreshable;
  @ColumnInfo(name: 'value_type')
  final int valueType;
  @ColumnInfo(name: 'min_value')
  final double? minValue;
  @ColumnInfo(name: 'max_value')
  final double? maxValue;
  final int? oob;

  const UnitGroupEntity({
    super.id,
    required this.name,
    this.iconName,
    this.conversionType,
    this.refreshable,
    required this.valueType,
    this.minValue,
    this.maxValue,
    this.oob,
  });

  @override
  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'name': name,
      'icon_name': iconName,
      'conversion_type': conversionType,
      'refreshable': refreshable,
      'value_type': valueType,
      'min_value': minValue,
      'max_value': maxValue,
      'oob': oob,
    };
  }

  static Map<String, dynamic> jsonToRow(
    Map<String, dynamic> json, {
    List<String> excludedColumns = const [],
  }) {
    var item = json[forUpdate] ?? json;

    return minify({
      'name': item['groupName'],
      'icon_name': item['iconName'],
      'conversion_type': item['conversionType'] != null
          ? (item['conversionType'] as ConversionType).value
          : null,
      'refreshable': bool2int(item['refreshable']),
      'value_type': item['valueType'] != null
          ? (item['valueType'] as ConvertouchValueType).val
          : null,
      'min_value': item['minValue'],
      'max_value': item['maxValue'],
      'oob': bool2int(item['oob'], ifNull: 1),
    }, excludedColumns: excludedColumns);
  }
}
