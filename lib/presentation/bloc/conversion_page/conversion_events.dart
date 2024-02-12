import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ConversionEvent extends ConvertouchEvent {
  const ConversionEvent();
}

class BuildConversion extends ConversionEvent {
  final InputConversionModel conversionParams;
  final UnitModel? modifiedUnit;
  final List<int> removedUnitIds;

  const BuildConversion({
    required this.conversionParams,
    this.modifiedUnit,
    this.removedUnitIds = const [],
  });

  @override
  List<Object?> get props => [
        conversionParams,
        modifiedUnit,
        removedUnitIds,
      ];

  @override
  String toString() {
    return 'BuildConversion{'
        'conversionParams: $conversionParams, '
        'modifiedUnit: $modifiedUnit, '
        'removedUnitIds: $removedUnitIds}';
  }
}

class RebuildConversionOnValueChange extends BuildConversion {
  const RebuildConversionOnValueChange({
    required super.conversionParams,
  });
}

class RebuildConversionAfterUnitReplacement extends BuildConversion {
  final UnitModel newUnit;
  final UnitModel oldUnit;

  const RebuildConversionAfterUnitReplacement({
    required this.newUnit,
    required this.oldUnit,
    required super.conversionParams,
  });

  @override
  List<Object?> get props => [
        newUnit,
        oldUnit,
        super.props,
      ];

  @override
  String toString() {
    return 'RebuildConversionAfterUnitReplacement{'
        'newUnit: $newUnit, '
        'oldUnit: $oldUnit, '
        'conversionParams: $conversionParams}';
  }
}

class ShowNewConversionAfterRefresh extends ConversionEvent {
  final OutputConversionModel newConversion;

  const ShowNewConversionAfterRefresh({
    required this.newConversion,
  });

  @override
  List<Object?> get props => [
        newConversion,
      ];

  @override
  String toString() {
    return 'ShowNewConversionAfterRefresh{'
        'newConversion: $newConversion}';
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

class GetLastSavedConversion extends ConversionEvent {
  const GetLastSavedConversion();

  @override
  String toString() {
    return 'GetLastSavedConversion{}';
  }
}
