import 'package:floor/floor.dart';

const String unitGroupsTableName = 'unit_groups';

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
  final int? oob;

  const UnitGroupEntity({
    this.id,
    required this.name,
    this.iconName,
    this.conversionType,
    this.refreshable,
    this.oob,
  });
}
