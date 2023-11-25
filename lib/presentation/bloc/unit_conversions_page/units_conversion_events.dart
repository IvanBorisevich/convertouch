import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_states.dart';

abstract class UnitsConversionEvent extends ConvertouchPageEvent {
  const UnitsConversionEvent({
    super.currentPageId = unitsConversionPageId,
    super.currentState = ConversionInitialized,
    super.startPageIndex = 0,
    super.unitGroupInConversion,
  });
}

class InitializeConversion extends UnitsConversionEvent {
  final UnitValueModel? sourceConversionItem;
  final List<UnitModel>? unitsInConversion;

  const InitializeConversion({
    this.sourceConversionItem,
    this.unitsInConversion,
    super.unitGroupInConversion,
  });

  @override
  List<Object?> get props => [
    sourceConversionItem,
    unitsInConversion,
    super.props,
  ];

  @override
  String toString() {
    return 'InitializeConversion{'
        'sourceConversionItem: $sourceConversionItem, '
        'unitsInConversion: $unitsInConversion, '
        '${super.toString()}}';
  }
}

class FetchUnitGroupsForConversion extends UnitsConversionEvent {
  const FetchUnitGroupsForConversion({
    super.unitGroupInConversion,
  });

  @override
  String toString() {
    return 'FetchUnitGroupsForConversion{${super.toString()}}';
  }
}

class FetchUnitsForConversion extends UnitsConversionEvent {
  const FetchUnitsForConversion({
    required super.unitGroupInConversion,
  });

  @override
  String toString() {
    return 'FetchUnitsForConversion{${super.toString()}}';
  }
}

class RemoveConversion extends UnitsConversionEvent {
  final int unitIdBeingRemoved;
  final List<UnitValueModel> conversionItems;

  const RemoveConversion({
    required this.unitIdBeingRemoved,
    required this.conversionItems,
    required super.unitGroupInConversion,
  });

  @override
  List<Object> get props => [
    unitIdBeingRemoved,
    conversionItems,
    super.props,
  ];

  @override
  String toString() {
    return 'RemoveConversion{'
        'unitIdBeingRemoved: $unitIdBeingRemoved, '
        'conversionItems: $conversionItems, '
        '${super.toString()}}';
  }
}
