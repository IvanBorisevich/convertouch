import 'package:convertouch/domain/constants/constants.dart';
import 'package:floor/floor.dart';

const String unitGroupsTableName = 'unit_groups';
const Map<String, String> _entityToRowFieldsMapping = {
  'groupName': 'name',
  'iconName': 'icon_name',
  'conversionType': 'conversion_type',
  'valueType': 'value_type',
  'minValue': 'min_value',
  'maxValue': 'max_value',
};

@Entity(
  tableName: unitGroupsTableName,
  indices: [
    Index(value: ['name'], unique: true),
  ],
)
class UnitGroupEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
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
    this.id,
    required this.name,
    this.iconName,
    this.conversionType,
    this.refreshable,
    required this.valueType,
    this.minValue,
    this.maxValue,
    this.oob,
  });

  static Map<String, Object?> entityToRow(
    Map<String, dynamic> entity, {
    bool initDefaults = true,
  }) {
    if (initDefaults) {
      return {
        'name': entity['groupName'],
        'icon_name': entity['iconName'],
        'conversion_type': entity['conversionType'] != null &&
                entity['conversionType'] != ConversionType.static
            ? (entity['conversionType'] as ConversionType).value
            : null,
        'refreshable': entity['refreshable'] == true ? 1 : null,
        'value_type': (entity['valueType'] as ConvertouchValueType).val,
        'min_value': entity['minValue'],
        'max_value': entity['maxValue'],
        'oob': entity['oob'] ?? 1,
      };
    } else {
      return entity.map(
        (key, value) => MapEntry(_entityToRowFieldsMapping[key] ?? key, value),
      )..removeWhere((key, value) => key == 'units');
    }
  }
}
