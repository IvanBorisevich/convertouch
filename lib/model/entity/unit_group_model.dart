import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';

class UnitGroupModel extends ItemModelWithIdName {
  UnitGroupModel({
    int id = 0,
    required String name,
    this.iconName = unitGroupDefaultIconName
  }) : super(id: id, name: name, itemType: ItemType.unitGroup);

  final String iconName;

  @override
  String toString() {
    return 'UnitGroupModel{'
        'id: $id, '
        'name: $name, '
        'iconName: $iconName}';
  }
}
