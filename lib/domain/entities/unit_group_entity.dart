import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/entities/item_entity.dart';

class UnitGroupEntity extends ItemModelWithIdName {
  const UnitGroupEntity({
    int id = 0,
    required String name,
    this.iconName = unitGroupDefaultIconName
  }) : super(id: id, name: name, itemType: ItemType.unitGroup);

  @override
  List<Object> get props => [id, name, itemType, iconName];

  final String iconName;

  @override
  String toString() {
    return 'UnitGroupModel{'
        'id: $id, '
        'name: $name, '
        'iconName: $iconName}';
  }
}
