import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputItemUnitReplaceModel<T extends ItemValueModel> {
  final T item;
  final UnitModel newUnit;

  const InputItemUnitReplaceModel({
    required this.item,
    required this.newUnit,
  });
}
