import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';

class UnitValueModel extends ItemModel {
  const UnitValueModel(this.unit, this.value) : super(ItemType.unitValue);

  final UnitModel unit;
  final String value;
}