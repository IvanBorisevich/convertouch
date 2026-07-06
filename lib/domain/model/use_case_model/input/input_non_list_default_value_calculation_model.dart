import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputNonListDefaultValueCalculationModel<T extends IdNameItemModel> {
  final T item;
  final String conversionGroupName;
  final UnitModel? currentParamUnit;
  final UnitModel? replacingUnit;

  const InputNonListDefaultValueCalculationModel({
    required this.item,
    required this.conversionGroupName,
    this.currentParamUnit,
    this.replacingUnit,
  });
}
