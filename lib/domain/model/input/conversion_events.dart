import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConversionEvent extends Equatable {
  const ConversionEvent();

  @override
  List<Object?> get props => [];
}

class BuildConversion extends ConversionEvent {
  final UnitGroupModel? unitGroup;
  final ConversionItemModel? sourceConversionItem;
  final List<UnitModel>? units;

  const BuildConversion({
    required this.unitGroup,
    required this.sourceConversionItem,
    required this.units,
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

class RemoveConversionItem extends ConversionEvent {
  final UnitGroupModel? unitGroupInConversion;
  final int itemUnitId;
  final List<ConversionItemModel> conversionItems;

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

class RestoreLastConversion extends ConversionEvent {
  const RestoreLastConversion();

  @override
  String toString() {
    return 'RestoreLastConversion{}';
  }
}
