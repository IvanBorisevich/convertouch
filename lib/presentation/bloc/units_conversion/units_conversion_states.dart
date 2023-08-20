import 'package:convertouch/domain/entities/unit_group_entity.dart';
import 'package:convertouch/domain/entities/unit_entity.dart';
import 'package:convertouch/domain/entities/unit_value_entity.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';

abstract class UnitsConversionState extends ConvertouchBlocState {
  const UnitsConversionState();
}

class UnitsConversionEmptyState extends UnitsConversionState {
  const UnitsConversionEmptyState();

  @override
  String toString() {
    return 'UnitsConversionEmptyState{}';
  }
}

class ConversionInitializing extends UnitsConversionState {
  const ConversionInitializing();

  @override
  String toString() {
    return 'ConversionInitializing{}';
  }
}

class ConversionInitialized extends UnitsConversionState {
  const ConversionInitialized({
    required this.sourceUnitValue,
    required this.sourceUnit,
    required this.conversionItems,
    required this.unitGroup,
  });

  final String sourceUnitValue;
  final UnitEntity sourceUnit;
  final List<UnitValueEntity> conversionItems;
  final UnitGroupEntity unitGroup;

  @override
  List<Object> get props => [
    sourceUnitValue,
    sourceUnit,
    conversionItems,
    unitGroup,
  ];

  @override
  String toString() {
    return 'ConversionInitialized{'
        'sourceUnitValue: $sourceUnitValue, '
        'sourceUnit: $sourceUnit, '
        'conversionItems: $conversionItems, '
        'unitGroup: $unitGroup}';
  }
}

class UnitConverting extends UnitsConversionState {
  const UnitConverting();

  @override
  String toString() {
    return 'UnitConverting{}';
  }
}

class UnitConverted extends UnitsConversionState {
  const UnitConverted({
    required this.unitValue
  });

  final UnitValueEntity unitValue;

  @override
  List<Object> get props => [
    unitValue
  ];

  @override
  String toString() {
    return 'UnitConverted{unitValue: $unitValue}';
  }
}