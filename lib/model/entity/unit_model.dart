import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';

class UnitModel extends ItemModelWithIdName {
  const UnitModel({
    int id = 0,
    required String name,
    this.coefficient = 1,
    required this.abbreviation
  }) : super(id: id, name: name, itemType: ItemType.unit);

  final double coefficient;
  final String abbreviation;

  @override
  String toString() {
    return 'UnitModel{id: $id, name: $name, abbreviation: $abbreviation}';
  }
}
