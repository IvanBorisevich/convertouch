import 'package:convertouch/data/entities/entity.dart';
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
class ConversionEntity extends ConvertouchEntity {
  @ColumnInfo(name: 'unit_group_id')
  final int unitGroupId;
  @ColumnInfo(name: 'source_unit_id')
  final int? sourceUnitId;
  @ColumnInfo(name: 'source_value')
  final String? sourceValue;
  @ColumnInfo(name: 'last_modified')
  final int lastModified;

  const ConversionEntity({
    super.id,
    required this.unitGroupId,
    this.sourceUnitId,
    this.sourceValue,
    required this.lastModified,
  });

  @override
  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'unit_group_id': unitGroupId,
      'source_unit_id': sourceUnitId,
      'source_value': sourceValue,
      'last_modified': lastModified,
    };
  }

  @override
  String toString() {
    return 'ConversionEntity{'
        'id: $id, '
        'unitGroupId: $unitGroupId, '
        'sourceUnitId: $sourceUnitId, '
        'sourceValue: $sourceValue, '
        'lastModified: $lastModified}';
  }
}
