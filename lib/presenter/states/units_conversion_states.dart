import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

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
    required this.sourceUnitId,
    required this.conversionItems,
    required this.unitGroup
  });

  final String sourceUnitValue;
  final int sourceUnitId;
  final List<UnitValueModel> conversionItems;
  final UnitGroupModel unitGroup;

  @override
  List<Object> get props => [
    sourceUnitValue,
    sourceUnitId,
    conversionItems,
    unitGroup,
  ];

  @override
  String toString() {
    return 'ConversionInitialized{'
        'sourceUnitValue: $sourceUnitValue, '
        'sourceUnitId: $sourceUnitId, '
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

  final UnitValueModel unitValue;

  @override
  List<Object> get props => [
    unitValue
  ];

  @override
  String toString() {
    return 'UnitConverted{unitValue: $unitValue}';
  }
}