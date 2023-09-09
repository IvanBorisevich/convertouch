import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
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
    this.sourceUnitValue,
    required this.sourceUnit,
    required this.conversionItems,
    required this.unitGroup,
  });

  final double? sourceUnitValue;
  final UnitModel sourceUnit;
  final List<UnitValueModel> conversionItems;
  final UnitGroupModel unitGroup;

  @override
  List<Object> get props => [
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

class UnitsConversionErrorState extends UnitsConversionState {
  final String message;

  const UnitsConversionErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'UnitsConversionErrorState{message: $message}';
  }
}