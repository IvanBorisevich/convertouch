import 'package:convertouch/domain/entities/unit_group_entity.dart';
import 'package:convertouch/domain/entities/unit_entity.dart';
import 'package:convertouch/domain/entities/unit_value_entity.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

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
  final UnitEntity? inputUnit;
  final UnitEntity? prevInputUnit;
  final List<UnitEntity> conversionUnits;
  final UnitGroupEntity unitGroup;

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
  final UnitEntity inputUnit;
  final List<UnitValueEntity> conversionItems;

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
