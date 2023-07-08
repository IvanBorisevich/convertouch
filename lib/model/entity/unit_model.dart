import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';

class UnitModel extends ItemModel {
  const UnitModel(int id, String name, this.abbreviation) :
      super(id, name, ItemType.unit);

  const UnitModel.withoutId(String name, this.abbreviation) :
      super(0, name, ItemType.unit);

  final String abbreviation;

  @override
  String toString() {
    return 'UnitModel{id: $id, name: $name, abbreviation: $abbreviation}';
  }
}
