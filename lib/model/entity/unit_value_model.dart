import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';

class UnitValueModel extends ItemModel {
  const UnitValueModel({
    required this.unit,
    required this.value
  }) : super(itemType: ItemType.unitValue);

  final UnitModel unit;
  final String value;

  @override
  List<Object> get props => [itemType, unit, value];

  @override
  String toString() {
    return 'UnitValueModel{unit: $unit, value: $value}';
  }
}