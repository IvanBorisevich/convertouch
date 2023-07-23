import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitsConversionEvent extends ConvertouchEvent {
  const UnitsConversionEvent();
}

class InitializeConversion extends UnitsConversionEvent {
  const InitializeConversion({
    this.inputValue = "1",
    this.inputUnit,
    this.prevInputUnit,
    required this.conversionUnits,
    required this.unitGroup,
  });

  final String inputValue;
  final UnitModel? inputUnit;
  final UnitModel? prevInputUnit;
  final List<UnitModel> conversionUnits;
  final UnitGroupModel unitGroup;

  @override
  List<Object> get props => [
    inputValue,
    conversionUnits,
    unitGroup,
  ];

  @override
  String toString() {
    return 'InitializeConversion{'
        'inputValue: $inputValue, '
        'inputUnit: $inputUnit, '
        'prevInputUnit: $prevInputUnit, '
        'conversionUnits: $conversionUnits, '
        'unitGroup: $unitGroup}';
  }
}

class ConvertUnitValue extends UnitsConversionEvent {
  const ConvertUnitValue({
    required this.inputValue,
    required this.inputUnit,
    required this.conversionItems,
  });

  final String inputValue;
  final UnitModel inputUnit;
  final List<UnitValueModel> conversionItems;

  @override
  List<Object> get props => [
    inputValue,
    inputUnit,
    conversionItems,
  ];

  @override
  String toString() {
    return 'ConvertUnitValue{'
        'inputValue: $inputValue, '
        'inputUnit: $inputUnit, '
        'conversionUnitValues: $conversionItems}';
  }
}
