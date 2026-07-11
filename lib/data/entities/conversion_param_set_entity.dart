import 'package:convertouch/data/entities/entity.dart';
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
class ConversionParamSetEntity extends ConvertouchEntity {
  final String name;
  final int? mandatory;
  @ColumnInfo(name: 'group_id')
  final int groupId;
  @ColumnInfo(name: 'icon_name')
  final String? iconName;

  const ConversionParamSetEntity({
    super.id,
    required this.name,
    this.mandatory,
    required this.groupId,
    this.iconName,
  });

  @override
  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'name': name,
      'mandatory': mandatory,
      'group_id': groupId,
      'icon_name': iconName,
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
      'mandatory': bool2int(item['mandatory']),
      'group_id': unitGroupId,
      'icon_name': item['iconName'],
    }, excludedColumns: excludedColumns);
  }
}
