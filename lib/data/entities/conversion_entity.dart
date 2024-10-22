import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';

const String conversionsTableName = 'conversions';

@Entity(
  tableName: conversionsTableName,
  indices: [
    Index(value: ['last_modified'], unique: true),
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
class ConversionEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  @ColumnInfo(name: 'unit_group_id')
  final int unitGroupId;
  @ColumnInfo(name: 'source_unit_id')
  final int? sourceUnitId;
  @ColumnInfo(name: 'source_value')
  final String? sourceValue;
  @ColumnInfo(name: 'last_modified')
  final int lastModified;

  const ConversionEntity({
    this.id,
    required this.unitGroupId,
    this.sourceUnitId,
    this.sourceValue,
    required this.lastModified,
  });

  static Map<String, Object?> entityToRow(Map<String, dynamic> entity) {
    return {
      'id': entity['id'],
      'unit_group_id': entity['unitGroupId'],
      'source_unit_id': entity['sourceUnitId'],
      'source_value': entity['source_value'],
      'last_modified': DateTime.now().millisecondsSinceEpoch,
    };
  }
}
