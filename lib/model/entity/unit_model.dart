import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';

class UnitModel extends ItemModel {
  const UnitModel(
      int id,
      String name,
      String abbreviation
      ) :
        _abbreviation = abbreviation,
        super(id, name, ItemType.unit);

  final String _abbreviation;

  String get abbreviation => _abbreviation;

  @override
  String toString() {
    return 'UnitModel{id: $id, name: $name, _abbreviation: $_abbreviation}';
  }
}
