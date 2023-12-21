import 'package:convertouch/domain/constants/constants.dart';
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

  const UnitGroupEntity({
    this.id,
    required this.name,
    this.iconName,
    this.conversionType,
    this.refreshable,
  });

  static UnitGroupEntity fromJson(Map<String, dynamic> data) {
    String? iconName = data['iconName'];
    int? conversionType = data['conversionType'];
    return UnitGroupEntity(
      name: data['name'],
      iconName: iconName != unitGroupDefaultIconName ? iconName : null,
      conversionType: conversionType != 0 ? conversionType : null,
      refreshable: data['refreshable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconName': iconName != unitGroupDefaultIconName ? iconName : null,
      'conversionType': conversionType != 0 ? conversionType : null,
      'refreshable': refreshable,
    };
  }
}
