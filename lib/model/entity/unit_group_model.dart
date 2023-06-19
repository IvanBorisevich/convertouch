import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/item_type.dart';


class UnitGroupModel extends ItemModel {
  const UnitGroupModel(
      int id,
      String name,
      {
        String iconName = unitGroupDefaultIconName
      }) :
        _iconName = iconName,
        super(id, name, ItemType.unitGroup);

  final String _iconName;

  String get iconName => _iconName;
}
