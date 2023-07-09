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

class UnitsConverting extends UnitsConversionState {
  const UnitsConverting();

  @override
  String toString() {
    return 'UnitsConverting{}';
  }
}

class UnitsConverted extends UnitsConversionState {
  const UnitsConverted({
    required this.sourceUnitValue,
    required this.sourceUnitId,
    required this.convertedUnitValues,
    required this.unitGroup,
  });

  final String sourceUnitValue;
  final int sourceUnitId;
  final List<UnitValueModel> convertedUnitValues;
  final UnitGroupModel unitGroup;

  @override
  List<Object> get props => [
    sourceUnitValue,
    sourceUnitId,
    convertedUnitValues,
    unitGroup,
  ];

  @override
  String toString() {
    return 'UnitsConverted{'
        'sourceUnitValue: $sourceUnitValue, '
        'sourceUnitId: $sourceUnitId, '
        'convertedUnitValues: $convertedUnitValues, '
        'unitGroup: $unitGroup}';
  }
}