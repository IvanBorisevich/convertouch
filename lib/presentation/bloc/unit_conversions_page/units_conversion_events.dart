import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:equatable/equatable.dart';

abstract class UnitsConversionEvent extends Equatable {
  const UnitsConversionEvent();

  @override
  List<Object?> get props => [];
}

class BuildConversion extends UnitsConversionEvent {
  final UnitGroupModel? unitGroup;
  final UnitValueModel? sourceConversionItem;
  final List<UnitModel>? units;

  const BuildConversion({
    this.unitGroup,
    this.sourceConversionItem,
    this.units,
  });

  @override
  List<Object?> get props => [
    unitGroup,
    sourceConversionItem,
    units,
  ];

  @override
  String toString() {
    return 'BuildConversion{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'units: $units}';
  }
}

class RemoveConversionItem extends UnitsConversionEvent {
  final UnitGroupModel? unitGroupInConversion;
  final int itemUnitId;
  final List<UnitValueModel> conversionItems;

  const RemoveConversionItem({
    required this.unitGroupInConversion,
    required this.itemUnitId,
    required this.conversionItems,
  });

  @override
  List<Object?> get props => [
    unitGroupInConversion,
    itemUnitId,
    conversionItems,
  ];

  @override
  String toString() {
    return 'RemoveConversionItem{'
        'unitGroupInConversion: $unitGroupInConversion, '
        'itemUnitId: $itemUnitId, '
        'conversionItems: $conversionItems}';
  }
}
