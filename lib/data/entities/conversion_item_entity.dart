import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:floor/floor.dart';

const String conversionItemsTableName = 'conversion_items';

@Entity(
  tableName: conversionItemsTableName,
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
class ConversionItemEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  @ColumnInfo(name: 'unit_id')
  final int unitId;
  final String? value;
  @ColumnInfo(name: 'default_value')
  final String? defaultValue;
  @ColumnInfo(name: 'sequence_num')
  final int sequenceNum;
  @ColumnInfo(name: 'conversion_id')
  final int conversionId;

  const ConversionItemEntity({
    this.id,
    required this.unitId,
    this.value,
    this.defaultValue,
    required this.sequenceNum,
    required this.conversionId,
  });

  Map<String, dynamic> toDbRow() {
    return {
      'unit_id': unitId,
      'value': value,
      'default_value': defaultValue,
      'sequence_num': sequenceNum,
      'conversion_id': conversionId,
    };
  }
}
