import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class RemoveConversionItemsUseCase
    extends AbstractModifyConversionUseCase<RemoveConversionItemsDelta> {
  const RemoveConversionItemsUseCase({
    required super.buildNewConversionUseCase,
  });

  @override
  UnitGroupModel modifyConversionGroup(
    UnitGroupModel unitGroup,
    RemoveConversionItemsDelta delta,
  ) {
    return unitGroup;
  }

  @override
  ConversionItemModel? modifySourceConversionItem(
    ConversionItemModel? sourceItem,
    RemoveConversionItemsDelta delta,
  ) {
    if (delta.unitIds.contains(sourceItem?.unit.id)) {
      return null;
    }
    return sourceItem;
  }

  @override
  Map<int, UnitModel> modifyTargetUnits(
    Map<int, UnitModel> targetUnits,
    RemoveConversionItemsDelta delta,
  ) {
    targetUnits.removeWhere((unitId, unit) => delta.unitIds.contains(unitId));
    return targetUnits;
  }
}
