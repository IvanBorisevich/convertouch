import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';


class UnitGroupModel extends ItemModelWithIdName {
  UnitGroupModel(
      int id,
      String name,
      {
        this.iconName = unitGroupDefaultIconName,
        this.ciUnitId
      }) :
        super(id, name, ItemType.unitGroup);

  final String iconName;
  int? ciUnitId;
  UnitModel? ciUnit;

  @override
  String toString() {
    return 'UnitGroupModel{'
        'id: $id, '
        'name: $name, '
        'iconName: $iconName, '
        'ciUnit: $ciUnit}';
  }
}
