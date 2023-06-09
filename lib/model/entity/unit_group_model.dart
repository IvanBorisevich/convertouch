import 'package:convertouch/model/entity/id_name_model.dart';
import 'package:convertouch/model/util/assets_util.dart';

class UnitGroupModel extends IdNameModel {
  UnitGroupModel(int id, String name,
      {String iconName = unitGroupDefaultIconName})
      : _iconName = iconName,
        super(id, name);

  final String _iconName;

  String get iconName {
    return _iconName;
  }
}
