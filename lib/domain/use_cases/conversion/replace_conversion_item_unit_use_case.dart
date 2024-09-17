import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class ReplaceConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionItemUnitDelta> {
  const ReplaceConversionItemUnitUseCase({
    required super.buildNewConversionUseCase,
  });

  @override
  UnitGroupModel modifyConversionGroup(
    UnitGroupModel unitGroup,
    ReplaceConversionItemUnitDelta delta,
  ) {
    return unitGroup;
  }

  @override
  ConversionItemModel? modifySourceConversionItem(
    ConversionItemModel? sourceItem,
    ReplaceConversionItemUnitDelta delta,
  ) {
    return ConversionItemModel.coalesce(
      sourceItem,
      unit: delta.newUnit,
    );
  }

  @override
  Map<int, UnitModel> modifyTargetUnits(
    Map<int, UnitModel> targetUnits,
    ReplaceConversionItemUnitDelta delta,
  ) {
    return targetUnits.map((key, value) => key == delta.oldUnitId
        ? MapEntry(delta.newUnit.id!, delta.newUnit)
        : MapEntry(key, value));
  }
}
