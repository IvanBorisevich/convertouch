import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputConversionModel {
  final UnitGroupModel? unitGroup;
  final ConversionItemModel? sourceConversionItem;
  final List<UnitModel> targetUnits;

  const InputConversionModel({
    required this.unitGroup,
    required this.sourceConversionItem,
    this.targetUnits = const [],
  });

  @override
  String toString() {
    return 'InputConversionModel{'
        'unitGroup: $unitGroup, '
        'sourceConversionItem: $sourceConversionItem, '
        'targetUnits: $targetUnits}';
  }
}

class InputConversionModifyModel extends InputConversionModel {
  final UnitGroupModel? newUnitGroup;
  final UnitModel? oldUnit;
  final UnitModel? newUnit;
  final List<int> removedUnitGroupIds;
  final List<int> removedUnitIds;

  const InputConversionModifyModel({
    required super.unitGroup,
    required super.sourceConversionItem,
    super.targetUnits = const [],
    this.newUnitGroup,
    this.newUnit,
    this.oldUnit,
    this.removedUnitGroupIds = const [],
    this.removedUnitIds = const [],
  });

  @override
  String toString() {
    return 'InputConversionModifyModel{'
        'modifiedUnitGroup: $newUnitGroup, '
        'modifiedUnit: $newUnit, '
        'removedUnitGroupIds: $removedUnitGroupIds, '
        'removedUnitIds: $removedUnitIds}';
  }
}