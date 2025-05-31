import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputItemUnitReplaceModel<T extends ConversionItemValueModel> {
  final T item;
  final UnitModel newUnit;

  const InputItemUnitReplaceModel({
    required this.item,
    required this.newUnit,
  });
}
