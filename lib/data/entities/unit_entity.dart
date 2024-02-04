import 'package:convertouch/data/entities/unit_group_entity.dart';
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
  final int? oob;

  const UnitEntity({
    this.id,
    required this.name,
    required this.code,
    this.symbol,
    this.coefficient,
    required this.unitGroupId,
    this.oob,
  });

  UnitEntity.coalesce({
    required UnitEntity savedEntity,
    double? coefficient,
    String? symbol,
  }) : this(
          id: savedEntity.id,
          name: savedEntity.name,
          code: savedEntity.code,
          unitGroupId: savedEntity.unitGroupId,
          coefficient: ObjectUtils.coalesce(
            what: savedEntity.coefficient,
            patchWith: coefficient,
          ),
          symbol: ObjectUtils.coalesce(
            what: savedEntity.symbol,
            patchWith: symbol,
          ),
        );
}
