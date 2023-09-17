import 'package:convertouch/domain/constants.dart';
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
  final int id;
  final String name;
  @ColumnInfo(name: 'icon_name')
  final String iconName;

  const UnitGroupEntity({
    required this.id,
    required this.name,
    this.iconName = unitGroupDefaultIconName,
  });
}
