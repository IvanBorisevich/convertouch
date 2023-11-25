import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class UnitsConversionEvent extends ConvertouchEvent {
  const UnitsConversionEvent();
}

class InitializeConversion extends UnitsConversionEvent {
  const InitializeConversion({
    this.inputValue,
    this.inputUnit,
    this.prevInputUnit,
    this.conversionUnits,
    this.unitGroup,
  });

  final double? inputValue;
  final UnitModel? inputUnit;
  final UnitModel? prevInputUnit;
  final List<UnitModel>? conversionUnits;
  final UnitGroupModel? unitGroup;

  @override
  List<Object?> get props => [
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

class RemoveConversion extends UnitsConversionEvent {
  final UnitValueModel unitValueModel;
  final List<UnitValueModel> currentConversionItems;
  final UnitGroupModel unitGroup;

  const RemoveConversion({
    required this.unitValueModel,
    required this.currentConversionItems,
    required this.unitGroup,
  });

  @override
  List<Object> get props => [
    unitValueModel,
    currentConversionItems,
    unitGroup,
  ];

  @override
  String toString() {
    return 'RemoveConversion{unitValueModel: $unitValueModel, '
        'currentConversionItems: $currentConversionItems, '
        'unitGroup: $unitGroup'
        '}';
  }
}
